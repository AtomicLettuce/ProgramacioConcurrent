with Text_Io;                          use  Text_Io;
with Ada.Strings.Unbounded;            use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;    use Ada.Strings.Unbounded.Text_IO;


package body def_monitor is

   protected body Maitre is
        
      -- Procediment per inicialitzar el monitor
      procedure Inicializar_Maitre is
         
      begin  
       
         for i in Salons_Array'Range loop

            -- L'array de disponibilitat dels salons s'inicialitza a la m�xima disponibilitat.
            Salons_Array(i):=N_TAULES;
            
            -- L'array del tipus dels salons s'inicialitza amb els salons buits.
            Tipus_Array(i):=CAP;

         end loop;
         
         Put_Line ("++++++++++ El Ma�tre est� preparat");
         
         Put_Line ("++++++++++ Hi ha" & N_SALONS'Img & " salons amb capacitat de" & N_TAULES'Img & " comensals cada un.");
            
      end Inicializar_Maitre;
      
      
      
      -- Funci� per comprovar si hi ha lloc a un sal�.
      -- Rep el tipus del client.
      -- Retorna el n�mero del sal� disponible pel tipus rebut, si no hi ha lloc retorna 0.
      function Hi_Ha_Lloc(Tipus_Client: in Tipus_Salo) return Natural is 
        
      begin
         
          -- Recorregut dels salons.
          for i in Salons_Array'Range loop

            -- Si hi ha lloc a un sal� del tipus del client o el sal� est� buit.
            if(Tipus_Array(i)=Tipus_Client OR Tipus_Array(i)=CAP) then
              
               if(Salons_Array(i)>0) then  
              
                  return i;
                    
              end if;
              
           end if;
            
         end loop;
         
         return 0;
         
      end Hi_Ha_Lloc;
      

      
      -- Entry per controlar l'entrada dels salons, comprova si hi ha lloc al sal� amb la funci� Hi_Ha_Lloc.
      -- Rep el tipus del client per passar-ho com a par�metre a la funci� i el nom del client.
      -- Retorna el sal� que s'ha assignat al client.
      entry Entrar_Salo(for Tipus_Client in Tipus_Salo)(Nom: in Unbounded_String; Salo: out Natural)  when (Hi_Ha_Lloc(Tipus_Client)>0) is
         
      begin
    
         -- Obtenim el nombre del sal� disponible.
         Salo:= Hi_Ha_Lloc(Tipus_Client);
         
         -- Si el sal� est� buit li assignam el tipus del nou client.
         if(Salons_Array(Salo)=N_TAULES) then
                        
            Tipus_Array(Salo):= Tipus_Client;
                     
         end if;        
                   
         -- Restam la disponibilitat del sal� per indicar que el client ha entrat.
         Salons_Array(Salo):= Salons_Array(Salo)-1;
         
         if (Tipus_Client = FUMADOR) then  
             Put_Line("---------- En " & Nom & " t� lloc a nel sal� de fumadors"& Salo'Img &". Disponibilitat:"& Salons_Array(Salo)'Img );
         else
             Put_Line("********** En " & Nom & " t� lloc a nel sal� de no fumadors"& Salo'Img &". Disponibilitat:"& Salons_Array(Salo)'Img );
         end if;
               
      end Entrar_Salo;
      
    
      
      -- Procediment per sortir del sal�.
      -- Rep el nom del client i el sal� on es troba.
      procedure Sortir_Salo (Nom: in Unbounded_String; Salo: in Natural) is
         
         Tipus_Client: Tipus_Salo;
         
      begin
         
         Tipus_Client:= Tipus_Array(Salo);
         
         -- Sumam la disponibilitat del sal� per indicar que el client ha sortit.
         Salons_Array(Salo) := Salons_Array(Salo)+1;
         
         -- Si el sal� est� buit li assignam el tipus BUIT.
         if (Salons_Array(Salo) = N_TAULES) then
            
            Tipus_Array(Salo):= CAP;
            
         end if;
         
         if(Tipus_Client = FUMADOR) then
             Put_Line("---------- En " & Nom & " allibera una taula del sal�"& Salo'Img &". Disponibilitat:"& Salons_Array(Salo)'Img &". Tipus: "&  Tipus_Array(Salo)'Img );
         else
             Put_Line("********** En " & Nom & " allibera una taula del sal�"& Salo'Img &". Disponibilitat:"& Salons_Array(Salo)'Img &". Tipus: "&  Tipus_Array(Salo)'Img );
         end if;
         
      end Sortir_Salo;
      
 
   end Maitre;
   
end def_monitor;
