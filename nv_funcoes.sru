HA$PBExportHeader$nv_funcoes.sru
forward
global type nv_funcoes from nonvisualobject
end type
end forward

global type nv_funcoes from nonvisualobject
end type
global nv_funcoes nv_funcoes

type variables
CONSTANT LONG IDFORMAPAGAMENTO = 14

CONSTANT LONG IDCONTACREDITO = 2110704

CONSTANT LONG IDCONTADEBITOEMP1 = 1140101
CONSTANT LONG IDCONTADEBITOEMP2 = 1140103
CONSTANT LONG IDCONTADEBITOEMP5 = 1140102
CONSTANT LONG IDCONTADEBITOEMP50 = 1140104
end variables

forward prototypes
public function integer of_verifica_cliente (long al_idclifor)
public function string of_substituir (string as_texto, string as_remover, string as_inserir)
public function any of_null (any any_valor, any any_valor2)
public function datetime of_get_data_atual ()
public function string of_abrir_arquivo (s_parametros ast_parametros)
public function integer of_imprimir (datawindow adw_relatorio)
public function longlong of_getctdplanilha ()
public function integer of_update (datawindow arg[])
public function integer of_salvar_importado (datawindow adw_contas_receber)
public function integer of_salvar_relatorio (datawindow adw_relatorio)
public function integer of_verifica_forma_pagamento (long al_formapagamento)
public function any of_if (boolean ab_condicao, ref any aa_verdadeiro, ref any aa_falso)
public function integer of_verifica_usuario (long al_idusuario)
public function string of_obs_titulo (long al_idfornecedor, long al_idtitulo, string as_digitotitulo)
public function integer of_gerar_titulo_avulso (ref datastore ads_contas_pagar, ref datawindow adw_contas_pagar_avulso, ref datawindow adw_contabil_movimento, long al_idclifor, long al_idempresa, string as_chavenfe, decimal ade_valortitulo, integer al_idusuario, date adt_movimento)
public function integer of_baixa_titulo (ref datawindow adw_contas_pagar, ref datawindow adw_contas_pagar_baixas, ref datawindow adw_contabil_movimento, ref datawindow adw_contas_baixar_avulso, s_parametros as_recebe, date adt_dtmovimento)
public function integer of_baixa_titulo_bkp (ref datawindow adw_contas_pagar, ref datawindow adw_contas_pagar_baixas, ref datawindow adw_contabil_movimento, ref datawindow adw_contas_baixar_avulso, s_parametros as_recebe, date adt_dtmovimento)
end prototypes

public function integer of_verifica_cliente (long al_idclifor);Long ll_Count

SELECT 
	COUNT(*)
INTO 
	:ll_Count
FROM
	CLIENTE_FORNECEDOR 
WHERE
	IDCLIFOR = :al_idClifor
USING 
	SQLCA;

If of_null( ll_Count, 0) > 0 Then
	Return 1
Else
	Return -1
End If

end function

public function string of_substituir (string as_texto, string as_remover, string as_inserir);long ll_start_pos=1


ll_start_pos = Pos(as_Texto, as_Remover, ll_start_pos)


Do While ll_start_pos > 0
	// Troca as_Remover por as_Inserir
	as_Texto = Replace(as_Texto, ll_start_pos, Len(as_Remover), as_Inserir)
	
	ll_start_pos = Pos(as_Texto, as_Remover, ll_start_pos+Len(as_Inserir))
loop

return as_Texto
end function

public function any of_null (any any_valor, any any_valor2);if isnull( any_Valor ) then
	return	any_Valor2
end if

return any_Valor
end function

public function datetime of_get_data_atual ();DateTime ls_DataAtual

SELECT
	PARAMETROS.SISDATA
INTO
	:ls_DataAtual
FROM
	(
	SELECT
		GETDATE()
	FROM
		DUMMY) AS PARAMETROS(SISDATA);


Return ls_DataAtual
end function

public function string of_abrir_arquivo (s_parametros ast_parametros);long ll_valor 
long ll_numext 
long ll_num    

string ls_titulo    
string ls_docname  
string ls_named     
string ls_extensao  
                    
String ls_NamedMultSelecao[]
Boolean lb_Xp

ls_titulo  = ast_Parametros.string[1]

if trim(ls_titulo) = "" or IsNull(ls_titulo) then
   ls_titulo = "Selecione o arquivo"
end if

ll_numext = UPPERBOUND(ast_Parametros.string)

for ll_num=2 to ll_numext
	ls_extensao = ls_extensao + trim(ast_Parametros.string[ll_num])
next

ll_valor = GetFileOpenName(ls_titulo,  ls_docname, ls_named, ls_extensao, ls_extensao,"",2)

IF ll_valor = -1 THEN
	ls_docname = ''
end if

Return string(ls_docname)
end function

public function integer of_imprimir (datawindow adw_relatorio);adw_relatorio.Print(True, True)

