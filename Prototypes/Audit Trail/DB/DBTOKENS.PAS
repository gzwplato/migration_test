Unit DBTokens;

INTERFACE

Procedure GenerateTokenFiles( SysName : String );

{  -------------------------------------------------------------------  }
IMPLEMENTATION Uses DBMisc, ReadF;
{  -------------------------------------------------------------------  }

Procedure GenerateTokenFiles( SysName : String );

{  -------------------------------------------------------------------  }

Function MakeName ( S : String ): String;
Var O : String; i : Integer;
Begin
   O:=S;
   For i:=1 to Length( O ) do if not ( O[i] in ['a'..'z','0'..'9','_','A'..'Z'] ) then O[i]:='_';         
   MakeName:=O;
end;

{  -------------------------------------------------------------------  }

CONST
   Q = '''';
   Sp3  = '   ';
   Sp6  = '      ';
   Sp9  = '         ';
   sp12 = '            ';

Var
   InFile      : Text;
   TokenFile   : Text;
   Name        : String[60];
   Prefix      : String[2];
   
   TokenFileName     : String;
   TokenNo           : Integer;

   LineType    : String[10];
   FieldType   : String[10];
   FieldName   : String[60];
   B1,B2,i     : Byte;
      
   S : String;

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
            TokenNo  := GetLField( 4 );

            TokenFileName     := UpCaseStr( Prefix )+'.TOK';
            Assign( TokenFile, TokenFileName ); Rewrite( TokenFile );

            Writeln( TokenFile, '' );
            Writeln( TokenFile, '   tkBegin_',Name, WS( 'Begin_'+Name ),'   = ',TokenNo,' ;' ); Inc( TokenNo );
            Writeln( TokenFile, '   tkEnd_',Name, WS( 'End_'+Name ),'   = ',TokenNo, ' ;' ); Inc( TokenNo );
         end
         else
         If LineType='F' then
         Begin { Real Fields }
            FieldName := MakeName( GetAField( 2 ) );
            FieldType := GetAField( 3 );

            Writeln( TokenFile, '   tk',Prefix,FieldName, WS( FieldName ), ' = ',TokenNo,' ;' ); Inc( TokenNo );
         end
         else
         If LineType='E' then
         Begin
            Close( TokenFile );
         end;
      end;
   end;
   CloseImportFile;
end;

end.

