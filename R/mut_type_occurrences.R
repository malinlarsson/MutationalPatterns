#' Count the occurrences of each base substitution type
#' 
#' @param vcf_list A list of CollapsedVCF object
#' @param ref_genome Reference genome
#' @return data.frame with counts of each base substitution type for
#' each sample in vcf_list
#'
#' @importFrom BiocGenerics rbind
#'
#' @examples
#' ## See the 'read_vcfs_as_granges()' example for how we obtained the
#' ## following data:
#' vcfs <- readRDS(system.file("states/read_vcfs_as_granges_output.rds",
#'                     package="MutationalPatterns"))
#' 
#' ## Exclude mitochondrial and allosomal chromosomes.
#' autosomal <- extractSeqlevelsByGroup(species="Homo_sapiens",
#'                                         style="UCSC",
#'                                         group="auto")
#'
#' vcfs <- lapply(vcfs, function(x) keepSeqlevels(x, autosomal))
#'
#' ## Load a reference genome.
#' ref_genome = "BSgenome.Hsapiens.UCSC.hg19"
#' library(ref_genome, character.only = TRUE)
#'
#' ## Get the type occurrences for all VCF objects.
#' type_occurrences = mut_type_occurrences(vcfs, ref_genome)
#'
#' @seealso
#' \code{\link{read_vcfs_as_granges}},
#'
#' @export

mut_type_occurrences = function(vcf_list, ref_genome)
{  
    n_samples = length(vcf_list)
    df = data.frame()

    CpG = c("ACG", "CCG", "TCG", "GCG")
    column_names = c("C>A", "C>G", "C>T", "T>A", "T>C", "T>G",
                        "C>T at CpG", "C>T other")

    full_table = NULL
    for(i in 1:n_samples)
    {
        vcf = vcf_list[[i]]
        types = mutation_types(vcf)
        CT_muts = which(types == "C>T")
        CT_context = type_context(vcf[CT_muts], ref_genome)[[2]]
        CT_at_CpG = sum(!(is.na(BiocGenerics::match(CT_context,CpG))))
        CT_at_other = length(CT_muts) - CT_at_CpG

        # Construct a table and handle missing mutation types.
        full_table = table(factor(types, levels = column_names))
        full_table["C>T at CpG"] = CT_at_CpG
        full_table["C>T other"] = CT_at_other
        df = BiocGenerics::rbind(df, full_table)
    }

    row.names(df) = names(vcf_list)
    colnames(df) = names(full_table)
    return(df)
}

mut_type_occurences = function (type_context, strand)
{
    .Defunct("mut_type_occurences", package="MutationalPatterns",
            msg=paste("This function has been renamed to",
                        "'mut_type_occurrences'."))
}
