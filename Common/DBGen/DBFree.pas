unit DBFree;

// -----------------------------------------------------------------------------
INTERFACE
// -----------------------------------------------------------------------------

Procedure GenerateFreeFiles( SysName : String );

// -----------------------------------------------------------------------------
IMPLEMENTATION Uses DBMisc, ReadF, SysUtils, DBObj, Classes;
// -----------------------------------------------------------------------------

Procedure GenerateFreeFiles( SysName : String );

// -----------------------------------------------------------------------------

Function MakeName ( S : String ): String;
Var O : String; i : Integer;
Begin
   O:=S;
   For i:=1 to Length( O ) do if not ( O[i] in ['a'..'z','0'..'9','_','A'..'Z'] ) then O[i]:='_';
   MakeName:=O;
end;

// -----------------------------------------------------------------------------

CONST
   Q = '''';
   Sp3  = '   ';
   Sp6  = '      ';
   Sp9  = '         ';
   sp12 = '            ';

Var
   FreeFile       : Text;
   Name           : String[60];
   Prefix         : String[2];
   FreeFileName   : String;
   LineType       : String[10];
   FieldCode      : String[10];
   FieldType      : TFieldType;
   FieldName      : String[60];
   B1,B2          : Byte;

   Procedure WriteLine( AMargin : Integer; ALine : String );
   Const
      CR : String = #$0D;
   Var
      SL : TStringList;
      i  : Integer;
   Begin
      DBObj.ReplaceCodes( ALine, '%NAME%', Prefix + FieldName );
      DBObj.ReplaceCodes( ALine, '%TOKEN%', 'tk' + Prefix + FieldName );
      DBObj.ReplaceCodes( ALine, '%B1%', IntToStr( B1 ) );
      DBObj.ReplaceCodes( ALine, '%B2%', IntToStr( B2 ) );
      SL := TStringList.Create;

      i := Pos( CR, ALine );
      While i > 0 do
      Begin
         SL.Add( Copy( ALine, 1, i-1 ) );
         ALine := Copy( ALine, i+1, Length( ALine ) );
         i := Pos( CR, ALine );
      end;
      SL.Add( ALine );

      For i := 0 to Pred( SL.Count ) do
      Begin
         Writeln( FreeFile, '':AMargin, SL[ i ] );
      end;
      FreeAndNil( SL );
   end;


   Function WS( S : String ): String;
   Begin
      WS := '';
      If Length( S )<32 then WS := ConstStr( ' ', 32-Length( S ) );
   end;

Begin
   If not OpenImportFile( SysName+'.TXT' ) then Halt( 1 );
   While not EndOfImportFile do
   Begin
      ReadLine;
      If NoOfFields > 0 then
      Begin
         LineType := GetAField( 1 );
         If LineType='N' then
         Begin
            If NoOfFields<4 then
            Begin
               Writeln( 'Error: Too Few Fields on line ', LineNumber );
               Halt;
            end;
            Name     := MakeName( GetAField( 2 ) );
            Prefix   := GetAField( 3 );

            FreeFileName     := UpperCase( Prefix )+'.F';
            Assign( FreeFile, FreeFileName ); Rewrite( FreeFile );
         end
         else
         If ( LineType='F' ) or ( LineType = 'C' ) then
         Begin { Real and Derived Fields }
            FieldName := MakeName( GetAField( 2 ) );
            FieldCode := GetAField( 3 );
            FieldType := DBObj.FindFieldType( FieldCode );

            If FieldType = NIL then
            Begin
               Writeln( 'Unknown Field Type ', FieldCode, ' on line ', LineNumber );
               Halt;
            end;
            B1 := GetBField( 4 );
            B2 := GetBField( 5 );
            If FieldType.fFreeCode <> '' then
               WriteLine( 6, FieldType.fFreeCode );
         end
         else
         If LineType='E' then
         Begin
            Close( FreeFile );
         end;
      end;
   end;
   CloseImportFile;
end;

// -----------------------------------------------------------------------------

end.