return 1
end function

public function longlong of_getctdplanilha ();longLong	ll_idplanilha
nv_connectdb	lnv_connectdb
Try
	lnv_connectdb = create nv_connectdb
	ll_idplanilha = lnv_connectdb.fnv_getidplanilha( sqlca )
Finally
	Destroy (lnv_connectdb)
End Try

return 	ll_idplanilha
end function

public function integer of_update (datawindow arg[]);int li_n,li_r
datawindow ldw_Datawindows

li_r = upperbound(arg)
for li_n = 1 to li_r
	
	ldw_Datawindows = arg[li_n]

	if not isvalid(arg[li_n]) then
		Continue
	end if	

	arg[li_n].SetTransObject(sqlca)

	if arg[li_n].AcceptText()=-1 then
		rollback using sqlca;
     	return -1 	   	
  	End if
	
	if arg[li_n].update(true,false)=-1 then			
	  	rollback using sqlca;
     	return -1 	   	
  	End if
next


commit using sqlca;


if sqlca.sqlcode=0 then
   for li_n=1 to li_r
		if not isvalid(arg[li_n]) then
			continue
		end if	
	   arg[li_n].resetupdate()  
   next
	
   return 1
Else
	Return -1
End if

return 1
end function

public function integer of_salvar_importado (datawindow adw_contas_receber);String ls_Diretorio, ls_Arquivo, ls_describe
Integer li_filenum

ls_Diretorio = gs_DirApp +'log_importacao'

ls_arquivo = '\\' + 'IMPORTACAO_' + string(of_get_data_atual( ) ,'dd-mm-yyyy_hh-mm') + '.html'

If not DirectoryExists (ls_Diretorio) Then
	CreateDirectory (ls_Diretorio)
end if

ls_arquivo = ls_Diretorio + ls_arquivo

ls_describe = adw_contas_receber.describe("DataWindow.Processing") //Testa se a datawindow

choose case ls_describe
	case '!'
		messagebox('Erro criar arquivo','Ocorreram erros ao criar o relatelatorio logando o que foi importado.',Exclamation!)
		return -1
	case ''
		return -1
	case else
		li_filenum = adw_contas_receber.SaveAs(ls_arquivo, HTMLTable!, false)
		
		// #34109
		if li_filenum <= 0 then
			messageBox( 'Cria$$HEX2$$e700e300$$ENDHEX$$o de Arquivo', 	'Erro ao criar arquivo '+ls_arquivo+".", stopSign! )
			return -1
		end if
		
		

end choose

return 1
end function

public function integer of_salvar_relatorio (datawindow adw_relatorio);Integer li_NumeroArquivo

String ls_name, ls_arquivo


ls_arquivo = '\\' + 'CRITICAS_' + string(of_get_data_atual( ) ,'dd-mm-yyyy_hh-mm') + '.html'

li_NumeroArquivo = adw_Relatorio.SaveAs(gs_DirApp + ls_arquivo, HTMLTable!, True)


If li_NumeroArquivo <= 0 then
	messageBox('Erro ao criar arquivo', "Erro durante a cria$$HEX2$$e700e300$$ENDHEX$$o do arquivo" )
//	messageBox('Erro ao criar arquivo', "VerIfique se o software GNU GhostScript esta instalado.~r~r"+&
//													"Erro: "+string(li_NumeroArquivo), stopSign! )
	Return -1
end If

end function

public function integer of_verifica_forma_pagamento (long al_formapagamento);Long ll_Count

SELECT 
	COUNT(1)
INTO 
	:ll_Count
FROM
	FORMA_PAGREC 
WHERE
	IDRECEBIMENTO = :al_FormaPagamento
USING 
	SQLCA;

If of_null( ll_Count, 0) > 0 Then
	Return 1
Else
	Return -1
End If

end function

public function any of_if (boolean ab_condicao, ref any aa_verdadeiro, ref any aa_falso);If ab_Condicao Then
	Return aa_verdadeiro
Else
	Return aa_falso
End If	
end function

public function integer of_verifica_usuario (long al_idusuario);Long ll_Count

SELECT 
	COUNT(1)
INTO 
	:ll_Count
FROM
	DBA.USUARIO 
WHERE
	IDUSUARIO = :al_idUsuario
USING 
	SQLCA;

If of_null( ll_Count, 0) > 0 Then
	Return 1
Else
	Return -1
End If

end function

public function string of_obs_titulo (long al_idfornecedor, long al_idtitulo, string as_digitotitulo);String ls_Nome

SELECT 
	NOME
INTO
	:ls_Nome
FROM 
	CLIENTE_FORNECEDOR
WHERE
	IDCLIFOR = :al_idFornecedor
USING
	SQLCA;
	

Return "Forn. " + String(al_idFornecedor) + " - " + ls_Nome + ". T$$HEX1$$ed00$$ENDHEX$$t. " + String(al_idTitulo) + "-" + as_DigitoTitulo
end function

