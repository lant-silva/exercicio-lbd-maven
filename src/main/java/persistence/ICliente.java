package persistence;

import java.sql.SQLException;
import model.Cliente;

public interface ICliente {
	public String iudCliente(String acao, Cliente c) throws SQLException, ClassNotFoundException;
}
