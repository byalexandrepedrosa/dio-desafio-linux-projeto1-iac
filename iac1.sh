#!/usr/bin/env bash
# //TDC -> 2 - Todo provisionamento deve ser feito em um arquivo do tipo Bash Script;


#######BEGIN SCRIPT##############
# Script criado para o Desafio de Projeto da DIO referente ao Bootcamp - Linux Experience
# (https://web.dio.me/)
#
# Requerimentos do Desafio:
# (Referente a funcionalidade do Script - ordem a seguir segue a do desafio e não a da execução)
#
# 1 - Excluir diretórios, arquivos, grupos e usuários criados anteriormente;
# 2 - Todo provisionamento deve ser feito em um arquivo do tipo Bash Script;
# 3 - Deve-se criar os diretórios /publico /adm /ven /sec;
# 4 - Deve-se criar os grupos GRP_AMD, GRP_VEN, GRP_SEC;
# 5 - Deve-se criar os usuários carlos, maria, joao, debora, sebastiana, josefina, amanda, rogerio;
# 6 - O dono de todos os diretórios criados será o usuário root;
# 7 - Demais atruibuições devem seguir a imagem do slide do desafio;
# 8 - Todos os usuários terão permissão total dentro do diretório publico;
# 9 - Os usuários de cada grupo terão permissão total dentro de seu respectivo diretório;
# 10 - Os usuários não poderão ter permissão de leitura, escrita e execução em diretórios de departamentos que eles não pertencem;
#
# //TDC -> = TODO Completado referenciado (leia pode se copiar o texto a seguir da flag e buscar no código usando search)
#


# Arrays para otimização
# (Se no futuro precisar adicionar ou remover usuários, basta alterar no array)
declare -a GRP_ADM=("carlos" "maria" "joao")
declare -a GRP_SEC=("josefina" "amanda" "rogerio")
declare -a GRP_VEN=("debora" "sebastiana" "roberto")


#######
# //TDC -> 1 - Excluir diretórios, arquivos, grupos e usuários criados anteriormente;
#######

echo "Verificando a existência de diretorios de processos anteriores e removendo se encontrado."


if [ -d /publico ] || [ -L /publico ] ; then
	rm -rf /publico
fi

if [ -d /adm ] || [ -L /adm ] ; then
	rm -rf /adm
fi

if [ -d /ven ] || [ -L /ven ] ; then
	rm -rf /ven
fi

if [ -d /sec ] || [ -L /sec ] ; then
	rm -rf /sec
fi

echo "Verificando a existência de usuários de processos anteriores e removendo se encontrado."

# Verifica se existe usuários com id acima de 1000 (mantendo assim o usuário da instalação que é o id 1000)
# Evita a exclusão do usuário nobody (id 65534)
while IFS=':' read -r user passwd uid gid comment home shell;  do
	if [ "$uid" -gt 1000 ] && [ "$uid" -lt 65534 ] ; then
		userdel -r $user
	fi
done < /etc/passwd

echo "Verificando a existência de grupos de processos anteriores e removendo se encontrado."

# Verifica se existe grupos com id acima de 1000 (mantendo assim o grupo da instalação que é o id 1000)
# Evita a exclusão do grupo nobody (id 65534)
while IFS=':' read -r group passwd gid glist;  do
	if [ "$gid" -gt 1000 ] && [ "$gid" -lt 65534 ] ; then
		groupdel -f $group
	fi
done < /etc/group


#######
# //TDC -> 4 - Deve-se criar os grupos GRP_AMD, GRP_VEN, GRP_SEC;
#######

echo "Criando grupos de usuários..."

groupadd GRP_ADM
groupadd GRP_SEC
groupadd GRP_VEN


#######
# //TDC -> 5 - Deve-se criar os usuários carlos, maria, joao, debora, sebastiana, josefina, amanda, rogerio;
# //TDC -> 7 - Demais atruibuições devem seguir a imagem do slide do desafio;
#
# The -crypt option was removed in OpenSSL 3.0.
# https://manpages.ubuntu.com/manpages/kinetic/en/man1/openssl-passwd.1ssl.html
#######

echo "Criando usuários..."

# Criando usuários do Grupo GRP_ADM
for User in "${GRP_ADM[@]}"
do
	useradd $User -m -s /bin/bash -p $(openssl passwd Senha123) -G GRP_ADM
done

# Criando usuários do Grupo GRP_SEC
for User in "${GRP_SEC[@]}"
do
	useradd $User -m -s /bin/bash -p $(openssl passwd Senha123) -G GRP_SEC
done

# Criando usuários do Grupo GRP_VEN
for User in "${GRP_VEN[@]}"
do
	useradd $User -m -s /bin/bash -p $(openssl passwd Senha123) -G GRP_VEN
done


#######
# //TDC -> 3 - Deve-se criar os diretórios /publico /adm /ven /sec;
# //TDC -> 6 - O dono de todos os diretórios criados será o usuário root;
#######

echo "Criando diretórios..."

mkdir /publico
mkdir /adm
mkdir /ven
mkdir /sec


#######
# //TDC -> 8 - Todos os usuários terão permissão total dentro do diretório publico;
# //TDC -> 9 - Os usuários de cada grupo terão permissão total dentro de seu respectivo diretório;
# //TDC -> 10 - Os usuários não poderão ter permissão de leitura, escrita e execução em diretórios de departamentos que eles não pertencem;
#######

echo "Especificando permissões dos diretórios...."

chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

chmod 770 /adm
chmod 770 /ven
chmod 770 /sec
chmod 777 /publico


# Limpa os arrays
unset GRP_ADM
unset GRP_SEC
unset GRP_VEN