public function integer of_gerar_titulo_avulso (ref datastore ads_contas_pagar, ref datawindow adw_contas_pagar_avulso, ref datawindow adw_contabil_movimento, long al_idclifor, long al_idempresa, string as_chavenfe, decimal ade_valortitulo, integer al_idusuario, date adt_movimento);long ll_new, ll_idplanilha, ll_newcontabil, ll_LinhaVisual
long ll_idctacredito, ll_idctadebito, ll_CodigoNFE, ll_idEmpresa
String ls_TipoNaturezaDeb, ls_TipoNaturezaCred, ls_Msg

ll_CodigoNFE = Long(Mid(as_ChaveNfe, 26, 9))

ll_idEmpresa = al_idEmpresa

If of_null(ll_idEmpresa,0) = 0 Then
	Return -1
End If

ll_idCtaCredito = IDCONTACREDITO

Choose Case ll_idEmpresa
	Case 1
		ll_idctadebito = IDCONTADEBITOEMP1
	Case 2
		ll_idctadebito = IDCONTADEBITOEMP2
	Case 5
		ll_idctadebito = IDCONTADEBITOEMP5
	Case 50
		ll_idctadebito = IDCONTADEBITOEMP50
End Choose

SELECT 
	TIPONATUREZA 
INTO 
	:ls_tiponaturezaCred
FROM 
	CONTABIL_PLANO_CONTAS 
WHERE  
	IDCTACONTABIL = :ll_idCtaCredito 
USING SQLCA;

SELECT 
	TIPONATUREZA 
INTO 
	:ls_tiponaturezaDeb
FROM
	CONTABIL_PLANO_CONTAS 
WHERE  
	IDCTACONTABIL = :ll_idctadebito 
USING SQLCA;


ll_idplanilha = of_getctdplanilha()	
	
ll_new = adw_contas_pagar_avulso.InsertRow(0)

adw_contas_pagar_avulso.SetItem(ll_new, 'IDEMPRESA', ll_idEmpresa)
adw_contas_pagar_avulso.SetItem(ll_new, 'IDCLIFOR', al_idClifor)
adw_contas_pagar_avulso.SetItem(ll_new, 'IDPLANILHA', ll_idplanilha)	
adw_contas_pagar_avulso.SetItem(ll_new, 'DIGITOTITULO',  '01')
adw_contas_pagar_avulso.SetItem(ll_new, 'SERIENOTA', 'AVU')
adw_contas_pagar_avulso.SetItem(ll_new, 'IDPAGAMENTO', IDFORMAPAGAMENTO)
adw_contas_pagar_avulso.SetItem(ll_new, 'ORIGEMMOVIMENTO', 'AVU')
adw_contas_pagar_avulso.SetItem(ll_new, 'VALTITULO', ade_ValorTitulo)
adw_contas_pagar_avulso.SetItem(ll_new, 'IDUSUARIO', al_idUsuario)
adw_contas_pagar_avulso.SetItem(ll_new, 'DTMOVIMENTO',Date(adt_movimento))
adw_contas_pagar_avulso.SetItem(ll_new, 'CONTAS_PAGAR_DTEMISSAO', Date(adt_movimento))
adw_contas_pagar_avulso.SetItem(ll_new, 'IDTITULO', ll_CodigoNFE)
adw_contas_pagar_avulso.SetItem(ll_new, 'DTVENCIMENTO', Date(adt_movimento))
adw_contas_pagar_avulso.SetItem(ll_new, 'OBSTITULO', as_ChaveNfe)
adw_contas_pagar_avulso.SetItem(ll_new, 'IDCTACONTABIL', ll_idCtaCredito)
adw_contas_pagar_avulso.SetItem(ll_new, 'IDCTACONTABILCONTRAPARTIDA', ll_idctadebito)


ls_Msg = of_obs_titulo( al_idClifor, ll_CodigoNFE, '01')

ll_LinhaVisual = ads_contas_pagar.InsertRow(0)

