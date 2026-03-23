\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{style}[2026/03/23 Avans-inspired research paper class]

\LoadClass[12pt,a4paper]{article}

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[margin=1in]{geometry}
\RequirePackage{xcolor}
\RequirePackage{microtype}
\RequirePackage{setspace}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{hyperref}
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\RequirePackage{caption}

% Avans-inspired colors derived from publicly visible site style cues.
\definecolor{AvansBlue}{HTML}{004E89}
\definecolor{AvansTeal}{HTML}{009B9A}
\definecolor{AvansInk}{HTML}{1B2A41}
\definecolor{AvansGrey}{HTML}{F3F6F8}

\hypersetup{
	colorlinks=true,
	linkcolor=AvansBlue,
	citecolor=AvansTeal,
	urlcolor=AvansBlue
}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.75em}
\setstretch{1.15}

\titleformat{\section}
	{\Large\bfseries\color{AvansBlue}}
	{\thesection}
	{0.6em}
	{}
	[\vspace{0.2em}\color{AvansTeal}\titlerule]

\titleformat{\subsection}
	{\large\bfseries\color{AvansInk}}
	{\thesubsection}
	{0.6em}
	{}

\titlespacing*{\section}{0pt}{1.2em}{0.6em}
\titlespacing*{\subsection}{0pt}{0.9em}{0.4em}

\setlist[itemize]{topsep=0.3em,itemsep=0.2em}
\setlist[enumerate]{topsep=0.3em,itemsep=0.2em}

\captionsetup{
	labelfont={bf,color=AvansBlue},
	textfont={small}
}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\headrule}{\hbox to\headwidth{\color{AvansTeal}\leaders\hrule height \headrulewidth\hfill}}
\fancyhead[L]{\small\color{AvansInk}Avans University of Applied Sciences}
\fancyhead[R]{\small\color{AvansInk}Research Paper}
\fancyfoot[C]{\small\color{AvansInk}\thepage\ of \pageref{LastPage}}

\AtBeginDocument{\color{AvansInk}}
