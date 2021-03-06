$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type st_status from statictext within w_main
end type
type st_1 from statictext within w_main
end type
type sle_ip from singlelineedit within w_main
end type
type cb_ping from commandbutton within w_main
end type
type str_wsadata from structure within w_main
end type
type str_inaddr from structure within w_main
end type
type str_ip_option_information from structure within w_main
end type
type str_icmp_echo_reply from structure within w_main
end type
end forward

type str_wsadata from structure
	unsignedinteger		version
	unsignedinteger		highversion
	character		description[257]
	character		systemstatus[129]
	unsignedinteger		maxsockets
	unsignedinteger		maxupddg
	string		vendorinfo
end type

type str_inaddr from structure
	unsignedlong		s_addr
end type

type str_ip_option_information from structure
	character		ttl
	character		tos
	character		flags
	character		optionssize
	unsignedlong		optionsdata
end type

type str_icmp_echo_reply from structure
	unsignedlong		address
	unsignedlong		status
	unsignedlong		roundtriptime
	unsignedlong		datasize
	unsignedinteger		reserved
	unsignedlong		ptrdata
	str_ip_option_information		options
	character		data[256]
end type

global type w_main from window
integer width = 1573
integer height = 544
boolean titlebar = true
string title = "Ping"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_status st_status
st_1 st_1
sle_ip sle_ip
cb_ping cb_ping
end type
global w_main w_main

type prototypes
//Open the socket connection.
Function Integer WSAStartup( UInt UIVersionRequested, Ref str_WSAData lpWSAData ) Library "wsock32.dll" Alias For "WSAStartup;ANSI"
//Clean up sockets.
Function Integer WSACleanup() Library "wsock32.dll" Alias For "WSACleanup;ANSI"
//Create a handle on which Internet Control Message Protocol (ICMP) requests can be issued.
Function ULong IcmpCreateFile() Library "icmp.dll"
//Close an Internet Control Message Protocol (ICMP) handle that IcmpCreateFile opens.
Function ULong IcmpCloseHandle(ULong IcmpHandle) Library "icmp.dll"
//Send an Internet Control Message Protocol (ICMP) echo request, and then return one or more replies.
Function ULong IcmpSendEcho(ULong IcmpHandle,ULong DestinationAddress,String RequestData,ULong RequestSize,ULong RequestOptions,Ref str_icmp_echo_reply ReplyBuffer,ULong ReplySize,ULong TimeOut) Library "icmp.dll" Alias For "IcmpSendEcho;ANSI"
// Convert a string that contains an (Ipv4) Internet Protocol dotted address into a correct address.
Function ULong inet_addr(String ip_addr) Library "ws2_32.dll" Alias For "inet_addr;ANSI"

end prototypes

type variables
Constant ULong WS_VERSION_REQD = 257

Constant Long ICMP_SUCCESS = 0
Constant Long ICMP_STATUS_BUFFER_TO_SMALL = 11001 //Buffer Too Small
Constant Long ICMP_STATUS_DESTINATION_NET_UNREACH = 11002 //Destination Net Unreachable
Constant Long ICMP_STATUS_DESTINATION_HOST_UNREACH = 11003 //Destination Host Unreachable
Constant Long ICMP_STATUS_DESTINATION_PROTOCOL_UNREACH = 11004 //Destination Protocol Unreachable
Constant Long ICMP_STATUS_DESTINATION_PORT_UNREACH = 11005 //Destination Port Unreachable
Constant Long ICMP_STATUS_NO_RESOURCE = 11006 //No Resources
Constant Long ICMP_STATUS_BAD_OPTION = 11007 //Bad Option
Constant Long ICMP_STATUS_HARDWARE_ERROR = 11008 //Hardware Error
Constant Long ICMP_STATUS_LARGE_PACKET = 11009 //Packet Too Big
Constant Long ICMP_STATUS_REQUEST_TIMED_OUT = 11010 //Request Timed Out
Constant Long ICMP_STATUS_BAD_REQUEST = 11011 //Bad Request
Constant Long ICMP_STATUS_BAD_ROUTE = 11012 //Bad Route
Constant Long ICMP_STATUS_TTL_EXPIRED_TRANSIT = 11013 //TimeToLive Expired Transit
Constant Long ICMP_STATUS_TTL_EXPIRED_REASSEMBLY = 11014 //TimeToLive Expired Reassembly
Constant Long ICMP_STATUS_PARAMETER = 11015 //Parameter Problem
Constant Long ICMP_STATUS_SOURCE_QUENCH = 11016 //Source Quench
Constant Long ICMP_STATUS_OPTION_TOO_BIG = 11017 //Option Too Big
Constant Long ICMP_STATUS_BAD_DESTINATION = 11018 //Bad Destination
Constant Long ICMP_STATUS_NEGOTIATING_IPSEC = 11032 //Negotiating IPSEC
Constant Long ICMP_STATUS_GENERAL_FAILURE = 11050 //General Failure

end variables

forward prototypes
public function string wf_icmpmsg (unsignedlong pingresponse)
end prototypes

public function string wf_icmpmsg (unsignedlong pingresponse);String  ls_ret

