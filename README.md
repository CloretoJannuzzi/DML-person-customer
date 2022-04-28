# 🏦🎲 DML-person-customer

### _Procedure com opções de insert, delete e update._

_<a href='https://github.com/CloretoJannuzzi/DML-person-customer/blob/main/dml.sql'> Clique aqui para ver o código</a>_

- A tabela pessoa consiste em colunas(id_pessoa(PK identity), nome, sobrenome e CPF)
- A tabela de relação para transformar a pessoa em um cliente consiste em somente(id_cliente(PK identity), id_pessoa(FK unique))
- Esta procedure eu criei com o objetivo de me auxiliar em um sistema de criação de cliente, atualização de dados do cliente e deletar o cliente.

PS: Não testei mas confio na minha lógica rs(Fiz somente alguns testes isolados das opções) e talvez na 3 eu não precise usar os dois ifs.
