




shinyUI(navbarPage("JAGS4TDM - by Oliver Scherf-Clavel (c) 2019 - JMU Wuerzburg",
  
  tabPanel("Main",
           htmlOutput("info"),br(),hr(),
           sidebarLayout(
        sidebarPanel(
           checkboxInput ("choose_SS", "Steady state?", value = F),
           
           h6("Use an Excel File with similar structure (see Table)"),
           fileInput("loadPT", "Load data", multiple = FALSE, 
                     accept = c(".xlsx", ".xls"),                                     
                     width = NULL,buttonLabel = "Browse...", 
                     placeholder = "No file selected"),

           selectInput("choose_PK_mod", "PK Model", selected=3, list("Generic 1 compartment"=1, 
                                                                     "Generic 2 compartments"=2, 
                                                                     "Axitinib Final model, fed"=3,
                                                                     "Axitinib Final model, fasted"=4,
                                                                     "Axitinib Final model, fed, XLI"=5)),
           conditionalPanel(condition="input.choose_PK_mod<=2",
               numericInput("ka", "Absorption rate constant(Ka) [1/h]", value = 0.530),
               numericInput("V", "Central Volume (V) [L]", value = 46.6),
               numericInput("Cl", "Clearance (Cl) [L/h]", value =17.1),
               numericInput("F_oral", "Systemically available fraction (F)", value = 0.469)
            ),
           conditionalPanel(condition="input.choose_PK_mod==2",
               numericInput("V2", "Peripheral Volume (V2) [L]", value = 44.7),
               numericInput("Q", "Intercompartmental Clearance (Q) [L/h]", value = 1.73)
           ),
           conditionalPanel(condition="input.choose_PK_mod>2",
                            numericInput("WT", "Patient weight (WT) [kg]", value = 75)
           ),
           conditionalPanel(condition="input.choose_PK_mod<=2",
                 numericInput("tlag", "Lagtime [h]", value = 0.457),
                 numericInput("omega1", "Variance of ETA1 (ka)", value = 0.476),
                 numericInput("omega2", "Variance of ETA2 (V)", value = 0.140),
                 numericInput("omega3", "Variance of ETA3 (Cl)", value = 0.270),
                 numericInput("omega4", "Variance of ETA4 (F)", value = 0.00001)
            ),
           conditionalPanel(condition="input.choose_PK_mod==2",
                            numericInput("omega5", "Variance of ETA5 (V2)", value = 1.06),
                            numericInput("omega6", "Variance of ETA6 (Q)", value = 0.38)
           ),
           numericInput("sigma", "Assay variance (mg/L)²", value=0.00005),
           sliderInput("TIME", "Time to simulate", value = c(0,48), min=0,max=240),
           sliderInput("n.mc",
                       "Number of MC Simulations:",
                       min = 500,
                       max = 5000,
                       value = 1000),
           sliderInput("mcmc_n.iter",
                       "Iterations per chain:",
                       min = 500,
                       max = 5000,
                       value = 1000),
           sliderInput("mcmc_n.burn",
                       "Burn-in iterations per chain:",
                       min = 0,
                       max = 500,
                       value = 200),
           wellPanel("Display Options",
                     checkboxInput("log_y", "Logarithmic scale on y-axis?", value=F)
                     ),
           actionButton("submit", label = "Apply Changes", icon = NULL, width = NULL)
        ),
        
        
        
        
        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("pkPlot", height = 800),

            wellPanel("Dataset used in the computation",
              tableOutput("data_set")
            )
         )
      )
  ),
  tabPanel("MCMC plots",
           selectInput("select_chain", "MCMC Chain:", choices = c(1,2,3,4)),br(),
           wellPanel("Trace plot of MCMC",br(),
              
              plotOutput("traceplot", height = 600)
              ),
           wellPanel("Correlation between random effects",br(),
                     plotOutput("cov_plot", height = 600)
           )### TODO: More diagnostic plots
  ),
  tabPanel("MC plots",
 
           wellPanel("Correlation between random effects",br(),
                     plotOutput("pop_cov_plot", height = 600)
           )### TODO: More diagnostic plots
  ),
  tabPanel("Parameter distributions",
           
          plotOutput("par_dist", height = 600)

  ),
  tabPanel("Model File",
           verbatimTextOutput("modelfile"))
        )
)
