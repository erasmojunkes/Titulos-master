HA$PBExportHeader$w_inicial.srw
forward
global type w_inicial from window
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
integer width = 4809
integer height = 2544
boolean titlebar = true
string title = "Baixa de t$$HEX1$$ed00$$ENDHEX$$tulos ICMS - Ver.: 1.0 (19/10/2020)"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "Form!"
boolean center = true
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




end subroutine

public subroutine of_resetar_tela ();inv_Funcoes = Create nv_Funcoes

dw_contas_pagar.SetTransObject(SQLCA)
dw_contas_pagar.Reset()

dw_contabil_movimento.SetTransObject(SQLCA)
dw_contabil_movimento.Reset()

dw_contas_pagar_baixas.SetTransObject(SQLCA)
dw_contas_pagar_baixas.Reset()

dw_contas_pagar_avulso.SetTransObject(SQLCA)
dw_contas_pagar_baixas.Reset()

end subroutine

event open;of_Resetar_Tela( )


pb_1.Triggerevent('clicked')
pb_2.Triggerevent('clicked')
pb_3.Triggerevent('clicked')

dw_dtcaixa.SetTransObject(SQLCA)
dw_dtcaixa.Retrieve()


end event

on w_inicial.create
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
this.Control[]={this.dw_dtcaixa,&
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

type dw_dtcaixa from datawindow within w_inicial
integer x = 2688
integer y = 180
integer width = 754
integer height = 96
integer taborder = 30
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
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
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
integer taborder = 80
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
integer taborder = 80
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
integer taborder = 30
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
integer taborder = 30
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
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
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
integer taborder = 70
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
integer taborder = 80
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
integer taborder = 50
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
integer x = 4297
integer y = 2308
integer width = 457
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Gravar Baixas"
end type

event clicked;long ll_forma, ll_ret, ll_idUsuario
Date ldt_Movimento
datawindow ldw_save[]

ll_forma = long(em_forma.Text)
ll_idUsuario = long(em_Usuario.Text)
ldt_Movimento = dw_dtcaixa.GetItemDate(1, 'dtmovimento')

nv_Titulos lnv_Titulos
lnv_Titulos = Create nv_Titulos 


If inv_Funcoes.of_verifica_forma_pagamento(ll_forma) < 0 Then
	MessageBox('Dados informados', 'Forma de pagamento inv$$HEX1$$e100$$ENDHEX$$lida.')
End If

ll_ret = inv_Funcoes.of_baixa_titulo( ref dw_contas_pagar,ref dw_contas_pagar_baixas,ref dw_contabil_movimento, ll_forma, ll_idUsuario, ldt_Movimento)

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
integer y = 360
integer width = 4649
integer height = 1884
string title = "none"
string dataobject = "d_contas_pagar"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

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
string text = "10875"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#########"
end type

type cb_importar from commandbutton within w_inicial
integer x = 4315
integer y = 72
integer width = 402
integer height = 100
integer taborder = 30
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
integer width = 4722
integer height = 288
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
integer y = 300
integer width = 4722
integer height = 1980
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

