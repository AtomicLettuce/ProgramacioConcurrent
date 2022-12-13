with Text_Io;                        use Text_Io;
with def_monitor;                    use def_monitor;
with Ada.Numerics.Float_Random;      use Ada.Numerics.Float_Random;
with Ada.Strings.Unbounded;          use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;  use Ada.Strings.Unbounded.Text_IO;


procedure Main is

    -- Nombre de persones.
   THREADS : constant integer := 14;

   -- Fitxer on es guarda els noms dels clients.
   Fitxer_Personatges : constant String := "personatges.txt";

   Fitxer   : File_Type;

    -- Monitor.
   Monitor : Maitre;

   -- Array per guardar els noms dels clients
   type Noms_Clients is array(1..THREADS) of Unbounded_String;
   Noms : Noms_Clients;


   Tipus_Client : Tipus_Salo;


   -- Variable generator de la llibreria  Ada.Numerics.Float_Random
   -- per generar decimals aleatoris entre 0.0 i 1.0
   Generador   : Generator;

   Float_Random : Float;


   -- Especificacio de la tasca client.
   task type Client is
    entry Start (Nom_Client : in Unbounded_String; Tipus_Client : in Tipus_Salo);
   end Client;

   -- Cos de la tasca client.
   task body Client is

      -- Un client será representat per.
      Nom:   Unbounded_String;
      Tipus: Tipus_Salo;
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

         -- Assignam el nom i el tipus .
         Nom   := Nom_Client;
         Tipus := Tipus_Client;

      end Start;


      if(Tipus= FUMADOR)then
         Put_Line("BON DIA sóm en " & Nom & " i sóm fumador");
      else
         Put_Line("     BON DIA sóm en " & Nom & " i sóm no fumador");
      end if;


      Monitor.Entrar_Salo(Tipus)(Nom,Salo);
      Dinar;
      Monitor.Sortir_Salo(Nom,Salo);


      if(Tipus= FUMADOR)then
            Put_Line("En " & Nom & " SE'N VA");
      else
            Put_Line("     En " & Nom & " SEN'VA");
      end if;

   end Client;


   -- Array de tasques.
   type Array_Clients is array (1..THREADS) of Client;

   Clients_Array : Array_Clients;


begin

   -- Inicialitzam el generador de decimals aleatoris.
   Reset(generador);

   Monitor.Inicializar_Maitre;

   Open(Fitxer, In_File, Fitxer_Personatges);

   for I in 1..THREADS loop
      Noms(I) := To_Unbounded_String(Get_Line(Fitxer));
   end loop;

   Close(Fitxer);


   -- Feim el start de les tasques.
   for Idx in 1..THREADS loop

      float_Random := Random(Generador);

      if (float_Random > 0.5) then

         Tipus_Client:= Fumador;

      else

         Tipus_Client:= no_Fumador;

      end if;

      Clients_Array(Idx).Start(Noms(Idx), Tipus_Client);

      delay Duration(Float_Random);

   end loop;

end Main;
