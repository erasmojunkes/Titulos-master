HA$PBExportHeader$nv_titulos.sru
forward
global type nv_titulos from nonvisualobject
end type
end forward

global type nv_titulos from nonvisualobject
end type
global nv_titulos nv_titulos

type variables
nv_Funcoes inv_Funcoes
uo_Progresso iuo_BarraProgresso
String is_Arquivo1, is_Arquivo2
String is_CaminhoArquivo1
Long il_Forma, il_idClifor, il_idEmpresa, il_idUsuario
Date idt_Movimento

Datawindow idw_contabil_avulso, idw_contas_pagar_avulso
end variables

forward prototypes
public function integer of_colunas_arquivo (string as_linha, ref string as_colunas[])
public subroutine of_adicionar_divergencia (datastore ads_divergencias, string as_chavenfe, long al_idtitulo, string as_digitotitulo, string as_descricaodivergencia)
public function integer of_ler_arquivo (integer ai_numarquivo, datastore ads_arquivo)
public function integer of_processa_titulo (datastore ads_arquivo, datawindow adw_contaspagar)
public function integer of_processar_titulos (datastore ads_arquivo, datawindow adw_contaspagar)
public function integer of_importar (datawindow adw_contas_pagar, long al_idclifor, long al_forma, long al_idusuario, datawindow adw_contas_pagar_avulso, datawindow adw_contabil_avulso, date adt_movimento)
public function long of_get_empresa ()
end prototypes

public function integer of_colunas_arquivo (string as_linha, ref string as_colunas[]);String ls_Value
Long ll_Pos, ll_Cont

Do 
	
	ll_Pos = Pos(as_Linha, ";")
	
	// Fim da linha
	if ll_Pos = 0 Then 
		ls_Value = Mid(as_Linha, 1)
	Else 
		ls_Value = Mid(as_Linha, 1, ll_Pos -1)
	End if 
	
	ll_Cont ++
	ls_Value = inv_Funcoes.of_substituir(ls_Value, '"','')
	ls_Value = inv_Funcoes.of_substituir(ls_Value, "'",'')
	as_Colunas[ll_Cont] = ls_Value
	
	as_Linha = Mid(as_Linha, ll_Pos +1)

	Yield( )

Loop While (Len(as_Linha) > 0 and ll_Pos > 0 )

Return 1
end function

public subroutine of_adicionar_divergencia (datastore ads_divergencias, string as_chavenfe, long al_idtitulo, string as_digitotitulo, string as_descricaodivergencia);Long ll_NovaLinha
Long ll_Null

If al_idTitulo = 0 Then
	SetNull(ll_Null)
	al_idTitulo = ll_Null
End If

ll_NovaLinha = ads_divergencias.InsertRow(0)

ads_divergencias.SetItem(ll_NovaLinha, 'Arquivo1', is_arquivo1 )
ads_divergencias.SetItem(ll_NovaLinha, 'Arquivo2', is_arquivo2 )
ads_divergencias.SetItem(ll_NovaLinha, 'chavenfe', as_ChaveNFE )
ads_divergencias.SetItem(ll_NovaLinha, 'idtitulo', al_idTitulo )
ads_divergencias.SetItem(ll_NovaLinha, 'digitotiulo', as_DigitoTitulo)
ads_divergencias.SetItem(ll_NovaLinha, 'descricaodivergencia', as_DescricaoDivergencia)

end subroutine

public function integer of_ler_arquivo (integer ai_numarquivo, datastore ads_arquivo);String ls_CaminhoArquivo, ls_Linha, ls_Colunas[], ls_Null[], ls_ChaveAntiga, ls_ChaveNFE, ls_Inscricao
Long ll_Bytes, ll_Arquivo, ll_Linha, ll_For, ll_Coluna_ICMS
Decimal lde_ValorICMS
s_Parametros lst_Envio


lst_Envio.String[1]  = 'Selecione arquivo da tabela IBPT para importar'
lst_Envio.string[2] = "Microsoft Excel (*.CSV),*.CSV,"

