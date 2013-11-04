removeSpecChar <- function(y){  
      y <- gsub("â\u0080\u008b\\(?Table[0-9])?.", "", y)

      y <- gsub("â\u0080\u008bFigure[0-9]", "", y)
     y <- gsub("â\u0080\u008b\\(?Fig.[0-9][A-Za-z])?.", "", y)
      y <- gsub("â\u0080\u008b\\(?Fig.[0-9])?.", "", y)

      y <- gsub("\u200B\\(?Table[0-9])?.", "", y)
      y <- gsub("\u200B\\(?Fig.[0-9])?.", "", y)

      y <- gsub("â\u0080\u008b", "", y)


      y <- gsub("â\u0088\u0092", "-", y)
      y <- gsub("â\u0080\u0093", "-", y)

      y <- gsub("â\u0080\u009c", "'", y)
      y <- gsub("â\u0080\u009d", "'", y)

      y <- gsub("â\u0080²", "'", y)
      y <- gsub("Î\u0094", "Δ", y)

      y <- gsub("Î²", "β", y)
      y <- gsub("Î±", "α", y)
      y <- gsub("Â°", "°", y)
      y <- gsub("Î¼", "μ", y)
      y <- gsub("Î»", "λ", y)
     y <- gsub("Ã¼", "ü", y)
     y <- gsub("Ã\u0097", "×", y)

  ## {\"type\":\"entrez-protein\",\"attrs\":{\"text\":\"AAG33249\",\"term_id\":\"11230854\"}}
      y <- gsub("\\{[^}]*\\}\\}" , "", y)
      y
}


