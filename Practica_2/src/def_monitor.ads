
with Ada.Strings.Unbounded;            use Ada.Strings.Unbounded;

package def_monitor is   
   
    N_TAULES : constant Natural := 3;
    N_SALONS : constant Natural := 3;
      
    type Tipus_Salo is (FUMADOR,NO_FUMADOR,CAP);
   
    type Array_Salons is array (1..N_SALONS) of Natural;
   
    type Array_Tipus is array (1..N_SALONS) of Tipus_Salo;
      
   
   protected type Maitre is
      
      procedure Inicializar_Maitre;
  
      entry Entrar_Salo(Tipus_Salo)(Nom: in Unbounded_String; Salo: out Natural);
      
      procedure Sortir_Salo(Nom: in Unbounded_String; Salo: in Natural);
      
      function Hi_Ha_LLoc(Tipus_Client: in Tipus_Salo) return Natural;
     
   private
      
      Salons_Array : Array_Salons;
      
      Tipus_Array : Array_Tipus;

   end Maitre;

end def_monitor;
