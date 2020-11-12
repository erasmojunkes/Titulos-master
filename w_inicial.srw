HA$PBExportHeader$w_inicial.srw
forward
global type w_inicial from window
end type
type em_ctataxa from editmask within w_inicial
end type
type st_4 from statictext within w_inicial
end type
type em_valtaxa from editmask within w_inicial
end type
type st_3 from statictext within w_inicial
end type
type cbx_agrupar from checkbox within w_inicial
end type
type dw_dtcaixa from datawindow within w_inicial
end type
type st_1 from statictext within w_inicial
end type
type st_2 from statictext within w_inicial
end type
type em_usuario from editmask within w_inicial
end type
type pb_3 from picturebutton within w_inicial
end type
type st_nomeusuario from statictext within w_inicial
end type
type dw_contabil_avulso from datawindow within w_inicial
end type
type dw_contas_pagar_avulso from datawindow within w_inicial
end type
type st_nomeforma from statictext within w_inicial
end type
type st_nomecliente from statictext within w_inicial
end type
type pb_2 from picturebutton within w_inicial
end type
type pb_1 from picturebutton within w_inicial
end type
type em_forma from editmask within w_inicial
end type
type st_forma from statictext within w_inicial
end type
type dw_contabil_movimento from datawindow within w_inicial
end type
type dw_contas_pagar_baixas from datawindow within w_inicial
end type
type cb_imprimir from commandbutton within w_inicial
end type
type cb_baixar from commandbutton within w_inicial
end type
type dw_contas_pagar from datawindow within w_inicial
end type
type em_idclifor from editmask within w_inicial
end type
type cb_importar from commandbutton within w_inicial
end type
type st_cliente from statictext within w_inicial
end type
type gb_1 from groupbox within w_inicial
end type
type gb_titulos from groupbox within w_inicial
end type
end forward

global type w_inicial from window
integer width = 5138
integer height = 2544
boolean titlebar = true
string title = "Baixa de t$$HEX1$$ed00$$ENDHEX$$tulos ICMS - Ver.: 2.0 (12/11/2020)"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "Form!"
boolean center = true
em_ctataxa em_ctataxa
st_4 st_4
em_valtaxa em_valtaxa
st_3 st_3
cbx_agrupar cbx_agrupar
dw_dtcaixa dw_dtcaixa
st_1 st_1
st_2 st_2
em_usuario em_usuario
pb_3 pb_3
st_nomeusuario st_nomeusuario
dw_contabil_avulso dw_contabil_avulso
dw_contas_pagar_avulso dw_contas_pagar_avulso
st_nomeforma st_nomeforma
st_nomecliente st_nomecliente
pb_2 pb_2
pb_1 pb_1
em_forma em_forma
st_forma st_forma
dw_contabil_movimento dw_contabil_movimento
dw_contas_pagar_baixas dw_contas_pagar_baixas
cb_imprimir cb_imprimir
cb_baixar cb_baixar
dw_contas_pagar dw_contas_pagar
em_idclifor em_idclifor
cb_importar cb_importar
st_cliente st_cliente
gb_1 gb_1
gb_titulos gb_titulos
end type
global w_inicial w_inicial

type variables
nv_Funcoes inv_Funcoes

String is_Sort

long il_idempresa
end variables

forward prototypes
public subroutine of_importar ()
public subroutine of_resetar_tela ()
end prototypes

public subroutine of_importar ();Long ll_idClifor, ll_Forma, ll_idUsuario
Date ldt_Movimento


nv_Titulos lnv_Titulos

lnv_Titulos = Create nv_Titulos 

of_Resetar_Tela( )

ll_idClifor = Long(em_idClifor.Text)
ll_Forma = long(em_forma.Text)
ll_idusuario = long(em_usuario.text)

ldt_Movimento = date(dw_dtcaixa.GetItemDate(1, 'dtmovimento'))

If inv_Funcoes.of_verifica_cliente(ll_idClifor) < 0 Then
	MessageBox('Dados do Cliente', 'Cliente informado inv$$HEX1$$e100$$ENDHEX$$lido.')
	Return 
End If

If inv_Funcoes.of_verifica_forma_pagamento(ll_forma) < 0 Then
	MessageBox('Dados informados', 'Forma de pagamento inv$$HEX1$$e100$$ENDHEX$$lida.')
	Return 
End If

If inv_Funcoes.of_verifica_usuario(ll_idUsuario) < 0 Then
	MessageBox('Dados informados', 'Us$$HEX1$$fa00$$ENDHEX$$ario informado inv$$HEX1$$e100$$ENDHEX$$lido.')
	Return 
