wait_load <- function(using, value) {
  el <- NULL
  while(is.null(el)){
    el <- suppressMessages(tryCatch(
      remDr$findElement(
        using = using, value = value
      ),
      error = function(e) {NULL}
    ))
  }
}

build_data <- function(parsed_url){

  titulo <- parsed_url %>%
    html_node('.sessao-principal+ .label-detalhamento .dados-detalhamento') %>%
    html_text()
  if (titulo == "(dado inexistente)") {titulo <- NA}

  parceiro <- parsed_url %>%
    html_node('.label-detalhamento:nth-child(3) .flex:nth-child(1) .dados-detalhamento') %>%
    html_text()
  if (parceiro == "(dado inexistente)") {parceiro <- NA}

  depositario <- parsed_url %>%
    html_node('.label-detalhamento:nth-child(4) .flex:nth-child(1) .dados-detalhamento') %>%
    html_text()
  if (depositario == "(dado inexistente)") {depositario <- NA}


  loc_celebracao <- parsed_url %>%
    html_node('.label-detalhamento:nth-child(4) .flex:nth-child(2) .dados-detalhamento') %>%
    html_text()
  if (loc_celebracao == "(dado inexistente)") {loc_celebracao <- NA}

  pais_celebracao <- parsed_url %>%
    html_node('.label-detalhamento:nth-child(4) .flex:nth-child(3) .dados-detalhamento') %>%
    html_text()
  if (pais_celebracao == "(dado inexistente)") {pais_celebracao <- NA}

  data <- parsed_url %>%
    html_node('.label-detalhamento:nth-child(5) .flex:nth-child(1) .dados-detalhamento') %>%
    html_text()
  if (data == "(dado inexistente)") {data <- NA}


  temas <- parsed_url %>%
    html_nodes('p.dados-detalhamento') %>%
    html_text() %>%
    str_c(collapse = '; ')
  if (temas == "(dado inexistente)") {temas <- NA}

  status <- parsed_url %>%
    html_node('.label-detalhamento:nth-child(5) .flex:nth-child(2) .dados-detalhamento') %>%
    html_text()
  if (status == "(dado inexistente)") {status <- NA}

  base_vig <- parsed_url %>%
    html_nodes('#vigencia~ .label-detalhamento .flex div .dados-detalhamento') %>%
    html_text()

  n_registro_onu <- base_vig[2]
  if (n_registro_onu == "(dado inexistente)") {n_registro_onu <- NA}

  vigor_int_em <- base_vig[3]
  if (vigor_int_em == "(dado inexistente)") {vigor_int_em <- NA}

  expirou_em <- base_vig[4]
  if (expirou_em == "(dado inexistente)") {expirou_em <- NA}


  pdf_url <- parsed_url %>%
    html_nodes('.pdf-html a') %>%
    html_attr('href')
  pdf_url <- pdf_url[1]


  tibble(
    titulo = titulo,
    parceiro = parceiro,
    depositario = depositario,
    loc_celebracao = loc_celebracao,
    pais_celebracao = pais_celebracao,
    data = data,
    temas = temas,
    status = status,
    n_registro_onu = n_registro_onu,
    vigor_int_em = vigor_int_em,
    expirou_em = expirou_em,
    pdf_url = pdf_url
  )


}
