\name{bibformat}
\alias{bibformat}

\title{ Format references }
\description{ Format references in data.frames as single citations  }

\usage{
bibformat(refs, id = FALSE, ...)
}

\arguments{
  \item{refs}{  output from \code{\link{ncbiPMC}} or similar \code{data.frame}  }
  \item{id}{ include Pubmed ID with reference }
  \item{\dots}{ other options passed to \code{\link{strwrap2}}   }
}
% \details{  }
\value{   None.  strwrap2 uses \code{\link{cat}} to output citations.  }
% \references{ }
\author{  Chris Stubben}
% \note{ }
% \seealso{ }
\examples{

id <- "PMC2231364"
x <- ncbiPMC(id)
x
bibformat(x)

}

\keyword{ methods }