//Adiciona para a datawindow visual
ads_contas_pagar.SetItem(ll_LinhaVisual, 'CHAVENFE', as_ChaveNfe)
ads_contas_pagar.SetItem(ll_LinhaVisual, 'IDEMPRESA', adw_contas_pagar_avulso.GetItemNumber(ll_new, 'IDEMPRESA'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'IDCLIFOR', adw_contas_pagar_avulso.GetItemNumber(ll_new, 'IDCLIFOR'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'IDPLANILHA', adw_contas_pagar_avulso.GetItemNumber(ll_new, 'IDPLANILHA'))	
ads_contas_pagar.SetItem(ll_LinhaVisual, 'DIGITOTITULO',  adw_contas_pagar_avulso.GetItemString(ll_new, 'DIGITOTITULO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'SERIENOTA', adw_contas_pagar_avulso.GetItemString(ll_new, 'SERIENOTA'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'IDPAGAMENTO', adw_contas_pagar_avulso.GetItemNumber(ll_new, 'IDPAGAMENTO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'ORIGEMMOVIMENTO', adw_contas_pagar_avulso.GetItemString(ll_new, 'ORIGEMMOVIMENTO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'VALTITULO', adw_contas_pagar_avulso.GetItemDecimal(ll_new, 'VALTITULO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'IDUSUARIO', adw_contas_pagar_avulso.GetItemNumber(ll_new, 'IDUSUARIO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'DTMOVIMENTO',adw_contas_pagar_avulso.GetItemDate(ll_new, 'DTMOVIMENTO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'DTEMISSAO', adw_contas_pagar_avulso.GetItemDate(ll_new, 'CONTAS_PAGAR_DTEMISSAO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'IDTITULO', adw_contas_pagar_avulso.GetItemNumber(ll_new, 'IDTITULO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'DTVENCIMENTO',adw_contas_pagar_avulso.GetItemDate(ll_new, 'DTVENCIMENTO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'OBSTITULO', adw_contas_pagar_avulso.GetItemString(ll_new, 'OBSTITULO'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'IDCTACONTABIL', adw_contas_pagar_avulso.GetItemNumber(ll_new, 'IDCTACONTABIL'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'IDCTACREDITO', adw_contas_pagar_avulso.GetItemNumber(ll_new, 'IDCTACONTABIL'))
ads_contas_pagar.SetItem(ll_LinhaVisual, 'VALLIQUIDOTITULO',adw_contas_pagar_avulso.GetItemDecimal(ll_new, 'VALTITULO'))

/*
ll_newcontabil = adw_contabil_movimento.Insertrow(0)

//CONTA CREDITO
adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctacredito)
adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','C')
adw_contabil_movimento.SetItem(ll_newcontabil, 'idempresa', adw_contas_pagar_avulso.GetItemnumber(ll_new, 'idempresa'))
adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', adw_contas_pagar_avulso.GetItemnumber(ll_new, 'idempresa'))
adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', al_idUsuario)
adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(adt_movimento))
adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',adw_contas_pagar_avulso.GetItemDecimal(ll_new, 'VALTITULO'))
adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO',ls_Msg)
adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezacred) 
adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(adt_movimento))
adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')


ll_newcontabil = adw_contabil_movimento.Insertrow(0)

//CONTA DEBITO
adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebito)
adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
adw_contabil_movimento.SetItem(ll_newcontabil, 'idempresa', adw_contas_pagar_avulso.GetItemnumber(ll_new, 'idempresa'))
adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', adw_contas_pagar_avulso.GetItemnumber(ll_new, 'idempresa'))
adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', al_idUsuario)
adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(adt_movimento))
adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO', adw_contas_pagar_avulso.GetItemDecimal(ll_new, 'VALTITULO'))
adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO', ls_Msg)
adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb)
adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(adt_movimento))
adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
*/

return 1
end function

public function integer of_baixa_titulo (ref datawindow adw_contas_pagar, ref datawindow adw_contas_pagar_baixas, ref datawindow adw_contabil_movimento, ref datawindow adw_contas_baixar_avulso, s_parametros as_recebe, date adt_dtmovimento);long ll_new, ll_idplanilha, ll_for, ll_newcontabil, ll_forpgb 
long ll_idctacredito, ll_idctadebitojuros, ll_idctadebito
String ls_tiponaturezadeb, ls_tiponaturezacred, ls_Msg
Decimal lde_valtaxa, lde_valpagamento, lde_valarqui1, lde_valarqui2, lde_Juros
Long ll_idusuario, ll_forma, ll_ctataxa, ll_agrupa, ll_count, ll_idempresa
Date ldt_movimento
boolean lb_processou

ll_forma 		= as_recebe.Long[1]
ll_idusuario 	= as_recebe.Long[2]
ll_ctataxa 	= as_recebe.Long[3]
ll_idempresa= as_recebe.Long[4] 
lde_valtaxa 	= as_recebe.decimal[1]
//ldt_movimento = as_recebe.Date[1]
ldt_movimento  = adt_dtmovimento
//lb_bxportitulo	= as_recebe.boolean[1]

select coalesce(idctacredito,0) into : ll_idctacredito 
	from forma_pagrec 
	where idrecebimento =:ll_forma
	using sqlca;

if ll_idctacredito = 0 then
	messagebox('Aviso', 'Conta contabil da forma de pagamento '+string(ll_forma)+' n$$HEX1$$e300$$ENDHEX$$o configurada')
	return -1
end if
	

select  
	TIPONATUREZA 
into 
	:ls_tiponaturezacred 
from 
	CONTABIL_PLANO_CONTAS 
WHERE  
	IDCTACONTABIL = :ll_idctacredito 
USING 
	SQLCA;	
	
for ll_agrupa = 1 to 2
	
	lb_processou = false
	lde_Juros = 0
	ll_idplanilha = of_getctdplanilha()
	
	for ll_for = 1 to adw_contas_pagar.Rowcount()
		
		if adw_contas_pagar.GetItemDecimal(ll_for, 'valliquidotitulo') = 0 then
			continue
		end if
		
		lde_valpagamento = 0
		
		If This.of_Null(adw_Contas_Pagar.GetItemString(ll_For, 'flagbaixa'), 'F') = 'T' Then
			if ll_agrupa = 1 then
				 if adw_contas_pagar.GetItemDecimal(ll_for, 'valorarquivo1') = 0 then
					continue
				end if
			else
				 if adw_contas_pagar.GetItemDecimal(ll_for, 'valorarquivo2') = 0 then
					continue
				end if
			end if
		
			if ll_agrupa = 1 then
				lde_valpagamento =  adw_contas_pagar.GetItemDecimal(ll_for, 'valorarquivo1')
			else
				lde_valpagamento =  adw_contas_pagar.GetItemDecimal(ll_for, 'valorarquivo2')
			end if
			
			if lde_valpagamento = 0 then
				continue
			end if
			
			
			lb_processou = true

			ll_new = adw_contas_pagar_baixas.InsertRow(0)
			
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDEMPRESA', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDCLIFOR', adw_contas_pagar.GetItemnumber(ll_for, 'IDCLIFOR'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDTITULO', adw_contas_pagar.GetItemnumber(ll_for, 'IDTITULO'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'DIGITOTITULO', adw_contas_pagar.GetItemString(ll_for, 'DIGITOTITULO'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'SERIENOTA', adw_contas_pagar.GetItemString(ll_for, 'SERIENOTA'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDPLANILHA', ll_idplanilha)	
			adw_contas_pagar_baixas.SetItem(ll_new, 'ORIGEMMOVIMENTO', 'PAG')
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDEMPRESABAIXA',adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'DTPAGAMENTO',DATE(ldt_movimento))
		
			if lde_valpagamento > dec(adw_contas_pagar.GetItemDecimal(ll_for, 'valliquidotitulo')) then
				adw_contas_pagar_baixas.SetItem(ll_new, 'VALPAGAMENTOTITULO',dec(adw_contas_pagar.GetItemDecimal(ll_for, 'valliquidotitulo')))
				
				lde_Juros = lde_Juros + (lde_valpagamento - adw_contas_pagar.GetItemDecimal(ll_for, 'valliquidotitulo'))
				
			else
				adw_contas_pagar_baixas.SetItem(ll_new, 'VALPAGAMENTOTITULO',dec(lde_valpagamento))
			end if
	
			adw_contas_pagar_baixas.SetItem(ll_new, 'DTALTERACAO',DATE(of_get_data_atual()))
			
			ls_Msg = ls_Msg + of_obs_titulo( adw_contas_pagar.GetItemnumber(ll_for, 'IDCLIFOR'), &
										adw_contas_pagar.GetItemnumber(ll_for, 'IDTITULO'), &
										adw_contas_pagar.GetItemString(ll_for, 'DIGITOTITULO'))

		
		
		

			ll_idctadebito = adw_contas_pagar.GetItemnumber(ll_for,'idctacredito')
		
	
		End If
	Next
	
	lde_valarqui1 = adw_contas_pagar.Object.compute_5[1] 
	lde_valarqui2 = adw_contas_pagar.Object.compute_6[1]
	
	//valida se importou somente um arquivo
	if ll_agrupa =1 then
		if lde_valarqui1 = 0 then
			continue
		end if
	else
		if lde_valarqui2 = 0 then
			continue
		end if
	end if


	if lb_processou then
		ls_Msg = ls_Msg+  ". Importa$$HEX2$$e700e300$$ENDHEX$$o arq. SEFAZ."
		
		ll_newcontabil = adw_contabil_movimento.Insertrow(0)
	
		
		//CONTA CREDITO
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctacredito)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','C')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idusuario)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
		if ll_agrupa = 1 then
			adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui1)
		else
			adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui2)
		end if						
		adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO', ls_Msg)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezacred) 
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',ldt_movimento)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
		
	
		ll_newcontabil = adw_contabil_movimento.Insertrow(0)
		
	
		select  TIPONATUREZA into :ls_tiponaturezadeb 
			from CONTABIL_PLANO_CONTAS 
			WHERE  IDCTACONTABIL = :ll_idctadebito USING SQLCA;
		
		//CONTA DEBITO
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebito)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
		if ll_agrupa = 1 then
			if lde_Juros > 0 then
				adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui1 - lde_Juros)
			else
				adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui1)
			end if
		else
			if lde_Juros > 0 then
				adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui2 - lde_Juros)
			else
				adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui2)
			end if
		end if						
		
		adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO', ls_Msg)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
		
		
	
	
		if lde_Juros > 0 then
					
			ll_newcontabil = adw_contabil_movimento.Insertrow(0)
		
			//Juros
			ll_idctadebitojuros = 4110401
		
		
			select  TIPONATUREZA into :ls_tiponaturezadeb 
				from CONTABIL_PLANO_CONTAS 
				WHERE  IDCTACONTABIL = :ll_idctadebitojuros USING SQLCA;
			
			//CONTA DEBITO
			adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebitojuros)
			adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
			adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for)
			adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
			adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
			adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
			adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
			adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
			adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
			adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_Juros)
			adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO','Juros lan$$HEX1$$e700$$ENDHEX$$amento sefaz')
			adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb)
			adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
			adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
			adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
			
		end if
	
	
		//lanca debito a taxa
		ll_newcontabil = adw_contabil_movimento.Insertrow(0)
	
		ll_idctadebito = ll_ctataxa
	
	
		select  TIPONATUREZA into :ls_tiponaturezadeb 
			from CONTABIL_PLANO_CONTAS 
			WHERE  IDCTACONTABIL = :ll_idctadebito USING SQLCA;
		
		//CONTA DEBITO
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebito)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for+1)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO','LAN$$HEX1$$c700$$ENDHEX$$AMENTO TAXA BANCARIA APP SEFAZ')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valtaxa)
		
		
		//lanca credito da taxa 
		ll_newcontabil = adw_contabil_movimento.Insertrow(0)
	
		
		//CONTA CREDITO
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctacredito)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for+1)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','C')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO','LAN$$HEX1$$c700$$ENDHEX$$AMENTO TAXA BANCARIA APP SEFAZ')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezacred)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valtaxa)
	end if

