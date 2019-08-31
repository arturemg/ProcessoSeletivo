object frmCad: TfrmCad
  Left = 0
  Top = 0
  Caption = 'frmCad'
  ClientHeight = 446
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 52
    Height = 13
    Caption = 'Identidade'
  end
  object Label3: TLabel
    Left = 135
    Top = 56
    Width = 19
    Height = 13
    Caption = 'CPF'
  end
  object Label4: TLabel
    Left = 262
    Top = 56
    Width = 33
    Height = 13
    Caption = 'Celular'
  end
  object Label5: TLabel
    Left = 8
    Top = 104
    Width = 24
    Height = 13
    Caption = 'Email'
  end
  object edtNome: TEdit
    Left = 8
    Top = 27
    Width = 375
    Height = 21
    TabOrder = 0
  end
  object edId: TEdit
    Left = 8
    Top = 75
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object edCpf: TEdit
    Left = 135
    Top = 75
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edEmail: TEdit
    Left = 8
    Top = 123
    Width = 375
    Height = 21
    TabOrder = 3
  end
  object gbEndereco: TGroupBox
    Left = 8
    Top = 150
    Width = 375
    Height = 259
    Caption = 'Endere'#231'o'
    TabOrder = 4
    object Label6: TLabel
      Left = 16
      Top = 16
      Width = 19
      Height = 13
      Caption = 'Cep'
    end
    object Label7: TLabel
      Left = 16
      Top = 64
      Width = 51
      Height = 13
      Caption = 'Logadouro'
    end
    object Label8: TLabel
      Left = 16
      Top = 112
      Width = 12
      Height = 13
      Caption = 'N'#186
    end
    object Label9: TLabel
      Left = 71
      Top = 112
      Width = 65
      Height = 13
      Caption = 'Complemento'
    end
    object Label10: TLabel
      Left = 16
      Top = 160
      Width = 28
      Height = 13
      Caption = 'Bairro'
    end
    object Label11: TLabel
      Left = 183
      Top = 160
      Width = 33
      Height = 13
      Caption = 'Cidade'
    end
    object Label12: TLabel
      Left = 16
      Top = 208
      Width = 13
      Height = 13
      Caption = 'UF'
    end
    object Label13: TLabel
      Left = 71
      Top = 208
      Width = 19
      Height = 13
      Caption = 'Pais'
    end
    object edCep: TEdit
      Left = 16
      Top = 35
      Width = 121
      Height = 21
      TabOrder = 0
      OnExit = edCepExit
    end
    object edLogad: TEdit
      Left = 16
      Top = 83
      Width = 345
      Height = 21
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 1
    end
    object edNum: TEdit
      Left = 16
      Top = 131
      Width = 49
      Height = 21
      TabOrder = 2
    end
    object edComp: TEdit
      Left = 71
      Top = 131
      Width = 290
      Height = 21
      TabOrder = 3
    end
    object edBairro: TEdit
      Left = 16
      Top = 179
      Width = 161
      Height = 21
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 4
    end
    object edCidade: TEdit
      Left = 183
      Top = 179
      Width = 178
      Height = 21
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 5
    end
    object edUf: TEdit
      Left = 16
      Top = 227
      Width = 31
      Height = 21
      Color = cl3DLight
      MaxLength = 2
      ReadOnly = True
      TabOrder = 6
    end
    object edPais: TEdit
      Left = 71
      Top = 227
      Width = 121
      Height = 21
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 7
    end
  end
  object edTel: TMaskEdit
    Left = 262
    Top = 75
    Width = 119
    Height = 21
    EditMask = '!\(99\)00000-0000;1;_'
    MaxLength = 14
    TabOrder = 5
    Text = '(  )     -    '
  end
  object btEnviar: TButton
    Left = 306
    Top = 415
    Width = 75
    Height = 25
    Caption = 'Enviar'
    TabOrder = 6
    OnClick = btEnviarClick
  end
end