End If

If inv_Funcoes.of_null( ldt_Movimento, Date('01/01/1900')) = Date('01/01/1900') Then
	MessageBox('Dados do informados', 'Data do Caixa inv$$HEX1$$e100$$ENDHEX$$lida.')
	Return 
End If


If lnv_Titulos.of_Importar(dw_contas_pagar, ll_idClifor, ll_Forma, ll_idUsuario, dw_contas_pagar_avulso, dw_contabil_avulso, ldt_Movimento) < 0 Then 
	of_Resetar_Tela( )
	Return
End If


il_idempresa = lnv_Titulos.of_get_empresa()



end subroutine

public subroutine of_resetar_tela ();dw_contas_pagar.SetTransObject(SQLCA)
dw_contas_pagar.Reset()

dw_contabil_movimento.SetTransObject(SQLCA)
dw_contabil_movimento.Reset()

dw_contas_pagar_baixas.SetTransObject(SQLCA)
dw_contas_pagar_baixas.Reset()

dw_contas_pagar_avulso.SetTransObject(SQLCA)
dw_contas_pagar_baixas.Reset()

end subroutine

event open;of_Resetar_Tela( )

inv_Funcoes = Create nv_Funcoes

pb_1.Triggerevent('clicked')
pb_2.Triggerevent('clicked')
pb_3.Triggerevent('clicked')

dw_dtcaixa.reset()
dw_dtcaixa.insertrow(0)
dw_dtcaixa.object.dtmovimento[1] = inv_funcoes.of_get_data_atual( )


end event

on w_inicial.create
this.em_ctataxa=create em_ctataxa
this.st_4=create st_4
this.em_valtaxa=create em_valtaxa
this.st_3=create st_3
this.cbx_agrupar=create cbx_agrupar
this.dw_dtcaixa=create dw_dtcaixa
this.st_1=create st_1
this.st_2=create st_2
this.em_usuario=create em_usuario
this.pb_3=create pb_3
this.st_nomeusuario=create st_nomeusuario
this.dw_contabil_avulso=create dw_contabil_avulso
this.dw_contas_pagar_avulso=create dw_contas_pagar_avulso
this.st_nomeforma=create st_nomeforma
this.st_nomecliente=create st_nomecliente
this.pb_2=create pb_2
this.pb_1=create pb_1
this.em_forma=create em_forma
this.st_forma=create st_forma
this.dw_contabil_movimento=create dw_contabil_movimento
this.dw_contas_pagar_baixas=create dw_contas_pagar_baixas
this.cb_imprimir=create cb_imprimir
this.cb_baixar=create cb_baixar
this.dw_contas_pagar=create dw_contas_pagar
this.em_idclifor=create em_idclifor
this.cb_importar=create cb_importar
this.st_cliente=create st_cliente
this.gb_1=create gb_1
this.gb_titulos=create gb_titulos
this.Control[]={this.em_ctataxa,&
this.st_4,&
this.em_valtaxa,&
this.st_3,&
this.cbx_agrupar,&
this.dw_dtcaixa,&
this.st_1,&
this.st_2,&
this.em_usuario,&
this.pb_3,&
this.st_nomeusuario,&
this.dw_contabil_avulso,&
this.dw_contas_pagar_avulso,&
this.st_nomeforma,&
this.st_nomecliente,&
this.pb_2,&
this.pb_1,&
this.em_forma,&
this.st_forma,&
this.dw_contabil_movimento,&
this.dw_contas_pagar_baixas,&
this.cb_imprimir,&
this.cb_baixar,&
this.dw_contas_pagar,&
this.em_idclifor,&
this.cb_importar,&
this.st_cliente,&
this.gb_1,&
this.gb_titulos}
end on

on w_inicial.destroy
destroy(this.em_ctataxa)
destroy(this.st_4)
destroy(this.em_valtaxa)
destroy(this.st_3)
destroy(this.cbx_agrupar)
destroy(this.dw_dtcaixa)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_usuario)
destroy(this.pb_3)
destroy(this.st_nomeusuario)
destroy(this.dw_contabil_avulso)
destroy(this.dw_contas_pagar_avulso)
destroy(this.st_nomeforma)
destroy(this.st_nomecliente)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.em_forma)
destroy(this.st_forma)
destroy(this.dw_contabil_movimento)
destroy(this.dw_contas_pagar_baixas)
destroy(this.cb_imprimir)
destroy(this.cb_baixar)
destroy(this.dw_contas_pagar)
destroy(this.em_idclifor)
destroy(this.cb_importar)
destroy(this.st_cliente)
destroy(this.gb_1)
destroy(this.gb_titulos)
end on