Do

	ls_CaminhoArquivo = inv_Funcoes.of_abrir_arquivo( lst_Envio)
	
	
	If ls_CaminhoArquivo = '' Then
		MessageBox('Importa$$HEX2$$e700e300$$ENDHEX$$o de Arquivo', 'Problemas ao importar o arquivo, verifique a formata$$HEX2$$e700e300$$ENDHEX$$o ou endere$$HEX1$$e700$$ENDHEX$$o e tente novamente.')
		Return -1 
	End If 
	
	If ai_numarquivo = 1 Then
		is_CaminhoArquivo1 = ls_CaminhoArquivo
	
	ElseIf is_CaminhoArquivo1 = ls_CaminhoArquivo Then
		
		If MessageBox('Arquivo duplicado', 'O mesmo arquivo foi selecionado mais de uma vez. Deseja importar um novo arquivo?',  Question!, YesNo!) = 1 Then
			Continue// Se sim permite informar um arquivo diferente
		Else
			Return -1 //Se n$$HEX1$$e300$$ENDHEX$$o cancela a importa$$HEX2$$e700e300$$ENDHEX$$o
		End If
	End If

Loop While ai_numarquivo <> 1 And ls_CaminhoArquivo = is_CaminhoArquivo1// Fica em loop enquanto ambos os arquivos estiverem no mesmo endereco

ll_Arquivo = FileOpen(ls_CaminhoArquivo, LineMode!, Read!)

if ll_Arquivo < 0 Then
	MessageBox('Abrir Arquivo', "Falha ao abrir arquivo selecionado.")
	Return -1
End if

// Ler linha do arquivo
ll_Bytes = FileReadEx(ll_Arquivo, ls_Linha)

Do While (ll_Bytes > 0)
	
	//Limpa o array, para evitar lixo nas colunas
	ls_Colunas = ls_Null
	
	// Obter valores das colunas
	if of_colunas_arquivo(ls_Linha, ls_Colunas) < 0 Then
		MessageBox('Importa$$HEX2$$e700e300$$ENDHEX$$o de Arquivo', 'Problemas ao ler uma linha do arquivo.')
		Return -1
	End if
	
	//Faz um loop para garantir que n$$HEX1$$e300$$ENDHEX$$o vai sair do while por causa de uma linha em branco
	For ll_For = 1 To 5
		// Ler proxima linha
		ll_Bytes = FileReadEx(ll_Arquivo, ls_Linha)
		
		If ll_Bytes > 0 Then Exit
	Next
	
	If UpperBound(ls_Colunas) = 3 Then
		If ls_Colunas[1] = 'INSCRICAO' Then
			ls_Inscricao = inv_Funcoes.of_Null( ls_Colunas[2], 0)
			
			SELECT 
				IDEMPRESA
			INTO 
				:il_idEmpresa
			FROM 
				INSCRICAO_ESTADUAL 
			WHERE 
				SUBSTR(INSCRESTADUAL,1,2)||'.'||SUBSTR(INSCRESTADUAL,3,3)||'.'|| SUBSTR(INSCRESTADUAL,6,3) || '-' || SUBSTR(INSCRESTADUAL,9,1) = :ls_Inscricao
			USING SQLCA;
			
			if inv_Funcoes.of_Null( il_idEmpresa, 0) = 0 Then
				MessageBox('Inscri$$HEX2$$e700e300$$ENDHEX$$o Estadual', 'N$$HEX1$$e300$$ENDHEX$$o foi poss$$HEX1$$ed00$$ENDHEX$$vel encontrar a empresa com base na inscri$$HEX2$$e700e300$$ENDHEX$$o estadual presente no arquivo')
				Return -1 
			End If
		End If
	End If
	
	If UpperBound(ls_Colunas) > 8 Then
		if Len(ls_Colunas[1]) <> 44 Then
			Continue
		End if
		
		If ls_Colunas[1] <> ls_ChaveAntiga Then
			
			//Estava ficando no campo errado em alguns registros
			ll_Coluna_ICMS = UpperBound(ls_Colunas) - 1
			
			ls_ChaveNFE = String(ls_Colunas[1])
			lde_ValorICMS = Dec(ls_Colunas[ll_Coluna_ICMS])
			ll_Linha = 0 

			//Testa se esta inserindo o primeiro arquivo
			If ai_NumArquivo > 1 Then
				//No Segundo arquivo varre para ver se n$$HEX1$$e300$$ENDHEX$$o existe a mesma chave que no primeiro
				//se existir, soma os valores de ICMS
				If ads_Arquivo.RowCount() > 0 Then
					ll_Linha = ads_Arquivo.Find("chavenfe = '" + ls_ChaveNFE + "'", 1, ads_Arquivo.RowCount( ))
					If ll_Linha > 0 Then
						ads_Arquivo.SetItem(ll_Linha, "ValorArquivo2", Dec(ls_Colunas[ll_Coluna_ICMS]))
						if ads_Arquivo.GetItemDecimal(ll_Linha, 'valoricms') > 0 then
							ads_Arquivo.SetItem(ll_Linha, "somou", 'T')
						end if
						lde_ValorICMS += inv_Funcoes.of_null( ads_Arquivo.GetItemDecimal(ll_Linha, 'valoricms'), 0)
					End If
				End If
			End If
			
			//Se n$$HEX1$$e300$$ENDHEX$$o encontrou nenhuma linha repetida, ou e um registro novo no 2 arquivo
			//ou um registro normal do 1 arquivo
			If ll_Linha = 0 Then
				// Inserir dados na dw de cada linha retornada
				ll_Linha = ads_Arquivo.InsertRow(0)
				
				If ai_NumArquivo = 2 Then
					ads_Arquivo.SetItem(ll_Linha, "ValorArquivo2", Dec(ls_Colunas[ll_Coluna_ICMS]))
				Else	
					ads_Arquivo.SetItem(ll_Linha, "ValorArquivo1", Dec(ls_Colunas[ll_Coluna_ICMS]))	
				End If
				ads_Arquivo.SetItem(ll_Linha, "chavenfe", ls_ChaveNFE)
				
			End if
			
			
			ads_Arquivo.SetItem(ll_Linha, "valoricms", lde_ValorICMS)
				
			//Atualiza, pra esta ser a chave antiga
			ls_ChaveAntiga = ls_Colunas[1]
		End If
	End If
