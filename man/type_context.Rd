% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/type_context.R
\name{type_context}
\alias{type_context}
\title{Retrieve context of base substitution types}
\usage{
type_context(vcf, ref_genome)
}
\arguments{
\item{vcf}{A CollapsedVCF object}

\item{ref_genome}{Reference genome}
}
\value{
Mutation types and context character vectors in a named list
}
\description{
A function to extract the bases 3' upstream and 5' downstream of the base
substitution types.
}
\examples{
## See the 'read_vcfs_as_granges()' example for how we obtained the
## following data:
vcfs <- readRDS(system.file("states/read_vcfs_as_granges_output.rds",
                package="MutationalPatterns"))

## Exclude mitochondrial and allosomal chromosomes.
autosomal <- extractSeqlevelsByGroup(species="Homo_sapiens",
                                    style="UCSC",
                                    group="auto")

vcfs <- lapply(vcfs, function(x) keepSeqlevels(x, autosomal))

## Load the corresponding reference genome.
ref_genome <- "BSgenome.Hsapiens.UCSC.hg19"
library(ref_genome, character.only = TRUE)

type_context <- type_context(vcfs[[1]], ref_genome)

}
\seealso{
\code{\link{read_vcfs_as_granges}},
\code{\link{mutation_context}}
}

