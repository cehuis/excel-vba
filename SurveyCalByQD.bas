Attribute VB_Name = "SurveyCalByQD"
'��λ�Ǽ��㺯�� Azimuth()
'SxΪ���X��SyΪ���Y
'ExΪ�յ�X��EyΪ�յ�Y
'Styleָ������ֵ��ʽ
'Style=-1Ϊ���ȸ�ʽ
'Style=0Ϊ��DD MM SS����ʽ
'Style=1Ϊ��DD-MM-SS����ʽ
'Style=2Ϊ��DD��MM�@SS""����ʽ
'Style=����ֵʱ����ʮ���ƶ�ֵ


Function aa(area1 As Double, area2 As Double) As Double
Dim rat As Double
rat = area1 / area2
If (rat < 0.6 Or rat > (1 / 0.6)) And area1 <> 0 And area2 <> 0 Then
aa = (area1 + area2 + sqrt(area1 * area2)) / 3
Else
aa = (area1 + area2) / 2
End If
End Function


Function Azimuth(Sx As Double, Sy As Double, Ex As Double, Ey As Double, Style As Integer)
Dim DltX As Double, DltY As Double, A_tmp As Double, Pi As Double
Pi = Atn(1) * 4 '����PIֵ
DltX = Ex - Sx
DltY = Ey - Sy + 1E-20
A_tmp = Pi * (1 - Sgn(DltY) / 2) - Atn(DltX / DltY) '���㷽λ��
A_tmp = A_tmp * 180 / Pi 'ת��Ϊ360���ƽǶ�
Azimuth = Deg2DMS(A_tmp, Style)
End Function