Next



		


Return 1
end function

public function integer of_baixa_titulo_bkp (ref datawindow adw_contas_pagar, ref datawindow adw_contas_pagar_baixas, ref datawindow adw_contabil_movimento, ref datawindow adw_contas_baixar_avulso, s_parametros as_recebe, date adt_dtmovimento);long ll_new, ll_idplanilha, ll_for, ll_newcontabil, ll_forpgb 
long ll_idctacredito, ll_idctadebitojuros, ll_idctadebito
String ls_tiponaturezadeb, ls_tiponaturezacred, ls_Msg
Decimal lde_diferenca, lde_valtaxa, lde_valpagamento, lde_pagamentototal, lde_jurostotal, lde_valarqui1, lde_valarqui2
Long ll_idusuario, ll_forma, ll_ctataxa, ll_agrupa, ll_count, ll_idempresa
Date ldt_movimento
Boolean lb_bxportitulo

/*ls_manda.long[1] = ll_forma
ls_manda.long[2] = ll_idUsuario
ls_manda.long[3] = ll_ctataxa
ls_manda.Decimal[1] = ld_valtaxa
ls_manda.date[1] = ldt_Movimento
ls_manda.boolean[1] = cbx_agrupar.checked
*/

ll_forma 		= as_recebe.Long[1]
ll_idusuario 	= as_recebe.Long[2]
ll_ctataxa 	= as_recebe.Long[3]
ll_idempresa= as_recebe.Long[4] 
lde_valtaxa 	= as_recebe.decimal[1]
//ldt_movimento = as_recebe.Date[1]
ldt_movimento  = adt_dtmovimento
lb_bxportitulo	= as_recebe.boolean[1]