Loop

FileClose(ll_Arquivo)

end function

public function integer of_processa_titulo (datastore ads_arquivo, datawindow adw_contaspagar);Long ll_Retorno

If ads_Arquivo.RowCount() > 0 Then
	w_Inicial.OpenUserObject(iuo_BarraProgresso)
	iuo_BarraProgresso.of_definir_valores(0, ads_Arquivo.RowCount() , 1,'Relacionando T$$HEX1$$ed00$$ENDHEX$$tulos com o Arquivo. Aguarde...') 
End If

ll_Retorno = of_processar_titulos( ads_arquivo, adw_contaspagar)

//Assim consegue fechar a barra de progresso, idependente do retorno da tela
w_Inicial.CloseUserObject(iuo_BarraProgresso)

Return ll_Retorno
end function

public function integer of_processar_titulos (datastore ads_arquivo, datawindow adw_contaspagar);String ls_ChaveNFE, ls_DigitoTitulo
Long ll_For, ll_Retrieve, ll_Titulo, ll_Linha
Decimal  lde_ValorArquivo, lde_SaldoTitulo
Decimal lde_ValorArquivo1, lde_ValorArquivo2
DataStore lds_ContasPagar, lds_Divergencias
//Date ld_DataAtual, ld_DataVencimentoTitulo
s_Parametros lst_Divergencias

lds_Divergencias = Create DataStore
lds_ContasPagar = Create DataStore

lds_ContasPagar.DataObject = 'd_contas_pagar'
lds_ContasPagar.SetTransObject(SQLCA)

lds_Divergencias.DataObject = 'd_divergencias'
lds_Divergencias.SetTransObject(SQLCA)

//ld_DataAtual = Date(inv_Funcoes.of_get_data_atual( ))

For ll_For = 1 To ads_Arquivo.RowCount()
	
	Yield()//Atualizar Visualmente
	
	If IsValid(iuo_BarraProgresso) Then
		iuo_BarraProgresso.of_Atualizar( ll_For, ads_Arquivo.RowCount())
	End If
	
	ls_ChaveNFE = ads_Arquivo.GetItemString(ll_For, 'chavenfe')
	If ads_Arquivo.GetItemDecimal(ll_For, 'ValorArquivo1') > 0 Then
		is_Arquivo1 = 'T'
	Else
		is_Arquivo1 = 'F'
	End If
	
	If ads_Arquivo.GetItemDecimal(ll_For, 'ValorArquivo2') > 0 Then
		is_Arquivo2 = 'T'
	Else
		is_Arquivo2 = 'F'
	End If



	ll_Retrieve = lds_ContasPagar.Retrieve(ls_ChaveNFE, il_idClifor)
	
