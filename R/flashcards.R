library(flashr)

# create_deck(c(), title = "", file = "decks/.html")
create_deck(c("install.packages()", "library()", "toupper()", "plot()"), title = "Introduction", file = "decks/01_introduction.html")
create_deck(c("install.packages()", "library()", "toupper()", "plot()"), title = "Introduction", file = "decks/01_introductionb.html", termsfirst = FALSE)

create_deck(c("Sys.Date()", "getwd()", "setwd()", "<-", "here()"), title = "Coding and workflows", file = "decks/03_coding.html")
create_deck(c("Sys.Date()", "getwd()", "setwd()", "<-", "here()"), title = "Coding and workflows", file = "decks/03_codingb.html", termsfirst = FALSE)

create_deck(c("==", "!=", "%in%", "typeof()", "class()", "str()", "is.numeric()", "as.numeric()", "is.na()", "is.character()", "as.character()", "is.factor()", "as.factor()", "factor()", "as.Date()"), title = "Data types", file = "decks/06_datatypes.html")
create_deck(c("==", "!=", "%in%", "typeof()", "class()", "str()", "is.numeric()", "as.numeric()", "is.na()", "is.character()", "as.character()", "is.factor()", "as.factor()", "factor()", "as.Date()"), title = "Data types", file = "decks/06_datatypesb.html", termsfirst = FALSE)

create_deck(c("c()", "[]", "seq()", ":", "rep()", "length()", "dim()", "nrow()", "ncol()", "colnames()", "head()", "tail()", "list()", "data.frame()", "tibble()"), title = "Data structures", file = "decks/07_datastructures.html")
create_deck(c("c()", "[]", "seq()", ":", "rep()", "length()", "dim()", "nrow()", "ncol()", "colnames()", "head()", "tail()", "list()", "data.frame()", "tibble()"), title = "Data structures", file = "decks/07_datastructuresb.html", termsfirst = FALSE)

create_deck(c("here()", "read.csv()", "write.csv()", "read_csv()", "write_csv()", "read_excel()"), title = "Importing data", file = "decks/08_importing.html")
create_deck(c("here()", "read.csv()", "write.csv()", "read_csv()", "write_csv()", "read_excel()"), title = "Importing data", file = "decks/08_importingb.html", termsfirst = FALSE)

create_deck(c("range()", "min()", "max()", "unique()", "duplicated()", "which()", "summary()", "skim()"), title = "Validating data", file = "decks/09_validating.html")
create_deck(c("range()", "min()", "max()", "unique()", "duplicated()", "which()", "summary()", "skim()"), title = "Validating data", file = "decks/09_validatingb.html", termsfirst = FALSE)

create_deck(c("select()", "everything()", "contains()", "starts_with()", "ends_with()", "relocate()", "rename()", "mutate()", "across()", "rowwise()", "if_else()", "case_when()"), title = "Cleaning columns", file = "decks/10_cleaning_columns.html")
create_deck(c("select()", "everything()", "contains()", "starts_with()", "ends_with()", "relocate()", "rename()", "mutate()", "across()", "rowwise()", "if_else()", "case_when()"), title = "Cleaning columns", file = "decks/10_cleaning_columnsb.html", termsfirst = FALSE)

create_deck(c("filter()", "if_any()", "drop_na()", "arrange()", "desc()", "count()", "n()", "summarize()", "across()",  "group_by()", "ungroup()"), title = "Wrangling rows", file = "decks/13_wrangling_rows.html")
create_deck(c("filter()", "if_any()", "drop_na()", "arrange()", "desc()", "count()", "n()", "summarize()", "across()",  "group_by()", "ungroup()"), title = "Wrangling rows", file = "decks/13_wrangling_rowsb.html", termsfirst = FALSE)

