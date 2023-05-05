ReplaceSymbol <- function(symbol) {
  switch(symbol,
         "y" = "\\\\ding{51}",
         "n" = "\\\\ding{55}",
  )
}

createLaTeXTable <- function(dataframe) {
  # kbl_fn_footnote_as_chunk = TRUE
  # kbl_fn_threeparttable = TRUE
  # kbl_fn_general_title = ""
  #
  # sPropsKblCaption <- "Obtained Static Node Properties"
  #
  # sPropsKbl <- kbl(sPropsMutated, "latex", escape = FALSE, caption = sPropsKblCaption, booktabs = TRUE) %>%
  #   kable_styling(latex_options = "scale_down") %>%
  #   footnote(., general = c("C: Cloud, F: Fog, E: Edge, G: Gateway, CPU: Central Processing Unit, Mem: Memory, Disk: Storage, Net: Network"), general_title = kbl_fn_general_title, footnote_as_chunk = kbl_fn_footnote_as_chunk, threeparttable = kbl_fn_threeparttable)

  # save_kable(sPropsKbl, "latex/nodes-static-properties.tex")
}