type em_ctataxa from editmask within w_inicial
integer x = 4581
integer y = 200
integer width = 407
integer height = 88
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "4110308"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = decimalmask!
string mask = "#########"
end type

type st_4 from statictext within w_inicial
integer x = 4096
integer y = 208
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cta Contabil Taxa"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_valtaxa from editmask within w_inicial
integer x = 3634
integer y = 192
integer width = 407
integer height = 88
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "2,50"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = decimalmask!
string mask = "###,##0.00"
end type

type st_3 from statictext within w_inicial
integer x = 3150
integer y = 200
integer width = 471
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valor Taxa Banco"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_agrupar from checkbox within w_inicial
integer x = 562
integer y = 2328
integer width = 896
integer height = 80
integer taborder = 120
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Gerar Baixas Individuais por t$$HEX1$$ed00$$ENDHEX$$tulo"
end type

type dw_dtcaixa from datawindow within w_inicial
integer x = 2688
integer y = 180
integer width = 439
integer height = 96
integer taborder = 70
string title = "none"
string dataobject = "d_dtcaixa"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_inicial
integer x = 2254
integer y = 196
integer width = 434
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Data Movimento"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_inicial
integer x = 41
integer y = 196
integer width = 407
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "C$$HEX1$$f300$$ENDHEX$$digo Usu$$HEX1$$e100$$ENDHEX$$rio"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_usuario from editmask within w_inicial
integer x = 457
integer y = 184
integer width = 407
integer height = 88
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "2"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#########"
end type

type pb_3 from picturebutton within w_inicial
integer x = 869
integer y = 184
integer width = 101
integer height = 88
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "Find!"
alignment htextalign = left!
end type

event clicked;string ls_nome
long ll_usuario
ll_usuario = long(em_usuario.text)

if ll_usuario > 0 then
	SELECT 
		NOMEUSUARIO 
	INTO 
		:ls_nome
	FROM
		DBA.USUARIO 
	WHERE
		IDUSUARIO = :ll_usuario 
	Using sqlca;
		
	st_nomeusuario.text = ls_nome; 
		

end if
end event

type st_nomeusuario from statictext within w_inicial
integer x = 983
integer y = 184
integer width = 1243
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type dw_contabil_avulso from datawindow within w_inicial
boolean visible = false
integer x = 3099
integer y = 2172
integer width = 1175
integer height = 124
integer taborder = 150
boolean titlebar = true
string title = "dw_contabil_movimento"
string dataobject = "d_contabil_movimento"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_contas_pagar_avulso from datawindow within w_inicial
boolean visible = false
integer x = 1906
integer y = 2172
integer width = 1175
integer height = 124
integer taborder = 160
boolean titlebar = true
string title = "dw_contas_pagar_avulso"
string dataobject = "d_duplicatas_pagar"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_nomeforma from statictext within w_inicial
integer x = 3063
integer y = 76
integer width = 978
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_nomecliente from statictext within w_inicial
integer x = 983
integer y = 76
integer width = 1243
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_inicial
integer x = 2958
integer y = 76
integer width = 101
integer height = 88
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "Find!"
alignment htextalign = left!
end type

event clicked;string ls_nome
long ll_idforma
ll_idforma = long(em_forma.text)

if ll_idforma> 0 then
	select  descrrecebimento into :ls_nome from dba.forma_pagrec where idrecebimento = :ll_idforma using sqlca;

	st_nomeforma.text = ls_nome;
	
end if




end event

type pb_1 from picturebutton within w_inicial
integer x = 869
integer y = 76
integer width = 101
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "Find!"
alignment htextalign = left!
end type

event clicked;string ls_nome
long ll_idclifor
ll_idclifor = long(em_idclifor.text)

if ll_idclifor > 0 then
	select  nome into :ls_nome from dba.cliente_fornecedor where idclifor = :ll_idclifor using sqlca;
	
	st_nomecliente.text = ls_nome;
	

end if
end event

type em_forma from editmask within w_inicial
integer x = 2697
integer y = 76
integer width = 251
integer height = 88
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "30"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "######"
end type

