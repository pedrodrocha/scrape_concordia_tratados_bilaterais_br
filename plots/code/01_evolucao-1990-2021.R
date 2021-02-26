load('data/bilaterais_brasil.Rdata')
library(tidyverse)
library(showtext)
library(ggrepel)
library(pdftools)
library(jsonlite)
dat %>%
  mutate(
    data = str_extract(data, '[0-9]{4}')
  ) %>%
  filter(data > 1990) %>%
  group_by(parceiro) %>%
  count() %>%
  arrange(desc(n)) %>%
  head(10) -> top_10
top_10

# Load font
font_add_google(name = 'Montserrat',family = 'montserrat')
showtext_auto()

dat %>%
  mutate(
    data = str_extract(data, '[0-9]{4}') %>% as.numeric()
  ) %>%
  filter(data > 1990)  %>%
  group_by(data) %>%
  count() %>%
  ggplot() +
  geom_step(aes(
    x = data,
    y = n
    ),
    color = '#444444'
  ) +
  scale_x_continuous(breaks = seq(1991,2021,2)) +
  scale_y_continuous(breaks = seq(0,850,100)) +
  theme_minimal() +
  labs(
    x = "Ano",
    y = "Nº de tratados",
    title = "Evolução do número de tratados bilaterais firmados pelo Brasil (1990-2021)",
    caption = "Elaborado por: @pedro_drocha | Fonte: Concordia MRE"
  ) +
  theme(
   panel.grid = element_blank() ,
   axis.text.y = element_text(
     margin = margin(0,0,0,10),
     size = 10,
     color = '#44444496',
     family = 'montserrat'
   ),
   axis.text.x = element_text(
     margin = margin(10,0,0,0),
     size = 10,
     color = '#44444496',
     family = 'montserrat'
   ),
   axis.title.x = element_text(
     margin = margin(10,0,0,20),
     size = 12,
     color = '#444444',
     family = 'montserrat'
   ),
   axis.title.y = element_text(
     margin = margin(0,0,0,0),
     size = 12,
     color = '#444444',
     family = 'montserrat'
   ),
   plot.title = element_text(
     margin = margin(10,0,10,0),
     size = 12,
     color = '#444444',
     family = 'montserrat',
     face = 'bold',hjust = -1
   ),
   plot.caption = element_text(
     hjust = -.15,
     size = 8,
     family = 'montserrat',
     color = '#44444460',
   ),
   plot.margin = margin(10,10,10,10)
) -> plot
plot
# Saving
ggsave(
  plot = plot,
  path = here::here('plots/file'),
  filename = 'plot01.pdf',
  device= cairo_pdf,
  dpi = 300
)
pdf_convert(pdf = here::here('plots/file/plot01.pdf'),
            format = "png", dpi = 400,)
