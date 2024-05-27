library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity m_expendedora is

    port(
        coin_in : in std_logic_vector(1 downto 0);
        rst, clk : in std_logic;
        coin_out : out std_logic_vector(1 downto 0);
        lata: out std_logic
    );

end m_expendedora;

architecture Behavioral of m_expendedora is

type state_type is (S0, S1);
signal state, nxstate : state_type;

begin

    process(clk, rst) begin
        if(rising_edge(clk)) then
            if(rst = '1') then
                state <= S0;
            else
                state <= nxstate;
            end if;
         end if;
    end process;
    
    process(state, coin_in) begin
      
        case state is 
        
            when S0 =>
            
                coin_out <= "00";
                lata <= '0';
                
                if(coin_in = "01") then 
                    nxstate <= S1; 
                
                elsif coin_in = "10" then 
                    lata <= '1';
                    nxstate <= S0; 
                
                elsif coin_in = "11" then
                    lata <= '1'; 
                    coin_out <= "10";
                    nxstate <= S0; 
                
                elsif coin_in = "00" then 
                    nxstate <= S0;
                    
                end if;
                  
            when S1 =>
            
                if (rst = '1') then -- Devuelve 1$ si se pulsa reset (la persona al final no quiere comprar la lata).
                    coin_out <= "01";
                    nxstate <= S0;
                    
                elsif(coin_in = "01") then 
                    lata <= '1';
                    nxstate <= S0; 
                
                elsif coin_in = "10" then 
                    lata <= '1'; 
                    coin_out <= "01";
                    nxstate <= S0; 
                
                elsif coin_in = "11" then 
                    lata <= '1'; 
                    coin_out <= "11";
                    nxstate <= S0; 
                    
                elsif coin_in = "00" then -- En el caso de que no se meta nada, te quedas en S1 esperando otra moneda
                    nxstate <= S1;
                    
                end if;
        
        end case;
        
    end process;
    
end Behavioral;