create_deck(c("pivot_longer()", "pivot_wider()", "separate()", "unite()", "complete()", "expand()", "nesting()", "coalesce()"), title = "Tidy data", file = "decks/15_tidy_data.html")
create_deck(c("pivot_longer()", "pivot_wider()", "separate()", "unite()", "complete()", "expand()", "nesting()", "coalesce()"), title = "Tidy data", file = "decks/15_tidy_datab.html", termsfirst = FALSE)

create_deck(c("inner_join()", "left_join()", "right_join()", "full_join()", "semi_join()", "anti_join()", "add_row()", "bind_rows()", "bind_cols()", "join_by()", "intersect()", "setdiff()", "union()", "union_all()"), title = "Merging data", file = "decks/17_merging_data.html")
create_deck(c("inner_join()", "left_join()", "right_join()", "full_join()", "semi_join()", "anti_join()", "add_row()", "bind_rows()", "bind_cols()", "join_by()", "intersect()", "setdiff()", "union()", "union_all()"), title = "Merging data", file = "decks/17_merging_datab.html", termsfirst = FALSE)

create_deck(c("count()", "n()", "n_distinct()", "round()", "format()", "cut()"), title = "Numbers", file = "decks/19_numbers.html")
create_deck(c("count()", "n()", "n_distinct()", "round()", "format()", "cut()"), title = "Numbers", file = "decks/19_numbersb.html", termsfirst = FALSE)

create_deck(c("str_length()", "str_sub()", "str_to_lower()", "str_to_upper()", "str_to_title()", "str_to_sentence()", "str_c()", "str_glue()", "paste()", "paste0()", "str_detect()", "str_subset()", "str_extract()", "str_replace()", "str_replace_all()", "str_split()"), title = "Strings", file = "decks/20_strings.html")
create_deck(c("str_length()", "str_sub()", "str_to_lower()", "str_to_upper()", "str_to_title()", "str_to_sentence()", "str_c()", "str_glue()", "paste()", "paste0()", "str_detect()", "str_subset()", "str_extract()", "str_replace()", "str_replace_all()", "str_split()"), title = "Strings", file = "decks/20_stringsb.html", termsfirst = FALSE)

create_deck(c("levels()", "fct_inorder()", "fct_rev()", "fct_relevel()", "fct_reorder()", "fct_recode()", "fct_collapse()", "fct_lump_n()", "fct_lump_prop()", "fct_lump_min()"), title = "Factors", file = "decks/22_factors.html")
create_deck(c("levels()", "fct_inorder()", "fct_rev()", "fct_relevel()", "fct_reorder()", "fct_recode()", "fct_collapse()", "fct_lump_n()", "fct_lump_prop()", "fct_lump_min()"), title = "Factors", file = "decks/22_factorsb.html", termsfirst = FALSE)

create_deck(c("today()", "now()", "as_date()", "as_datetime()", "mdy()", "dmy()", "ymd()", "hms()", "hm()", "mdy_hm()", "mdy_hms()", "year()", "month()", "day()", "wday()", "hour()", "minute()", "second()"), title = "Dates and times", file = "decks/23_dates.html")
create_deck(c("today()", "now()", "as_date()", "as_datetime()", "mdy()", "dmy()", "ymd()", "hms()", "hm()", "mdy_hm()", "mdy_hms()", "year()", "month()", "day()", "wday()", "hour()", "minute()", "second()"), title = "Dates and times", file = "decks/23_datesb.html", termsfirst = FALSE)

create_deck(c("for()", "map()", "map_dbl()", "map_chr()", "map_df()", "split()", "dir()"), title = "Iteration", file = "decks/25_iteration.html")
create_deck(c("for()", "map()", "map_dbl()", "map_chr()", "map_df()", "split()", "dir()"), title = "Iteration", file = "decks/25_iterationb.html", termsfirst = FALSE)
#
# create_deck(c("", ), title = "", file = "decks/.html")
# create_deck(c("", ), title = "", file = "decks/b.html", termsfirst = FALSE)