'ת��ʮ���ƽǶ�Ϊ�ȷ���
'Style=-1Ϊ���ȸ�ʽ
'Style=0Ϊ��DD MM SS����ʽ
'Style=1Ϊ��DD-MM-SS����ʽ
'Style=2Ϊ��DD��MM�@SS""����ʽ
'Style=����ֵʱ����ʮ���ƶ�ֵ
Function Deg2DMS(DegValue As Double, Style As Integer)
Dim tD As Integer, tM As Integer, tS As Double, tmp As Double, SignChar As String
If Sgn(DegValue) = -1 Then
SignChar = "-"
Else
SignChar = ""
End If
DegValue = Abs(DegValue)
tD = Fix(DegValue)
tmp = (DegValue - tD) * 60
tM = Fix(tmp)
tmp = (tmp - tM) * 60
tS = Round(tmp, 1)
Select Case Style
Case -1 '���ػ���
If SignChar = "-" Then
Deg2DMS = -DegValue * Atn(1) * 4 / 180
Else
Deg2DMS = DegValue * Atn(1) * 4 / 180
End If
Case 0
Deg2DMS = SignChar & tD & " " & Format(tM, "00") & " " & Format(tS, "00.0")
Case 1
Deg2DMS = SignChar & tD & "-" & Format(tM, "00") & "-" & Format(tS, "00.0")
Case 2
Deg2DMS = SignChar & tD & "��" & Format(tM, "00") & "�@" & Format(tS, "00.0") & """"
Case Else
If SignChar = "-" Then
Deg2DMS = -DegValue
Else
Deg2DMS = DegValue
End If
End Select

End Function

'���ֹ������D.MMSS��ʽ�ȷ���ת��Ϊʮ���ƶȱ��ڼ���
Function DMS2Deg(Dms As Double) As Double
Dim tmpD As Integer, tmpM As Integer, tmpS As Double
tmpD = Fix(Dms)
tmpM = Fix((Dms - tmpD) * 100)
tmpS = ((Dms - tmpD) * 100 - tmpM) * 100
DMS2Deg = tmpD + tmpM / 60# + tmpS / 3600#
End Function

Function Distance(Sx As Double, Sy As Double, Ex As Double, Ey As Double, Precision As Integer) As Double
Dim DltX As Double, DltY As Double
DltX = Ex - Sx
DltY = Ey - Sy
Distance = Round(Sqr(DltX * DltX + DltY * DltY), Precision)
End Function

Function inValue(stgA As Double, Av As Double, stgB As Double, Bv As Double, stgC As Double) As Double
If stgB <> stgA Then
inValue = Av + (Bv - Av) / (stgB - stgA) * (stgC - stgA)
Else
inValue = -9.9999999
End If
End Function


Function pol(AX As Double, AY As Double, Bx As Double, By As Double) As String
pol = Azimuth(AX, AY, Bx, By, 2) & " " & Distance(AX, AY, Bx, By, 3)
End Function


Function rec(alpha As String, dist As Double) As String
Dim Alpha_Rad As Double
Alpha_Rad = StringToRad(alpha)
rec = "dx:" & Round(Cos(Alpha_Rad) * dist, 3) & " dy:" & Round(Sin(Alpha_Rad) * dist, 3)
End Function


Function StringToRad(strAz) '���ַ�����ʽ��λ��ת���ɻ��ȸ�ʽ
Dim azSubStr
If strAz <> "" Then
azSubStr = Split(strAz, "-")

If UBound(azSubStr) = 2 Then
StringToRad = (azSubStr(0) + azSubStr(1) / 60 + azSubStr(2) / 3600) * Atn(1) * 4 / 180
Else
StringToRad = 0
End If

Else
StringToRad = 0
End If
End Function

'��ɽ������ 2010-09-08
'�ж��Ƿ��������ϵ�����
Function CoSysTableExist() As Boolean
Dim i As Long
CoSysTableExist = False
For i = 1 To Sheets.Count
If Sheets(i).Name = "CoSys" Then
CoSysTableExist = True
Exit For
End If
Next
'If Not CoSysTableExist Then
'Dim NewTable As Sheets
'End If
End Function

'��������ϵ���Ʋ����ز���
Function CoSysFndPara(CoSysName As String) As String
Dim FndIndex As Long
If CoSysTableExist Then
    For FndIndex = 1 To 100
        If Trim(Sheets("CoSys").Range("A" & FndIndex).Text) = Trim(CoSysName) Then
            CoSysFndPara = Trim(Sheets("CoSys").Range("B" & FndIndex).Text)                      'AX
            CoSysFndPara = CoSysFndPara & "," & Trim(Sheets("CoSys").Range("C" & FndIndex).Text) 'AY
            CoSysFndPara = CoSysFndPara & "," & Trim(Sheets("CoSys").Range("D" & FndIndex).Text) 'Ax
            CoSysFndPara = CoSysFndPara & "," & Trim(Sheets("CoSys").Range("E" & FndIndex).Text) 'Ay
            If InStr(Trim(Sheets("CoSys").Range("F" & FndIndex).Text), "-") <> 0 Then
            CoSysFndPara = CoSysFndPara & "," & Trim(Sheets("CoSys").Range("F" & FndIndex).Text) 'az
            Else
            CoSysFndPara = CoSysFndPara & "," & Azimuth(Trim(Sheets("CoSys").Range("B" & FndIndex).Text), Trim(Sheets("CoSys").Range("C" & FndIndex).Text), Trim(Sheets("CoSys").Range("F" & FndIndex).Text), Trim(Sheets("CoSys").Range("G" & FndIndex).Text), 1) 'BY or Type
            End If
            Exit For
        End If
    Next
Else
    CoSysFndPara = ""
End If
End Function

'��ͼ����תʩ������
Function NE2SO_STG(CoSysName As String, P_N As Double, P_E As Double) As Double
Dim coSysParaStr As String
Dim coSysPara
Dim O_X As Double, O_Y As Double, O_Stage As Double, O_Offset As Double, X_Line_Azimuth_Str As Double

'��ȡ����ϵ����
coSysParaStr = CoSysFndPara(CoSysName)
coSysPara = Split(coSysParaStr, ",")

O_X = coSysPara(0)         '�����ͼ����
O_Y = coSysPara(1)

O_Stage = coSysPara(2)     '����ʩ������
O_Offset = coSysPara(3)

X_Line_Azimuth_Str = StringToRad(coSysPara(4)) 'ʩ������ϵX�᷽λ��,����

NE2SO_STG = Round((P_N - O_X) * Cos(X_Line_Azimuth_Str) + (P_E - O_Y) * Sin(X_Line_Azimuth_Str) + O_Stage, 3)
End Function

'��ͼ����תʩ������
Function NE2SO_OFF(CoSysName As String, P_N As Double, P_E As Double) As Double
Dim coSysParaStr As String
Dim coSysPara
Dim O_X As Double, O_Y As Double, O_Stage As Double, O_Offset As Double, X_Line_Azimuth_Str As Double

'��ȡ����ϵ����
coSysParaStr = CoSysFndPara(CoSysName)
coSysPara = Split(coSysParaStr, ",")

O_X = coSysPara(0)         '�����ͼ����
O_Y = coSysPara(1)

O_Stage = coSysPara(2)     '����ʩ������
O_Offset = coSysPara(3)

X_Line_Azimuth_Str = StringToRad(coSysPara(4)) 'ʩ������ϵX�᷽λ��,����

NE2SO_OFF = Round(-(P_N - O_X) * Sin(X_Line_Azimuth_Str) + (P_E - O_Y) * Cos(X_Line_Azimuth_Str) + O_Offset, 3)
End Function


'��ͼ����תʩ������
Function SO2NE_N(CoSysName As String, P_x As Double, P_y As Double) As Double
Dim coSysParaStr As String
Dim coSysPara
Dim O_X As Double, O_Y As Double, O_Stage As Double, O_Offset As Double, X_Line_Azimuth_Str As Double

'��ȡ����ϵ����
coSysParaStr = CoSysFndPara(CoSysName)
coSysPara = Split(coSysParaStr, ",")

O_X = coSysPara(0)         '�����ͼ����
O_Y = coSysPara(1)

O_Stage = coSysPara(2)     '����ʩ������
O_Offset = coSysPara(3)

X_Line_Azimuth_Str = StringToRad(coSysPara(4)) 'ʩ������ϵX�᷽λ��,����

SO2NE_N = Round(O_X + (P_x - O_Stage) * Cos(X_Line_Azimuth_Str) - (P_y - O_Offset) * Sin(X_Line_Azimuth_Str), 3)
End Function

'��ͼ����תʩ������
Function SO2NE_E(CoSysName As String, P_x As Double, P_y As Double) As Double
Dim coSysParaStr As String
Dim coSysPara
Dim O_X As Double, O_Y As Double, O_Stage As Double, O_Offset As Double, X_Line_Azimuth_Str As Double

'��ȡ����ϵ����
coSysParaStr = CoSysFndPara(CoSysName)
coSysPara = Split(coSysParaStr, ",")

O_X = coSysPara(0)         '�����ͼ����
O_Y = coSysPara(1)

O_Stage = coSysPara(2)     '����ʩ������
O_Offset = coSysPara(3)

X_Line_Azimuth_Str = StringToRad(coSysPara(4)) 'ʩ������ϵX�᷽λ��,����

SO2NE_E = Round(O_Y + (P_x - O_Stage) * Sin(X_Line_Azimuth_Str) + (P_y - O_Offset) * Cos(X_Line_Azimuth_Str), 3)
End Function