//	lde_ValorArquivo = round(ads_Arquivo.GetItemDecimal(ll_For,'valoricms'),2)
//	lde_ValorArquivo1 = round(ads_Arquivo.GetItemDecimal(ll_For,'ValorArquivo1'),2)
//	lde_ValorArquivo2 = round(ads_Arquivo.GetItemDecimal(ll_For,'ValorArquivo2'),2)
//	
		
	lde_ValorArquivo = ads_Arquivo.GetItemDecimal(ll_For,'valoricms')
	lde_ValorArquivo1 = ads_Arquivo.GetItemDecimal(ll_For,'ValorArquivo1')
	lde_ValorArquivo2 = ads_Arquivo.GetItemDecimal(ll_For,'ValorArquivo2')

	If ll_Retrieve =  0 Then
		If inv_Funcoes.of_Gerar_titulo_avulso( lds_ContasPagar, idw_contas_pagar_avulso , idw_contabil_avulso , il_idCliFor, il_idEmpresa, ls_ChaveNFE, lde_ValorArquivo, il_idUsuario, idt_Movimento ) > 0 Then
			
			//Linha do titulo criado
			ll_Linha = idw_contas_pagar_avulso.RowCount()
			
			ll_Titulo = idw_contas_pagar_avulso.GetItemNumber(ll_Linha, 'idtitulo')
			ls_DigitoTitulo = idw_contas_pagar_avulso.GetItemString(ll_Linha, 'digitotitulo')
			
			of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE, ll_Titulo, ls_DigitoTitulo, "Criado t$$HEX1$$ed00$$ENDHEX$$tulo avulso.")
			ll_Retrieve = 1
		Else
			of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,0,'', 'N$$HEX1$$e300$$ENDHEX$$o foi poss$$HEX1$$ed00$$ENDHEX$$vel criar um tiulo avulso para relacionar ao Registro.')
		End If
	End If
	
	If ll_Retrieve < 0 Then
		MessageBox('Buscando T$$HEX1$$ed00$$ENDHEX$$tulos', 'Problemas ao carregar os t$$HEX1$$ed00$$ENDHEX$$tulos relacionados.')
		Return -1
	End If
	
	If ll_Retrieve > 1 Then
		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,0,'', 'Mais de uma parcela para o t$$HEX1$$ed00$$ENDHEX$$tulo, n$$HEX1$$e300$$ENDHEX$$o foi possivel importar.')
		Continue
	End If
	
	ll_Titulo = lds_ContasPagar.GetItemNumber(1, 'idtitulo')
	ls_DigitoTitulo = lds_ContasPagar.GetItemString(1, 'digitotitulo')
	
	//Se encontrou um titulo bloquado, ele cancela a baixa do registro
	If inv_Funcoes.of_null(lds_ContasPagar.GetItemString(1,'flagtitulobloqueado'),'F') = 'T' Then 
		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,ll_Titulo ,ls_DigitoTitulo , 'O t$$HEX1$$ed00$$ENDHEX$$tulo se encontra bloquado e n$$HEX1$$e300$$ENDHEX$$o pode ser baixado.')
		Continue
	End If
	
	
//	ld_DataVencimentoTitulo = lds_ContasPagar.GetItemDate(1,'dtvencimento')
//
//	//Se encontrou um titulo vencido, ele cancela a baixa do registro
//	If ld_DataVencimentoTitulo < ld_DataAtual Then 
//		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,ll_Titulo ,ls_DigitoTitulo , 'O t$$HEX1$$ed00$$ENDHEX$$tulo se encontra vencido e n$$HEX1$$e300$$ENDHEX$$o pode ser baixado.')
//		Continue
//	End If
	
	lde_SaldoTitulo = lds_ContasPagar.GetItemDecimal(1,'valliquidotitulo')
	
