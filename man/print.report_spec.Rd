% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_spec.R
\name{print.report_spec}
\alias{print.report_spec}
\title{Prints the report spec}
\usage{
\method{print}{report_spec}(x, ..., verbose = FALSE)
}
\arguments{
\item{x}{The report spec.}

\item{...}{Additional parameters to pass to the underlying print function.}

\item{verbose}{Whether to print the report object in verbose (list) form
or summary form.  The default is FALSE.}
}
\value{
The report spec, invisibly.
}
\description{
A function to print the report spec.
The \strong{print} function will print the report spec in summary 
form by default.  To print in list form, set the \code{verbose} parameter
to TRUE.
}
\examples{
# Here is something
}
\seealso{
\code{\link{create_report}} function to create a report specification.

Other report: 
\code{\link{add_content}()},
\code{\link{create_report}()},
\code{\link{footnotes}()},
\code{\link{options_fixed}()},
\code{\link{page_footer}()},
\code{\link{page_header}()},
\code{\link{set_margins}()},
\code{\link{titles}()},
\code{\link{write_report}()}
}
\concept{report}