<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./css/styles.css">
<meta charset="ISO-8859-1">
<title>CRUD - Cliente</title>
</head>
<body>
	<div>
		<jsp:include page="menu.jsp" />
	</div>
	<br />
	<div>
		<div align="center" class="container">
			<form action="cliente" method="post">
				<p class="title">
					<b>Cliente</b>
				<p />
				<table>
					<tr>
						<td colspan="3"><input class="input_data" type="number"
							maxlength="11" id="cpf" name="cpf" placeholder="CPF"
							value='<c:out value="${cliente.cpf}"></c:out>'>
						<td />
						<td><input type="submit" id="botao" name="botao"
							value="Buscar">
						<td />
					<tr />
					<tr>
						<td colspan="4"><input class="input_data" type="text"
							maxlength="100" id="nome" name="nome" placeholder="Nome"
							value='<c:out value="${cliente.nome}"></c:out>'></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="text"
							maxlength="200" id="email" name="email"
							placeholder="Email" value='<c:out value="${cliente.email}"></c:out>'></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="number"
							min="0" id="limiteCredito" name="limiteCredito" placeholder="Limite de Credito" 
							value='<c:out value="${cliente.limiteCredito}"></c:out>'></td>
					</tr>
					<tr>
						<td colspan="4"><input class="input_data" type="date"
							id="dataNasc" name="dataNasc"
							value='<c:out value="${cliente.dataNasc}"></c:out>'></td>
					</tr>
					<tr>
						<td><input type="submit" id="botao" name="botao"
							value="Cadastrar"></td>
						<td><input type="submit" id="botao" name="botao"
							value="Alterar"></td>
						<td><input type="submit" id="botao" name="botao"
							value="Excluir"></td>
						<td><input type="submit" id="botao" name="botao"
							value="Listar"></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<br />
	<div align="center">
		<c:if test="${not empty erro }">
			<H2>
				<b><c:out value="${erro }" /></b>
			</H2>
		</c:if>
	</div>
	<br />
	<div align="center">
		<c:if test="${not empty erro }">
			<H2>
				<b><c:out value="${erro }" /></b>
			</H2>
		</c:if>
	</div>
	<div align="center">
		<c:if test="${not empty clientes }">
			<table class="table_round">
				<thead>
					<tr>
						<th>CPF</th>
						<th>Nome</th>
						<th>Email</th>
						<th>Limite de Crédito</th>
						<th>Data de Nascimento</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="c" items="${clientes}">
						<tr>
							<td><c:out value="${c.cpf}" /></td>
							<td><c:out value="${c.nome}" /></td>
							<td><c:out value="${c.email}" /></td>
							<td><c:out value="${c.limiteCredito}" /></td>
							<td><c:out value="${c.dataNasc}" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>