//	If lde_ValorArquivo > lde_SaldoTitulo Then
//		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,ll_Titulo ,ls_DigitoTitulo , &
//										"T$$HEX1$$ed00$$ENDHEX$$tulo com saldo("+ String(lde_SaldoTitulo,"###,###,###.00") + ") menor que o valor a ser baixado pelo arquivo("+ String(lde_ValorArquivo,"###,###,###.00") + ").")
//		Continue
//	End If
//	
	If lde_ValorArquivo < lde_SaldoTitulo Then
		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,ll_Titulo ,ls_DigitoTitulo , &
										"T$$HEX1$$ed00$$ENDHEX$$tulo sera baixado parcialmente. Saldo do Titulo: " + String(lde_SaldoTitulo,"###,###,###.00") +"; Valor Arquivo: " + String(lde_ValorArquivo,"###,###,###.00") + "." )
	End If
	
	lds_ContasPagar.SetItem(1, 'valorpagamento', lde_ValorArquivo)
	lds_ContasPagar.SetItem(1, 'ValorArquivo1', lde_ValorArquivo1)
	lds_ContasPagar.SetItem(1, 'ValorArquivo2', lde_ValorArquivo2)
	
//	if trim(ls_ChaveNFE) = '50200688634977000705550040000184281192714645'  then
//		debugbreak()
//	end if
	
	
	If lde_ValorArquivo >  lds_ContasPagar.GetItemDecimal(1,'valliquidotitulo') then
		if lde_ValorArquivo1 = 0 then
			lds_ContasPagar.SetItem(1, 'valjuros2', lde_ValorArquivo -  lds_ContasPagar.GetItemDecimal(1,'valliquidotitulo'))
		elseif lde_ValorArquivo2 = 0 or (lde_ValorArquivo1 > 0 and lde_ValorArquivo2 > 0 ) then
				lds_ContasPagar.SetItem(1, 'valjuros1', lde_ValorArquivo - lds_ContasPagar.GetItemDecimal(1,'valliquidotitulo'))
		end if
	

	else
		lds_ContasPagar.SetItem(1, 'valjuros1', 0)
		lds_ContasPagar.SetItem(1, 'valjuros2', 0)
	end if
	
	If lds_ContasPagar.RowsMove( 1, lds_ContasPagar.RowCount(), Primary!, adw_ContasPagar, 1, Primary!) < 0 Then
		MessageBox('Problemas ao manipular o T$$HEX1$$ed00$$ENDHEX$$tulo', 'T$$HEX1$$ed00$$ENDHEX$$tulo n$$HEX1$$e300$$ENDHEX$$o pode ser carregada para o Sistema.')
		Return -1
	End If
	
Next

If lds_Divergencias.RowCount() > 0 Then 
	lst_Divergencias.PowerObj[1] = lds_Divergencias
	OpenWithParm(w_divergencias, lst_Divergencias)

	lst_Divergencias = Message.PowerObjectParm
	
	If lst_Divergencias.Long[1] < 0 Then
		Return -1
	End If
End If

Return 1
end function

public function integer of_importar (datawindow adw_contas_pagar, long al_idclifor, long al_forma, long al_idusuario, datawindow adw_contas_pagar_avulso, datawindow adw_contabil_avulso, date adt_movimento);
Datastore lds_Arquivo

lds_Arquivo = Create DataStore

lds_Arquivo.DataObject = 'd_arquivotitulos'
lds_Arquivo.SetTransObject(SQLCA)

idw_contas_pagar_avulso = adw_contas_pagar_avulso
idw_contabil_avulso = adw_contabil_avulso

il_idClifor = al_idClifor
il_Forma = al_Forma
il_idUsuario = al_idUsuario
//il_idEmpresa = al_idEmpresa
idt_Movimento = adt_movimento

If of_Ler_arquivo(1, lds_Arquivo) < 0 Then 
	Return -1
Else
	If MessageBox('Importar arquivo', 'Deseja Importar o segundo arquivo?',  Question!, YesNo!) = 1 Then
		If of_Ler_arquivo(2, lds_Arquivo) < 0 Then
			Return -1
		End If
	End If
End If

If of_processa_titulo(lds_Arquivo, adw_contas_pagar) < 0 Then 
	Return -1
End If


Return 1
end function

public function long of_get_empresa ();return il_idEmpresa
end function

on nv_titulos.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_titulos.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;inv_Funcoes = Create nv_Funcoes
end event