type st_forma from statictext within w_inicial
integer x = 2226
integer y = 88
integer width = 462
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Forma de Pagto."
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_contabil_movimento from datawindow within w_inicial
boolean visible = false
integer x = 3099
integer y = 2304
integer width = 1175
integer height = 124
integer taborder = 140
boolean titlebar = true
string title = "dw_contabil_movimento"
string dataobject = "d_contabil_movimento"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_contas_pagar_baixas from datawindow within w_inicial
boolean visible = false
integer x = 1906
integer y = 2304
integer width = 1175
integer height = 124
integer taborder = 170
boolean titlebar = true
string title = "dw_contas_pagar_baixas"
string dataobject = "d_contas_pagar_baixas"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_imprimir from commandbutton within w_inicial
integer x = 32
integer y = 2308
integer width = 457
integer height = 112
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Imprimir"
end type

event clicked;inv_Funcoes.of_Imprimir(dw_contas_pagar )
end event

type cb_baixar from commandbutton within w_inicial
integer x = 4585
integer y = 2308
integer width = 457
integer height = 112
integer taborder = 130
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Gravar Baixas"
end type

event clicked;long ll_forma, ll_ret, ll_idUsuario, ll_ctataxa
Date ldt_Movimento
Decimal ld_valtaxa
datawindow ldw_save[]
s_parametros ls_manda

ll_forma = long(em_forma.Text)
ll_idUsuario = long(em_Usuario.Text)
ldt_Movimento = dw_dtcaixa.GetItemDate(1, 'dtmovimento')
ll_ctataxa = long(em_ctataxa.text)
ld_valtaxa = dec(em_valtaxa.text)

nv_Titulos lnv_Titulos
lnv_Titulos = Create nv_Titulos 


ls_manda.long[1] = ll_forma
ls_manda.long[2] = ll_idUsuario
ls_manda.long[3] = ll_ctataxa
ls_manda.long[4] = il_idempresa
ls_manda.Decimal[1] = ld_valtaxa
ls_manda.date[1] = ldt_Movimento
ls_manda.boolean[1] = cbx_agrupar.checked

If inv_Funcoes.of_verifica_forma_pagamento(ll_forma) < 0 Then
	MessageBox('Dados informados', 'Forma de pagamento inv$$HEX1$$e100$$ENDHEX$$lida.')
End If

ll_ret = inv_Funcoes.of_baixa_titulo( ref dw_contas_pagar,ref dw_contas_pagar_baixas,ref dw_contabil_movimento, Ref dw_contas_pagar_avulso, Ref ls_manda, ldt_Movimento)

if ll_ret < 0 then
	messagebox('Aviso','Grava$$HEX2$$e700e300$$ENDHEX$$o abortada.', StopSign!)
	return
else
	
	ldw_save[1]= dw_contas_pagar_avulso
	ldw_save[2]= dw_contabil_avulso
	ldw_save[3]= dw_contas_pagar_baixas
	ldw_save[4]= dw_contabil_movimento
	
	
	If inv_Funcoes.of_update(ldw_save) < 0 Then
		MessageBox('Erro','Problemas durante a grava$$HEX2$$e700e300$$ENDHEX$$o.', StopSign!)
	Else
		inv_Funcoes.of_salvar_importado(dw_contas_pagar)
		of_Resetar_tela( )
	End If
	
	
end if
	
	





end event

type dw_contas_pagar from datawindow within w_inicial
integer x = 64
integer y = 388
integer width = 4942
integer height = 1856
string title = "none"
string dataobject = "d_contas_pagar"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String ls_coluna, ls_newcol 
ls_coluna = dwo.name

if right(ls_coluna,2) = '_t' then
	ls_newcol = left(ls_coluna,len(ls_coluna)-2)

	if Trim(is_Sort) = "A" then
		is_Sort = " D"
		this.SetSort(ls_newcol + is_Sort) 
	else
		is_Sort = " A"  
		this.SetSort(ls_newcol + is_Sort) 
	end if

	this.sort()
	
end if

end event

type em_idclifor from editmask within w_inicial
integer x = 457
integer y = 76
integer width = 407
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "10875"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#########"
end type

type cb_importar from commandbutton within w_inicial
integer x = 4576
integer y = 72
integer width = 411
integer height = 100
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Importar"
end type

event clicked;of_Importar( )

end event

type st_cliente from statictext within w_inicial
integer x = 41
integer y = 88
integer width = 407
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "C$$HEX1$$f300$$ENDHEX$$digo Cliente"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_inicial
integer x = 32
integer y = 12
integer width = 5019
integer height = 308
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217741
long backcolor = 67108864
string text = "Importa$$HEX2$$e700e300$$ENDHEX$$o"
end type

type gb_titulos from groupbox within w_inicial
integer x = 32
integer y = 320
integer width = 5029
integer height = 1968
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217741
long backcolor = 67108864
string text = "Titulos a Baixar"
end type

