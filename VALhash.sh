#!/bin/bash

#Software VALhash, desenvolvido e utilizado com o objetivo de automatizar o processo de validação de códigos Hash (validação de criptografia).
#Autor: Kevin Pires Novaes

#inicialização das variáveis para acertar funcionamento dos loops
var=true; #variável de controle do while
hash=0; #variável que recebe a hash disponibilizada
filed="vazio"; #variável que recebe o endereço do arquivo inserido 
hash_type=0; #variável que recebe o tipo de hash

while $var;
do

	ans=$(zenity --width 200 --height 200 --question --title "VALhash" --text "`printf "Bem-vindo ao programa VALhash, utilizado para Validação de Hashes!\n\nSiga os passos:\n1 - Escolha o arquivo que quer validar;\n2 - Escolha o tipo de hash;\n3 - Digite ou cole a hash disponibilizada;\n4 - Realize a validação."`" --extra-button "1 - Inserção de Arquivo" --extra-button "2 - Tipo de Hash" --extra-button "3 - Hash Disponibilizada" --ok-label "4 - Validar [`printf "\u2714"`]" --cancel-label "Cancela [`printf "\u274c\n"`]"); #tela inicial 
	rc=$?; #variável que controla o clique de botões da tela inicial

	if [[ $ans == '1 - Inserção de Arquivo' ]]; then #caso botão 1 é clicado
		filed=$(zenity --title "Seleção de arquivo" --file-selection --multiple --filename "${HOME}/"); #arquivo inserido

	elif [[ $ans == '2 - Tipo de Hash' ]]; then #caso botão 2 é clicado
		hash_type=$(zenity  --list  --title "Tipo de Hash" --text "Escolha o tipo de código hash utilizado para validação:" --radiolist  --column "Clique" --column "Hash" TRUE md5 FALSE sha1 FALSE sha256 FALSE sha512); #escolha do tipo de hash

		if [[ $filed == "vazio" || $filed == "" ]]; then #tratamento de exceção caso nenhum arquivo seja inserido antes de escolher o tipo de hash
			zenity --warning --title "Atenção!" --text="Você precisa inserir um arquivo primeiro!" #aviso
		else
			case $hash_type in #cálculo do código hash do arquivo inserido de acordo com o tipo de hash escolhida
				"md5")
					hash_param=$(md5sum $filed);
					;;
				"sha1")
					hash_param=$(sha1sum $filed);
					;;
				"sha256")
					hash_param=$(sha256sum $filed);
					;;
				"sha512")
					hash_param=$(sha512sum $filed);
					;;
				*)
			esac
		fi

	elif [[ $ans == "3 - Hash Disponibilizada" ]]; then
		hash=$(zenity --entry --title "Código Hash" --text "Digite (ou cole) o código hash: "); #hash disponibilizada é atribuída
		hash=$(echo $hash | cut -d ' ' -f1); #tratamento de exceção, caso a hash inserida no campo interior contenha espaços em branco no início e/ou final 

	elif [[ ! $ans && $rc -eq 1 ]]; then #caso botão Cancela for clicado ou a interface do software seja fechada, o programa se encerra 
		var=false;

	elif [[ ! $ans && $rc -eq 0 ]]; then #valor padrão de $ans é 'false' quando o botão ok (4) ou cancel (Cancela) é clicado; este é o botão 4, que quando clicado dispara a comparação de hashes
		hashparam=$(echo $hash_param | cut -d ' ' -f1); #tratamento da variável, pois a resposta dos programas shasum e md5sum inserem o diretório do arquivo na frente da hash, dessa forma o comando separa as informações atribuindo à variável somente o código hash calculado


		if [[ $hash == 0 || $filed == "vazio" || $hash_type == 0 ]]; then #tratamento de exceção caso o passo a passo do programa não seja seguido, pulando alguma etapa e realizando a validação 
		zenity --warning --title "Atenção!" --text="Você precisa realizar alguma etapa anterior para prosseguir."

		elif [[ $hash == "" || $filed == "" || $hash_type == "" ]]; then #tratamento de exceção caso o passo a passo do programa não seja seguido, não escolhendo alguma opção que deveria ou não inserindo algo válido nos campos pertinentes e realizando a validação
		zenity --warning --title "Atenção!" --text="Algum campo foi deixado em branco ou não concluído."

		else #validação dos códigos hash caso todo o passo a passo descrito na tela inicial do programa seja seguido corretamente
		var=false;
			if [ "$hashparam" == "$hash" ]; then #validação correta
				zenity --info --title "Sucesso!" --width 300 --text "Validação de Hashes feita com sucesso!";
			else #erro na validação
				zenity --info --title "Erro!" --width 300 --text "Validação de Hashes incorreta!";
			fi

		fi

	fi

done		
