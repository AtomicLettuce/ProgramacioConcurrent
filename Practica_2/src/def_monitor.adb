with Text_Io;                          use  Text_Io;
with Ada.Strings.Unbounded;            use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;    use Ada.Strings.Unbounded.Text_IO;


package body def_monitor is

   protected body Maitre is
        
      procedure Inicializar_Maitre is
         
      begin  
       
         for i in Salons_Array'Range loop

            Salons_Array(i):=N_TAULES;
            
            Tipus_Array(i):=CAP;

         end loop;
         
         Put_Line ("++++++++++ El Maître està preparat");
         
         Put_Line ("++++++++++ Hi ha" & N_SALONS'Img & " salons amb capacitat de" & N_TAULES'Img & " comensals cada un.");
            
      end Inicializar_Maitre;
      
      
      
      function Hi_Ha_Lloc(Tipus_Client: in Tipus_Salo) return Natural is 
        
      begin
         
          for i in Salons_Array'Range loop

            if(Tipus_Array(i)=Tipus_Client OR Tipus_Array(i)=CAP) then
              
               if(Salons_Array(i)>0) then  
              
                  return i;
                    
              end if;
              
           end if;
            
         end loop;
         
          return 0;
         
      end Hi_Ha_Lloc;
      
      
      
      entry Entrar_Salo(for Tipus_Client in Tipus_Salo)(Nom: in Unbounded_String; Salo: out Natural)  when (Hi_Ha_Lloc(Tipus_Client)>0) is
         
      begin
    
         Salo:= Hi_Ha_Lloc(Tipus_Client);
         
         if(Salons_Array(Salo)=N_TAULES) then
                        
            Tipus_Array(Salo):= Tipus_Client;
                     
         end if;        
                   
         Salons_Array(Salo):= Salons_Array(Salo)-1;
         
         if (Tipus_Client = FUMADOR) then  
             Put_Line("---------- En " & Nom & " te lloc a nel saló de fumadors"& Salo'Img &". Disponibilitat:"& Salons_Array(Salo)'Img );
         else
             Put_Line("********** En " & Nom & " te lloc a nel saló de no fumadors"& Salo'Img &" Disponibilitat:"& Salons_Array(Salo)'Img );
         end if;
         
                 
      end Entrar_Salo;
      

    

      procedure Sortir_Salo (Nom: in Unbounded_String; Salo: in Natural) is
         
         Tipus_Client: Tipus_Salo;
         
      begin
         
         Tipus_Client:= Tipus_Array(Salo);
         
         Salons_Array(Salo) := Salons_Array(Salo)+1;
         
         if (Salons_Array(Salo) = N_TAULES) then
            
            Tipus_Array(Salo):= CAP;
            
         end if;
         
         if(Tipus_Client = FUMADOR) then
             Put_Line("---------- En " & Nom & " allibera una taula del saló"& Salo'Img &". Disponibilitat:"& Salons_Array(Salo)'Img &". Tipus: "&  Tipus_Array(Salo)'Img );
         else
             Put_Line("********** En " & Nom & " allibera una taula del saló"& Salo'Img &". Disponibilitat:"& Salons_Array(Salo)'Img &". Tipus: "&  Tipus_Array(Salo)'Img );
         end if;
         
      end Sortir_Salo;
      
      
   end Maitre;
   
end def_monitor;