select coalesce(idctacredito,0) into : ll_idctacredito 
	from forma_pagrec 
	where idrecebimento =:ll_forma
	using sqlca;

if ll_idctacredito = 0 then
	messagebox('Aviso', 'Conta contabil da forma de pagamento '+string(ll_forma)+' n$$HEX1$$e300$$ENDHEX$$o configurada')
	return -1
end if
	

select  
	TIPONATUREZA 
into 
	:ls_tiponaturezacred 
from 
	CONTABIL_PLANO_CONTAS 
WHERE  
	IDCTACONTABIL = :ll_idctacredito 
USING 
	SQLCA;	
	
	
if lb_bxportitulo then
	ll_count = 1
	lde_valtaxa = lde_valtaxa * 2 
else
	ll_count = 2
end if	
		
for ll_agrupa = 1 to ll_count
	
	//agrupa as baixas por arquivo
	if not lb_bxportitulo then
		ll_idplanilha = of_getctdplanilha()
	end if
	
	
	lde_pagamentototal = 0
//	lde_jurostotal = 0
	
	for ll_for = 1 to adw_contas_pagar.Rowcount()
		
		lde_valpagamento = 0

		
		
		If This.of_Null(adw_Contas_Pagar.GetItemString(ll_For, 'flagbaixa'), 'F') = 'T' Then
		
			if not lb_bxportitulo then
				if ll_agrupa = 1 then
					 if adw_contas_pagar.GetItemDecimal(ll_for, 'valorarquivo1') = 0 then
						continue
					end if
				end if
			end if
		
		
		
			if not lb_bxportitulo then
				if ll_agrupa = 1 then
					lde_valpagamento =  round(adw_contas_pagar.GetItemDecimal(ll_for, 'valorarquivo1'),2)
				else
					lde_valpagamento =  round(adw_contas_pagar.GetItemDecimal(ll_for, 'valorarquivo2'),2)
				end if
				
			else
				lde_valpagamento =  round(adw_contas_pagar.GetItemDecimal(ll_for, 'valorarquivo1'),2) +  round(adw_contas_pagar.GetItemDecimal(ll_for, 'valorarquivo2'),2)
			end if
			
		
			//se nao agrupa, gera uma planilha pra cada baixas
			if lb_bxportitulo then
				ll_idplanilha = of_getctdplanilha()
			end if
			
			ll_new = adw_contas_pagar_baixas.InsertRow(0)
			
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDEMPRESA', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDCLIFOR', adw_contas_pagar.GetItemnumber(ll_for, 'IDCLIFOR'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDTITULO', adw_contas_pagar.GetItemnumber(ll_for, 'IDTITULO'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'DIGITOTITULO', adw_contas_pagar.GetItemString(ll_for, 'DIGITOTITULO'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'SERIENOTA', adw_contas_pagar.GetItemString(ll_for, 'SERIENOTA'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDPLANILHA', ll_idplanilha)	
			adw_contas_pagar_baixas.SetItem(ll_new, 'ORIGEMMOVIMENTO', 'PAG')
			adw_contas_pagar_baixas.SetItem(ll_new, 'IDEMPRESABAIXA',adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
			adw_contas_pagar_baixas.SetItem(ll_new, 'DTPAGAMENTO',DATE(ldt_movimento))
		
			if dec(lde_valpagamento) > dec(adw_contas_pagar.GetItemDecimal(ll_for, 'valliquidotitulo')) then
				adw_contas_pagar_baixas.SetItem(ll_new, 'VALPAGAMENTOTITULO',dec(adw_contas_pagar.GetItemDecimal(ll_for, 'valliquidotitulo')))
				lde_pagamentototal = lde_pagamentototal + dec(adw_contas_pagar.GetItemDecimal(ll_for, 'valliquidotitulo'))
				lde_diferenca = dec(lde_valpagamento) - dec(adw_contas_pagar.GetItemDecimal(ll_for, 'valliquidotitulo'))
			else
				adw_contas_pagar_baixas.SetItem(ll_new, 'VALPAGAMENTOTITULO',dec(lde_valpagamento))
				lde_pagamentototal = lde_pagamentototal + lde_valpagamento
			end if
	
			adw_contas_pagar_baixas.SetItem(ll_new, 'DTALTERACAO',DATE(of_get_data_atual()))
			
			if lb_bxportitulo then
				ls_Msg = of_obs_titulo( adw_contas_pagar.GetItemnumber(ll_for, 'IDCLIFOR'), &
											adw_contas_pagar.GetItemnumber(ll_for, 'IDTITULO'), &
											adw_contas_pagar.GetItemString(ll_for, 'DIGITOTITULO'))
		
			else
				ls_Msg = ls_Msg + of_obs_titulo( adw_contas_pagar.GetItemnumber(ll_for, 'IDCLIFOR'), &
										adw_contas_pagar.GetItemnumber(ll_for, 'IDTITULO'), &
										adw_contas_pagar.GetItemString(ll_for, 'DIGITOTITULO'))
			end if
		
		
		

			ll_idctadebito = adw_contas_pagar.GetItemnumber(ll_for,'idctacredito')
		
			if lb_bxportitulo then
				ll_newcontabil = adw_contabil_movimento.Insertrow(0)
			
				
				//CONTA CREDITO
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctacredito)
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
				if not lb_bxportitulo then
					adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for)
				else
					adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
				end if
				adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','C')
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idusuario)
				adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
				adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
				adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valpagamento)
				adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO', ls_Msg)
				adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezacred) 
				adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
				adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',ldt_movimento)
				adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
				
			
				ll_newcontabil = adw_contabil_movimento.Insertrow(0)
				

			
			
				select  TIPONATUREZA into :ls_tiponaturezadeb 
					from CONTABIL_PLANO_CONTAS 
					WHERE  IDCTACONTABIL = :ll_idctadebito USING SQLCA;
				
				//CONTA DEBITO
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebito)
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
				if not lb_bxportitulo then
					adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for)
				else
					adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
				end if
				adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
				adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
				adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
				adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
				
				if lde_diferenca > 0 then
					adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',adw_contas_pagar.GetItemDecimal(ll_for, 'VALLIQUIDOTITULO'))
				else
					adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valpagamento)
				end if
				adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO', ls_Msg)
				adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb)
				adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
				adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
				adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
				
				
					
				if lde_diferenca > 0 then
					
					ll_newcontabil = adw_contabil_movimento.Insertrow(0)
				
					//Juros
					ll_idctadebitojuros = 4110401
				
				
					select  TIPONATUREZA into :ls_tiponaturezadeb 
						from CONTABIL_PLANO_CONTAS 
						WHERE  IDCTACONTABIL = :ll_idctadebitojuros USING SQLCA;
					
					//CONTA DEBITO
					adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebitojuros)
					adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
					if not lb_bxportitulo then
						adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for)
					else
						adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
					end if
					adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
					adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
					adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
					adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
					adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
					adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
					
					if lde_diferenca > 0 then
						adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_diferenca)
					end if
					adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO',ls_Msg)
					adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb)
					adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
					adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
					adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
					
				end if
			End If
		End If
	Next
	
	lde_valarqui1 = adw_contas_pagar.Object.compute_5[1] 
	lde_valarqui2 = adw_contas_pagar.Object.compute_6[1]
	
	if NOT lb_bxportitulo then
		
		ls_Msg = ls_Msg+  ". Importa$$HEX2$$e700e300$$ENDHEX$$o arq. SEFAZ."
		
		ll_newcontabil = adw_contabil_movimento.Insertrow(0)
	
		
		//CONTA CREDITO
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctacredito)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
		

		if not lb_bxportitulo then
			adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for)
		else
			adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
		end if
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','C')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idusuario)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
		if ll_agrupa = 1 then
			adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui1)
		else
			adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui2)
		end if						
		adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO', ls_Msg)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezacred) 
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',ldt_movimento)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
		
		
	
	
		ll_newcontabil = adw_contabil_movimento.Insertrow(0)
		
