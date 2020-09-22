REM  *****  BASIC  *****

Sub Main

End Sub

Sub ExportToCsv
    document = ThisComponent

    ' Use the global string tools library to generate a path to save each CSV
    GlobalScope.BasicLibraries.loadLibrary("Tools")
    FileDirectory = Tools.Strings.DirectoryNameoutofPath(document.getURL(), "/")

    ' Work out number of sheets for looping over them later.
    Sheets = document.Sheets
    NumSheets = Sheets.Count - 1

    ' Set up a propval object to store the filter properties
    Dim Propval(1) as New com.sun.star.beans.PropertyValue
    Propval(0).Name = "FilterName"
    Propval(0).Value = "Text - txt - csv (StarCalc)"
    Propval(1).Name = "FilterOptions"
    Propval(1).Value ="59,34,0,1,1"   'ASCII  59 = ; 44 = , 34 = "

    For I = 0 to NumSheets
        ' For each sheet, assemble a filename and save using the filter
        document.getCurrentController.setActiveSheet(Sheets(I))
        Filename = FileDirectory + "/" + Sheets(I).Name + ".csv"
        FileURL = convertToURL(Filename)
        document.StoreToURL(FileURL, Propval())
    Next I

End Sub

Sub ToCsv_CommaSep
    document = ThisComponent

    ' Use the global string tools library to generate a path to save each CSV
    GlobalScope.BasicLibraries.loadLibrary("Tools")
    FileDirectory = Tools.Strings.DirectoryNameoutofPath(document.getURL(), "/")

    ' Work out number of sheets for looping over them later.
    Sheets = document.Sheets
    NumSheets = Sheets.Count - 1

    ' Set up a propval object to store the filter properties
    Dim Propval(1) as New com.sun.star.beans.PropertyValue
    Propval(0).Name = "FilterName"
    Propval(0).Value = "Text - txt - csv (StarCalc)"
    Propval(1).Name = "FilterOptions"
    Propval(1).Value ="44,34,0,1,1"   'ASCII  44 = ,  34 = "

    For I = 0 to NumSheets
        ' For each sheet, assemble a filename and save using the filter
        document.getCurrentController.setActiveSheet(Sheets(I))
        Filename = FileDirectory + "/" + Sheets(I).Name + ".csv"
        FileURL = convertToURL(Filename)
        document.StoreToURL(FileURL, Propval())
    Next I

End Sub



Function EscapeString( Str as String )
	Dim Counter As Integer
	Dim Char As String
	Dim Result As String : Result = ""
	
	Dim AlphaNum as String : AlphaNum = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	
	For Counter = 1 To Len(Str)
	    Char = Mid(Str, Counter, 1)
	    
		If InStr( 1, AlphaNum, Char ) > 0 Then
		 	Result = Mid(Str, Counter, Len(Str) - Counter + 1)
		  	Exit For
		End If
	Next
	Str = Result
	
	For Counter = Len(Str) to 1 step -1
	    Char = Mid(Str, Counter, 1)
	    
    	If InStr( 1, AlphaNum, Char ) > 0 Then
		    Result = Mid(Str, 1, Counter)
		    Exit For
	    End If
	Next
	Str = Result
	
	
	Result = ""
	Dim Collapse As Boolean : Collapse = false
	For Counter = 1 To Len(Str)
	    Char = Mid(Str, Counter, 1)
	    
		If InStr( 1, AlphaNum, Char ) > 0 Then
		 	Result = Result + Char
		 	Collapse = false
		Else
			If Not Collapse Then
				Result = Result + "_"
				Collapse = true
			End If
		End If
	Next
	
	EscapeString = Result
End Function


Function ArcCosine( X As Double )
	ArcCosine = Atn(-X / Sqr(-X * X + 1)) + 2 * Atn(1)
End Function




Function GetBigArcDistance( LatA_Deg As Double, LonA_Deg As Double, LatB_Deg As Double, LonB_Deg As Double )
    Dim LatA_Rad As Double
    Dim LonA_Rad As Double
    Dim LatB_Rad As Double
    Dim LonB_Rad As Double

    Dim EarthRadius As Double: EarthRadius = 6371
    Dim CentralAngle As Double
    Dim DeltaLambda As Double
    Dim Pi As Double: Pi = 3.14159265
    
    Dim Distance As Double
    
    LatA_Rad = (LatA_Deg / 180.0) * Pi
    LonA_Rad = (LonA_Deg / 180.0) * Pi
    LatB_Rad = (LatB_Deg / 180.0) * Pi
    LonB_Rad = (LonB_Deg / 180.0) * Pi
    
    If Abs( LonB_Rad - LonA_Rad ) + Abs( LatB_Rad - LatA_Rad ) < 0.00001 Then
    	GetBigArcDistance = 0
    Else  
	    DeltaLambda = Abs( LonB_Rad - LonA_Rad )
	    CentralAngle = ArcCosine( Sin( LatA_Rad ) * Sin( LatB_Rad ) + Cos( LatA_Rad ) * Cos( LatB_Rad ) * Cos( DeltaLambda ) )
	    Distance = EarthRadius * CentralAngle
	    
	    GetBigArcDistance = Distance
	End If
End Function


