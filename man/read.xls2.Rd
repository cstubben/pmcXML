\name{read.xls2}
\alias{read.xls2}

\title{ Read Excel files }
\description{ Read Microsoft Excel supplements into a data frame  }

\usage{
read.xls2(file, sheet = 1, skip = 0, ...)
}

\arguments{
  \item{file}{ path to file }
  \item{sheet}{ number of sheet }
  \item{skip}{ rows to skip }
  \item{\dots}{ other options passed to \code{\link{guessTable}} }
}
\details{  Reads an Excel file using \code{read.xls} from the \code{gdata} package and then uses \code{\link{guessTable}} to reformat.   Some extra code was added to the perl function \code{xls2csv.pl} within gdata to add carets before superscripts (see note). This change should be included in future version of \code{pubmed} }
\value{ A data frame
}

% \references{ }
\author{ Chris Stubben}
% \note{ }
%\seealso{ }
% \examples{ }
\keyword{ methods }

