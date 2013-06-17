\name{htmlSupp}
\alias{htmlSupp}
\title{List HTML supplements  }
\description{ List supplements in HTML documents from PMC articles not in Open Access 
}
\usage{
htmlSupp(doc)
}
\arguments{
  \item{doc}{ HTML file from PMC  }
}
\details{ Links to supplements are either listed on a new page or within the HTML document
}
\value{ A list with file names and caption
}
% \references{ }
\author{ Chris Stubben }
%\note{ }

%\seealso{ }
\examples{

\dontrun{
id <- "PMC3257920" 
doc<- pmc(id)   
htmlSupp(doc)
}

}
\keyword{ methods }
