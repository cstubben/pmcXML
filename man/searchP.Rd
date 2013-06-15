\name{searchP}
\alias{searchP}
\title{
}
\description{
}
\usage{
searchP(x, pattern, caption = TRUE, before = FALSE, after = FALSE, ignore.case = TRUE, ...)
}
\arguments{
  \item{x}{
}
  \item{pattern}{
}
  \item{caption}{
}
  \item{before}{
}
  \item{after}{
}
  \item{ignore.case}{
}
  \item{\dots}{
}
}
\details{
}
\value{
}
\references{
}
\author{
}
\note{
}


\seealso{
}
\examples{

function (x, pattern, caption = TRUE, before = FALSE, after = FALSE, 
    ignore.case = TRUE, ...) 
{
    if (class(x) != "list") {
        y <- attr(x, "label")
        if (is.null(y)) 
            y <- "Unknown"
        x <- list(x)
        names(x) <- y
    }
    z <- vector("list", length(x))
    for (i in 1:length(x)) {
        if (class(x[[i]]) == "data.frame") {
            x2 <- collapse2(x[[i]])
            n <- grep(pattern, x2, ignore.case = ignore.case, 
                ...)
            if (length(n) > 0) {
                z[[i]] <- data.frame(section = names(x[i]), citation = x2[n], 
                  stringsAsFactors = FALSE)
                if (caption) 
                  z[[i]]$citation <- paste("Caption=", attr(x[[i]], 
                    "caption"), ";", z[[i]]$citation, sep = "")
            }
        }
        else {
            n <- grep(pattern, x[[i]], ignore.case = ignore.case, 
                ...)
            if (length(n) > 0) {
                z[[i]] <- data.frame(section = names(x[i]), citation = x[[i]][n], 
                  stringsAsFactors = FALSE)
                if (before) 
                  z[[i]]$citation <- ifelse(n == 1, z[[i]]$citation, 
                    paste(x[[i]][n - 1], z[[i]]$citation))
                if (after) 
                  z[[i]]$citation <- ifelse(n == length(x[[i]]), 
                    z[[i]]$citation, paste(z[[i]]$citation, x[[i]][n + 
                      1]))
            }
        }
    }
    do.call("rbind", z)
  }
}
\keyword{ ~kwd1 }