' xsd:simpleType name="time__type": "\d{2,5}:\d{2}(:\d{2})?"
Function GetHoursFromRDT( par_RDT As String )
	Dim FirstColonPos As Integer
	Dim SecondColonPos As Integer
	
	Dim Hours As Integer
	Dim Minutes As Integer
	Dim Seconds As Integer
	
	
	FirstColonPos = InStr( 1, par_RDT, ":" )
	If FirstColonPos < 2 Then
		MsgBox( "Not a RDT value: " + """" + par_RDT + """; " + """\d{2,5}:\d{2}(:\d{2})?"" is expected" )
		Exit Function
	End If
	
	SecondColonPos = InStr( FirstColonPos + 1, par_RDT, ":" )
	
	If SecondColonPos = 0 Then
		' 09:00
		' no seconds
		Hours = Mid( par_RDT, 1, FirstColonPos - 1 )
		Minutes = Mid( par_RDT, FirstColonPos + 1, Len(par_RDT) - FirstColonPos )
		Seconds = 0
	Else
		' 09:00:01
		Hours = Mid( par_RDT, 1, FirstColonPos - 1 )
		Minutes = Mid( par_RDT, FirstColonPos + 1, SecondColonPos - FirstColonPos - 1 )
		Seconds = Mid( par_RDT, FirstColonPos + 1, Len(par_RDT) - SecondColonPos )
	End If
	
	
	GetHoursFromRDT = Hours
End Function


' xsd:simpleType name="time__type": "\d{2,5}:\d{2}(:\d{2})?"
Function GetMinutesFromRDT( par_RDT As String )
	Dim FirstColonPos As Integer
	Dim SecondColonPos As Integer
	
	Dim Hours As Integer
	Dim Minutes As Integer
	Dim Seconds As Integer
	
	
	FirstColonPos = InStr( 1, par_RDT, ":" )
	If FirstColonPos < 2 Then
		MsgBox( "Not a RDT value: " + """" + par_RDT + """; " + """\d{2,5}:\d{2}(:\d{2})?"" is expected" )
		Exit Function
	End If
	
	SecondColonPos = InStr( FirstColonPos + 1, par_RDT, ":" )
	
	If SecondColonPos = 0 Then
		' 09:00
		' no seconds
		Hours = Mid( par_RDT, 1, FirstColonPos - 1 )
		Minutes = Mid( par_RDT, FirstColonPos + 1, Len(par_RDT) - FirstColonPos )
		Seconds = 0
	Else
		' 09:00:01
		Hours = Mid( par_RDT, 1, FirstColonPos - 1 )
		Minutes = Mid( par_RDT, FirstColonPos + 1, SecondColonPos - FirstColonPos - 1 )
		Seconds = Mid( par_RDT, FirstColonPos + 1, Len(par_RDT) - SecondColonPos )
	End If
	
	
	GetMinutesFromRDT = Minutes
End Function

' xsd:simpleType name="time__type": "\d{2,5}:\d{2}(:\d{2})?"
Function GetSecondsFromRDT( par_RDT_raw As String )
	Dim par_RDT As String : par_RDT = Trim( par_RDT_raw )
	Dim FirstColonPos As Integer
	Dim SecondColonPos As Integer
	
	Dim Hours As Integer
	Dim Minutes As Integer
	Dim Seconds As Integer
	
	
	FirstColonPos = InStr( 1, par_RDT, ":" )
	If FirstColonPos < 2 Then
		MsgBox( "Not a RDT value: " + """" + par_RDT + """; " + """\d{2,5}:\d{2}(:\d{2})?"" is expected" )
		Exit Function
	End If
	
	SecondColonPos = InStr( FirstColonPos + 1, par_RDT, ":" )
	
	If 	SecondColonPos = 0 And (FirstColonPos < 2 Or FirstColonPos <> Len(par_RDT) - 2) _
		Or _
		SecondColonPos > 0 And (FirstColonPos < 2 Or SecondColonPos <> FirstColonPos + 3 Or SecondColonPos <> Len(par_RDT) - 2) Then
			MsgBox( "Not a RDT value: " + """" + par_RDT + """; " + """\d{2,5}:\d{2}(:\d{2})?"" is expected" )
			Exit Function
	End If
		
		
	
	
	If SecondColonPos = 0 Then
		
		' 09:00
		' no seconds
		Hours = Mid( par_RDT, 1, FirstColonPos - 1 )
		Minutes = Mid( par_RDT, FirstColonPos + 1, Len(par_RDT) - FirstColonPos )
		Seconds = 0
	Else
		' 09:00:01
		Hours = Mid( par_RDT, 1, FirstColonPos - 1 )
		Minutes = Mid( par_RDT, FirstColonPos + 1, SecondColonPos - FirstColonPos - 1 )
		Seconds = Mid( par_RDT, SecondColonPos + 1, Len(par_RDT) - SecondColonPos )
	End If
	
	
	GetSecondsFromRDT = Seconds
End Function

Function GetDaysFromRDT( par_RDT_raw As String )
	GetDaysFromRDT = GetHoursFromRDT( par_RDT_raw ) \ 24
End Function

Function GetNormalizedTimeFromRDT( par_RDT_raw As String )
	GetNormalizedTimeFromRDT = CStr(GetHoursFromRDT( par_RDT_raw ) Mod 24) + ":" + CStr(GetMinutesFromRDT( par_RDT_raw )) + ":" + CStr(GetSecondsFromRDT( par_RDT_raw ))
End Function



Function GetTownsKey( par_OrCity As String, par_OrState As String, par_DestCity As String, par_DestState As String )
	GetTownsKey = UCase(EscapeString(par_OrCity)) +  "_" + UCase(EscapeString(par_OrState)) + "-" + UCase(EscapeString(par_DestCity)) + "_" + UCase(EscapeString(par_DestState))
End Function

