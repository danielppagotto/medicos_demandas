library(tidyverse); library(microdatasus)


# baixando dados do cnes --------------------------------------------------

cnes <- fetch_datasus(year_start = 2019, year_end = 2019, month_start = 1, 
                      month_end = 2, uf = "GO", information_system = "CNES-PF")


regioes_saude <- read_delim("bases de apoio ao projeto/regioes_saude.csv", 
                            ";", escape_double = FALSE, 
                            col_types = cols(ibge = col_character(), 
                                             regiao = col_character()), trim_ws = TRUE)



cnes_tratado <- cnes %>% 
                  janitor::clean_names() %>% 
                  select(cnes,codufmun,cbo,prof_sus,profnsus,
                         horaoutr,horahosp,hora_amb,competen) %>% 
                  filter(str_detect(cbo, c("^223","^^225"))) %>% 
                  group_by(codufmun,cbo,prof_sus,profnsus,competen) %>% 
                  summarise(hora_outros = (sum(horaoutr))/40,
                            hora_hosp = (sum(horahosp))/40,
                            hora_amb = (sum(hora_amb))/40) %>% 
                  left_join(cbo02, by = c("cbo"="COD")) %>% 
                  janitor::clean_names() %>% 
                  left_join(regioes_saude, by = c("codufmun"="ibge"))
                  
                  

