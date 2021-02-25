# 0) Packages
library(RSelenium)
library(magrittr)
library(rstudioapi)
library(rvest)
library(purrr)
library(usethis)
source('R/00_utils.R')

# 1) Build Links
primary_links <- map_chr(c(1:788), function(x){
  paste0('https://concordia.itamaraty.gov.br/pesquisa?TipoAcordo=BL&page=',x,'&tipoPesquisa=2')
})

# 2) Start Selenium WebDriver

terminalExecute('docker run --name r_selenium -d -p 4445:4444  selenium/standalone-chrome')

## Create Selenium Driver
remDr <- remoteDriver(
  remoteServerAddr = 'localhost',
  port = 4445L,
  browserName = "chrome"
)

## Open Headless browser
remDr$open(silent = FALSE)


# 3) Collect urls


url_acordos <- imap(primary_links, function(x, .y){
  ## Status
  ui_info(paste0('Progress: ', .y, ' of ',length(primary_links)))

  ## Navigate to search page
  remDr$navigate(x)

  ## Loading page
  wait_load(using = 'css selector',value = '.titulo-acordo')

  ## Get urls
  remDr$getPageSource()[[1]] %>%
    read_html(.) %>%
    html_nodes('.titulo-acordo') %>%
    html_attr('href') %>%
    paste0('https://concordia.itamaraty.gov.br',.)

}) %>%
  flatten_chr()


# 4) Save results
save(url_acordos, file = here::here('raw_data/url_acordos.RData'))

# 5) End

## Closing Selenium driver
remDr$close()

## Stoping and removing docker container
rstudioapi::terminalExecute('docker stop r_selenium')
rstudioapi::terminalExecute('docker container rm r_selenium')