Choose Case PingResponse
	Case ICMP_SUCCESS
		ls_ret = "Success!"
	Case ICMP_STATUS_BUFFER_TO_SMALL
		ls_ret = "Buffer Too Small"
	Case ICMP_STATUS_DESTINATION_NET_UNREACH
		ls_ret = "Destination Net Unreachable"
	Case ICMP_STATUS_DESTINATION_HOST_UNREACH
		ls_ret = "Destination Host Unreachable"
	Case ICMP_STATUS_DESTINATION_PROTOCOL_UNREACH
		ls_ret = "Destination Protocol Unreachable"
	Case ICMP_STATUS_DESTINATION_PORT_UNREACH
		ls_ret = "Destination Port Unreachable"
	Case ICMP_STATUS_NO_RESOURCE
		ls_ret = "No Resources"
	Case ICMP_STATUS_BAD_OPTION
		ls_ret = "Bad Option"
	Case ICMP_STATUS_HARDWARE_ERROR
		ls_ret = "Hardware Error"
	Case ICMP_STATUS_LARGE_PACKET
		ls_ret = "Packet Too Big"
	Case ICMP_STATUS_REQUEST_TIMED_OUT
		ls_ret = "Request Timed Out"
	Case ICMP_STATUS_BAD_REQUEST
		ls_ret = "Bad Request"
	Case ICMP_STATUS_BAD_ROUTE
		ls_ret = "Bad Route"
	Case ICMP_STATUS_TTL_EXPIRED_TRANSIT
		ls_ret = "TimeToLive Expired Transit"
	Case ICMP_STATUS_TTL_EXPIRED_REASSEMBLY
		ls_ret = "TimeToLive Expired Reassembly"
	Case ICMP_STATUS_PARAMETER
		ls_ret = "Parameter Problem"
	Case ICMP_STATUS_SOURCE_QUENCH
		ls_ret = "Source Quench"
	Case ICMP_STATUS_OPTION_TOO_BIG
		ls_ret = "Option Too Big"
	Case ICMP_STATUS_BAD_DESTINATION
		ls_ret = "Bad Destination"
	Case ICMP_STATUS_NEGOTIATING_IPSEC
		ls_ret = "Negotiating IPSEC"
	Case ICMP_STATUS_GENERAL_FAILURE
		ls_ret = "General Failure"
	Case Else
		ls_ret = "Unknown Response"
End Choose

Return ls_ret

end function

on w_main.create
this.st_status=create st_status
this.st_1=create st_1
this.sle_ip=create sle_ip
this.cb_ping=create cb_ping
this.Control[]={this.st_status,&
this.st_1,&
this.sle_ip,&
this.cb_ping}
end on

on w_main.destroy
destroy(this.st_status)
destroy(this.st_1)
destroy(this.sle_ip)
destroy(this.cb_ping)
end on

type st_status from statictext within w_main
integer x = 402
integer y = 192
integer width = 1097
integer height = 224
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Status"
boolean focusrectangle = false
end type

type st_1 from statictext within w_main
integer y = 64
integer width = 366
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "IP Address:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ip from singlelineedit within w_main
integer x = 402
integer y = 52
integer width = 1097
integer height = 96
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_ping from commandbutton within w_main
integer x = 110
integer y = 168
integer width = 256
integer height = 112
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ping"
end type

event clicked;str_wsadata lstr_wsadata
str_icmp_echo_reply lstr_reply
ULong lul_timeout, lul_address, lul_hIcmp, lul_size
Integer li_res
String ls_pingIP, ls_send, ls_msg
nvo_sizeof ln_size

ls_pingIP = sle_ip.Text // "192.168.1.1" 
ls_send = "hello"
lul_timeout = 1000 //(ms, 1 second)

lstr_wsadata.vendorinfo = Space(256)
//Establish SOCKET
li_res = wsastartup (WS_VERSION_REQD, lstr_wsadata)
If li_res <> 0 Then Return
//Convert IP address string
lul_address = inet_addr(ls_pingIP)
If lul_address <> -1 And lul_address <> 0 Then
	//Create ICMP request
	lul_hIcmp = IcmpCreateFile()
	If IsNull(lul_hIcmp) Then
		//MessageBox("error","ICMP request establishment failed!")
		st_status.text = "ICMP request establishment failed!"
	Else
		lul_size = ln_size.sizeof(lstr_reply)
		IcmpSendEcho(lul_hIcmp, lul_address, ls_send, Len(ls_send), 0, lstr_reply,lul_size,lul_timeout)
		
		//Get information
		ls_msg = wf_icmpmsg(lstr_reply.status)
		/*
		MessageBox("Ping "+ ls_pingIP +" :", "Icmp code: "+ String(lstr_reply.status) + "~r~n" + &
			"Response Message: "+ ls_msg + "~r~n" + &
			"Time: "+ String(lstr_reply.RoundTripTime) +" ms")
		*/		
		st_status.text = "Icmp code: "+ String(lstr_reply.status) + "~r~n" +  &
		"Response Message: "+ ls_msg + "~r~n" +  &
		"Time: "+ String(lstr_reply.RoundTripTime) +" ms"
		//Close ICMP request
		IcmpCloseHandle(lul_hIcmp)
		
	End If
Else
	MessageBox("error","IP address is illegal!")
End If
//Close SOCKET
wsacleanup()

end event

