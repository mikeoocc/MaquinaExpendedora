
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity m_expV2 is

    port(
        coin_in : in std_logic_vector(1 downto 0);
        rst, clk, reponedor : in std_logic;
        coin_out : out std_logic_vector(2 downto 0);
        lata : out std_logic
    );

end m_expV2;

architecture Behavioral of m_expV2 is

type state_type is (S0, S1);
signal state, nxstate : state_type;
signal inventario : integer range 0 to 3 := 3;
signal empty : std_logic := '0';
signal aux : integer := 0;

begin

    process(clk, rst) begin
        if(rising_edge(clk)) then
            aux <= aux + 1;
            if(rst = '1') then
                state <= S0;
            else
                state <= nxstate;
            end if;
         end if;
    end process;
    
    process(state, coin_in, reponedor, aux) begin
        
        coin_out <= "000";
        lata <= '0';
        
        case state is 
        
            when S0 =>
				
				if(reponedor = '1') then
        
                    inventario <= 3;
                    empty <= '0';
                
				elsif empty = '1' or inventario = 0 then
				    
				    if(coin_in = "10") then
				        coin_out <= "100";
				    
				    elsif coin_in = "11" then
				        coin_out <= "101";
				    
				    elsif coin_in = "01" then
				    
				        coin_out <= "001";
				    
				    else
				    
				        coin_out <= "000";
				        
				    end if;
				    
				    nxstate <= S0;
				
                else
                
                    case coin_in is
                    
                        when "01" =>
                            nxstate <= S1;
                            
                        when "10" =>
                            lata <= '1';
                            inventario <= inventario - 1;
                    
                            if inventario = 0 then --No quedan latas
					           empty <= '1';
					        end if;
					        
					        nxstate <= S0;
                        
                        when "11" =>
                        
                            lata <= '1'; 
                            coin_out <= "010";
                            inventario <= inventario - 1;
                    
                            if inventario = 0 then --No quedan latas
					           empty <= '1';
			                end if;
			        
                            nxstate <= S0;
                        
                        when "00" =>
                        
                            nxstate <= S0;
                            
                        when others =>
                        
                            nxstate <= S0;
                        
                    end case;
                    
                end if;

            when S1 =>
            
                if (rst = '1') then -- Devuelve 1$ si se pulsa reset (la persona al final no quiere comprar la lata).
                    coin_out <= "001";
                    nxstate <= S0;
                    
                elsif coin_in = "01" then 
                    lata <= '1';
					inventario <= inventario - 1;
					
					if inventario = 0 then --No quedan latas
					   empty <= '1';
			        end if;
			        
                    nxstate <= S0; 
                
                elsif coin_in = "10" then 
                    lata <= '1';
                    coin_out <= "001";
					inventario <= inventario - 1;
					
					if inventario = 0 then --No quedan latas
					   empty <= '1';
			        end if;
					
                    nxstate <= S0; 
                
                elsif coin_in = "11" then 
                    lata <= '1'; 
                    coin_out <= "011";
					inventario <= inventario - 1;
					
					if inventario = 0 then --No quedan latas
					   empty <= '1';
			        end if;
					
                    nxstate <= S0; 
                    
                elsif coin_in = "00" then -- En el caso de que no se meta nada, te quedas en S1 esperando otra moneda
                    nxstate <= S1;
                    
                end if;
        
        end case;  
    end process;
end Behavioral;
