# Use lualatex via the pdflatex wrapper
$pdflatex = 'lualatex -interaction=nonstopmode -synctex=1 -output-directory=build %O %S';

# Tell latexmk that lualatex produces PDF directly
$pdf_mode = 1;

# Use biber for bibliography
$biber = 'biber --output-directory build %O %S';
$bibtex_use = 2;  # Force biber usage

# Glossary support
add_cus_dep('glo', 'gls', 0, 'makeglossaries_cmd');
add_cus_dep('acn', 'acr', 0, 'makeglossaries_cmd');

sub makeglossaries_cmd {
    my ($base_name, $path) = fileparse($_[0]);

    my $ret = system("makeglossaries -d build \"$base_name\"");

    if ($ret && -e "build/$base_name.aux") {
        print "Retrying makeglossaries with explicit path...\n";
        $ret = system("makeglossaries build/\"$base_name\"");
    }
    return $ret ? 1 : 0;
}

# Store all intermediate/output files in ./build/
$out_dir = 'build';
$aux_dir = 'build'; # This ensures .aux, .glo etc. go to build

# Clean intermediate files
@generated_exts = qw(
  aux bbl bcf blg glg glo gls ilg idx ind
  lof log lot out run.xml toc acr acn alg
  fdb_latexmk fls synctex.gz
  glstex % Add this if you use the TeX-based glossary processing
);

# Root document
$root_doc = 'main.tex';

# Mimic Overleaf experience
$recorder = 1;
$silent = 1;
#$preview_continuous_mode = 1;

# Use the same command as $pdflatex for other calls
$latex = $pdflatex;