//		ll_idctadebito = adw_contas_pagar.GetItemnumber(ll_for,'idctacredito')
	
	
		select  TIPONATUREZA into :ls_tiponaturezadeb 
			from CONTABIL_PLANO_CONTAS 
			WHERE  IDCTACONTABIL = :ll_idctadebito USING SQLCA;
		
		//CONTA DEBITO
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebito)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
		if not lb_bxportitulo then
			adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for)
		else
			adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
		end if
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))

				
		if ll_agrupa = 1 then
			adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui1)
		else
			adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valarqui2)
		end if						
		
		adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO', ls_Msg)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb)
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
		adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
		
		
		
			
//		end if
	end if


	//lanca debito a taxa
	ll_newcontabil = adw_contabil_movimento.Insertrow(0)

	ll_idctadebito = ll_ctataxa


	select  TIPONATUREZA into :ls_tiponaturezadeb 
		from CONTABIL_PLANO_CONTAS 
		WHERE  IDCTACONTABIL = :ll_idctadebito USING SQLCA;
	
	//CONTA DEBITO
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebito)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
	if not lb_bxportitulo then
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for+1)
	else
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',2)
	end if
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO','LAN$$HEX1$$c700$$ENDHEX$$AMENTO TAXA BANCARIA APP SEFAZ')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valtaxa)
	
	
	//lanca credito da taxa 
	ll_newcontabil = adw_contabil_movimento.Insertrow(0)

	
	//CONTA CREDITO
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctacredito)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
	if not lb_bxportitulo then
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for+1)
	else
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',2)
	end if
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','C')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO','LAN$$HEX1$$c700$$ENDHEX$$AMENTO TAXA BANCARIA APP SEFAZ')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezacred)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_valtaxa)


Next



		

/*
//lan$$HEX1$$e700$$ENDHEX$$a o juros acumulado
if lde_jurostotal > 0 then
	
	ll_newcontabil = adw_contabil_movimento.Insertrow(0)
	
	//Juros
	ll_idctadebito = 4110401
	
	
	select  TIPONATUREZA into :ls_tiponaturezadeb 
		from CONTABIL_PLANO_CONTAS 
		WHERE  IDCTACONTABIL = :ll_idctadebito USING SQLCA;
	
	//CONTA DEBITO
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebito)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
	if not lb_bxportitulo then
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',ll_for)
	else
		adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
	end if
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', ll_idempresa)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', ll_idempresa)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', ll_idUsuario)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', 'PAG')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(ldt_movimento))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',lde_jurostotal)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO',ls_Msg)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(ldt_movimento))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTHORAULTIMAALTERACAO',of_get_data_atual( ))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')

end if
*/

Return 1
end function

on nv_funcoes.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_funcoes.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

