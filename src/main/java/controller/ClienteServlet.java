package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Cliente;
import persistence.ClienteDao;
import persistence.GenericDao;

@WebServlet("/cliente")
public class ClienteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public ClienteServlet() {
        super();
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getParameter("botao");
		String cpf = request.getParameter("cpf");
		String nome = request.getParameter("nome");
		String email = request.getParameter("email");
		String limiteCredito = request.getParameter("limiteCredito");
		String dataNasc = request.getParameter("dataNasc");
		
		//saida
		String saida="";
		String erro="";
		Cliente c = new Cliente();
		List<Cliente> clientes = new ArrayList<>();
		
		if(!cmd.contains("Listar")) {
			c.setCpf(cpf);
		}
		if(cmd.contains("Cadastrar") || cmd.contains("Alterar")){
			c.setNome(nome);
			c.setEmail(email);
			c.setLimiteCredito(Float.parseFloat(limiteCredito));
			c.setDataNasc(dataNasc);
		}
		try {
			if(cmd.contains("Cadastrar")) {
				saida = cadastrarCliente(c);
				c = null;
			}
			if(cmd.contains("Alterar")) {
				saida = atualizarCliente(c);
				c = null;
			}
			if(cmd.contains("Excluir")) {
				saida = excluirCliente(c);
				c = null;
			}
			if(cmd.contains("Buscar")) {
				c = buscarCliente(c);
			}
			if(cmd.contains("Listar")) {
				clientes = listarClientes();
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		}finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("cliente", c);
			request.setAttribute("clientes", clientes);
			
			RequestDispatcher rd = request.getRequestDispatcher("cliente.jsp");
			rd.forward(request, response);
		}
	}
	private String cadastrarCliente(Cliente c) throws SQLException, ClassNotFoundException{
		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);
		String saida = cDao.iudCliente("I", c);
		return saida;
	}
	private String atualizarCliente(Cliente c) throws SQLException, ClassNotFoundException{
		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);
		String saida = cDao.iudCliente("U", c);
		return saida;
	}
	private String excluirCliente(Cliente c) throws SQLException, ClassNotFoundException{
		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);
		String saida = cDao.iudCliente("D", c);
		return saida;
	}
	private Cliente buscarCliente(Cliente c) throws SQLException, ClassNotFoundException{
		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);
		c = cDao.consultar(c);
		return c;
	}
	private List<Cliente> listarClientes()throws SQLException, ClassNotFoundException{
		List<Cliente> clientes = new ArrayList<>();
		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);
		clientes = cDao.listar();
		return clientes;
	}

}
