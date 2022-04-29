# 🏦🎲 DML-person-customer

### _Procedure com opções de insert, delete e update._

_<a href='https://github.com/CloretoJannuzzi/DML-person-customer/blob/main/dml.sql'> Clique aqui para ver o código</a>_

- A tabela pessoa consiste em colunas(id_pessoa(PK identity), nome, sobrenome e CPF)
- A tabela de relação para transformar a pessoa em um cliente consiste em somente(id_cliente(PK identity), id_pessoa(FK unique))
- Esta procedure eu criei com o objetivo de me auxiliar em um sistema de criação de cliente, atualização de dados do cliente e deletar o cliente.

_O que é store procedures?_

Basicamente, ele serve pra guardar uma query, para se executada depois, quase do mesmo jeito que uma função em python.

_O que esse código faz?_

- Ele basicamente primeiro cria uma pessoa e insere seu id pessoa na tabela cliente;
- No segundo ele atualiza os dados da pessoa se ela for cliente;
- No terceiro ele deleta a pessoa se for cliente;
20por fim no quarto ele lista todas as pessoas que são clientes.


PS: Não testei mas acredito na minha lógica rs(Fiz somente alguns testes isolados das opções) o Foco é somente poder consultar depois o que fiz.
