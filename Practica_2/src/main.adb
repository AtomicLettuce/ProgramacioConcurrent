with Text_Io;                        use Text_Io;
with def_monitor;                    use def_monitor;
with Ada.Numerics.Float_Random;      use Ada.Numerics.Float_Random;
with Ada.Strings.Unbounded;          use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;  use Ada.Strings.Unbounded.Text_IO;

-- AUTORS:
-- Xavier Vives Marcus
-- Marc Melià Flexas

-- VÍDEO:
-- https://youtu.be/APPWPejGqRc


procedure Main is

   -- Nombre de clients Fumadors.
   FUMADORS: constant integer :=7;

   -- Nombre de clients No Fumadors.
   NO_FUMADORS: constant integer :=7;

   -- Nombre total de clients.
   THREADS : constant integer := FUMADORS+NO_FUMADORS;


   -- Fitxer on es guarda els noms dels clients.
   Fitxer_Personatges : constant String := "personatges.txt";

   Fitxer   : File_Type;


    -- Array per guardar els noms dels clients
   type Noms_Clients is array(1..THREADS) of Unbounded_String;

   Noms : Noms_Clients;


   -- Variable generator de la llibreria  Ada.Numerics.Float_Random
   -- per generar decimals aleatoris entre 0.0 i 1.0
   Generador   : Generator;

   Float_Random : Float;


    -- Monitor.
   Monitor : Maitre;

   -- Especificacio de la tasca client.
   task type Client is
    entry Start (Nom_Client : in Unbounded_String; Tipus_Client : in Tipus_Salo);
   end Client;

   -- Cos de la tasca client.
   task body Client is

      -- Un client serà representat per un nom i el tipus de client.
      Nom:   Unbounded_String;
      Tipus: Tipus_Salo;

      -- La variable saló guarda el saló on està dinant el client.
      Salo:  Natural;

      procedure Dinar is
      begin

         -- Generam el nombre aleatori
         Float_Random := Random(generador);

         if(Tipus = FUMADOR)then
            Put_Line("En "& Nom & " diu: prendré el menú del dia, som al saló" & Salo'Img);
         else
            Put_Line("     En "& Nom & " diu: prendré el menú del dia, som al saló" & Salo'Img);
         end if;

         -- Delay per simular el temps que tarda en dinar.
         delay Duration(Float_Random*10.0);


         if(Tipus = FUMADOR)then
            Put_Line("En "& Nom & " diu: ja he dinat, el compte perfavor ");
         else
            Put_Line("     En "& Nom & " diu: ja he dinat, el compte perfavor ");
         end if;

      end Dinar;


   begin

      accept Start (Nom_Client : in Unbounded_String; Tipus_Client : in Tipus_Salo) do

         -- Assignam el nom i el tipus.
         Nom   := Nom_Client;
         Tipus := Tipus_Client;

      end Start;

      -- Delay aleatori per evitar que els clients arribin alhora al restaurant.
      float_Random := Random(Generador);
      delay Duration(Float_Random*2.0);


      if(Tipus= FUMADOR)then
         Put_Line("BON DIA sóm en " & Nom & " i sóm fumador");
      else
         Put_Line("     BON DIA sóm en " & Nom & " i sóm no fumador");
      end if;


      -- Un client realitzarà tres accions, entrar en el saló, dinar i sortir.
      Monitor.Entrar_Salo(Tipus)(Nom,Salo);
      Dinar;
      Monitor.Sortir_Salo(Nom,Salo);


      if(Tipus= FUMADOR)then
            Put_Line("En " & Nom & " SE'N VA");
      else
            Put_Line("     En " & Nom & " SEN'VA");
      end if;

   end Client;


   -- Array de tasques de clients fumadors.
   type Array_Fumadors is array (1..FUMADORS) of Client;

   -- Array de tasques de clients no fumadors.
   type Array_No_Fumadors is array (1..NO_FUMADORS) of Client;

   Fumadors_Array : Array_Fumadors;

   No_Fumadors_Array : Array_No_Fumadors;

begin

   -- Inicialitzam el generador de decimals aleatoris.
   Reset(generador);

   -- Inicialitzam el monitor.
   Monitor.Inicializar_Maitre;

   -- Obtenim els noms del fitxer de noms i els guardam a l'array de noms.
   Open(Fitxer, In_File, Fitxer_Personatges);

   for I in 1..THREADS loop
      Noms(I) := To_Unbounded_String(Get_Line(Fitxer));
   end loop;

   Close(Fitxer);

     -- Feim el start dels no fumadors.
   for Idx in 1..FUMADORS loop

     Fumadors_Array(Idx).Start(Noms(Idx), Fumador);

   end loop;

   -- Feim el start dels no fumadors.
   for Idx in 1..NO_FUMADORS loop

      No_Fumadors_Array(Idx).Start(Noms(Idx+FUMADORS), no_Fumador);

   end loop;


end Main;
