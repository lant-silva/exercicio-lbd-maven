package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import model.Cliente;

public class ClienteDao implements ICrud<Cliente>, ICliente{
	private GenericDao gDao;
	
	public ClienteDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public void inserir(Cliente t) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);
		cDao.iudCliente("I", t);
	}

	@Override
	public void atualizar(Cliente t) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);
		cDao.iudCliente("U", t);
	}

	@Override
	public void excluir(Cliente t) throws SQLException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);
		cDao.iudCliente("D", t);
	}

	@Override
	public Cliente consultar(Cliente t) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, email, limite_de_credito, dt_nasc FROM cliente WHERE cpf = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, t.getCpf());
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			t.setCpf(rs.getString("cpf"));
			t.setNome(rs.getString("nome"));
			t.setEmail(rs.getString("email"));
			t.setLimiteCredito(rs.getFloat("limite_de_credito"));
			t.setDataNasc(rs.getString("dt_nasc"));
		}
		rs.close();
		ps.close();
		c.close();
		return t;
	}

	@Override
	public List<Cliente> listar() throws SQLException, ClassNotFoundException {
		List<Cliente> clientes = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, email, limite_de_credito, dt_nasc FROM cliente";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while(rs.next()) {
			Cliente cl = new Cliente();
			cl.setCpf(rs.getString("cpf"));
			cl.setNome(rs.getString("nome"));
			cl.setEmail(rs.getString("email"));
			cl.setLimiteCredito(rs.getFloat("limite_de_credito"));
			cl.setDataNasc(rs.getString("dt_nasc"));
			clientes.add(cl);
		}
		rs.close();
		ps.close();
		c.close();
		return clientes;
	}

	@Override
	public String iudCliente(String acao, Cliente c) throws SQLException, ClassNotFoundException {
		Connection C = gDao.getConnection();
		String sql = "{CALL sp_iudcliente (?,?,?,?,?,?,?)}";
		CallableStatement cs = C.prepareCall(sql);
		cs.setString(1, acao);
		cs.setString(2, c.getCpf());
		cs.setString(3, c.getNome());
		cs.setString(4, c.getEmail());
		cs.setFloat(5, c.getLimiteCredito());
		cs.setObject(6, c.getDataNasc());
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(7);
		
		cs.close();
		C.close();
		return saida;
	}
}
