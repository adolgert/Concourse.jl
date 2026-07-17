<!-- Nougat extraction of Carnevali et al. - 2022 - The ORIS tool app, library, and toolkit for quantitative evaluation of non-Markovian systems.pdf -->
<!-- Extraction ID: b028e305-7525-464a-88c7-5e735a83dbae_20251010_025227 -->
<!-- Actual page count: 6 -->
<!-- Successful chunks: 6 -->
<!-- Failed chunks: 0 -->
<!-- Extraction date: 2025-10-10T02:53:17.534361 -->

<!-- Pages 1-1 -->

# The ORIS tool: app, library, and toolkit for

quantitative evaluation of non-Markovian systems

 Laura Carnevali

Information Engineering Dept.

Univ. of Florence

Marco Paolieri

Computer Science Dept.

Univ. of Southern California

Enrico Vicario

Information Engineering Dept.

Univ. of Florence

laura.carnevali@unifi.it paolieri@usc.edu enrico.vicario@unifi.it

###### Abstract

ORIS is a tool for quantitative modeling and evaluation of concurrent systems with non-Markovian durations. It provides a Graphical User Interface (GUI) for model specification as Stochastic Time Petri Nets (STPNs), validation by interactive simulation, and evaluation by several techniques, computing instantaneous and cumulative rewards. It also provides an open-source Java Application Programming Interface (API) to automate the workflow, and it can be used as a toolkit for derivation and evaluation of STPNs in model driven engineering. As distinguishing features, ORIS implements transient and steady-state analysis of STPNs with underlying Markov Regenerative Process (MRP), and transient analysis of STPNs with underlying Generalized Semi-Markov Process (GSMP). It also implements nondeterministic analysis of Time Petri Nets (TPNs), simulation of STPNs, and solution methods for Continuous-Time Markov Chains (CTMCs) and MRPs with at most one non-exponential timer in each state. The well-engineered software architecture of ORIS supports agile implementation of new STPN features, new modeling formalisms, and new analysis methods.

Software tools and libraries, stochastic models, quantitative evaluation, stochastic Petri nets, non-Markovian processes, Markov regenerative processes, model driven engineering.

## 1 Introduction

ORIS [24, 23] enables modeling of stochastic systems with multiple concurrent general (i.e., non-Markovian) timers, with bounded or unbounded support, and quantitative evaluation of their underlying stochastic processes. As shown in Fig. 1, ORIS provides a GUI for specification of STPNs [35], their validation by interactive simulation, and their transient or steady-state analysis by different methods making different assumptions on the underlying stochastic process. ORIS also includes SIRIO [29], an open-source API enabling access to the GUI functions and to additional features for symbolic manipulation of multivariate distributions and generalization of the modeling formalism and the solution techniques.

As characterizing feature, ORIS implements the _method of stochastic state classes_[35, 18], enabling quantitative evaluation of non-Markovian models underlying an MRP [21] (if a new _regeneration_ is always reached with probability 1, i.e., a state satisfying the Markov condition) or a GSMP: _i_) exact transient and steady-state analysis of STPNs with underlying an MRP that always reaches a new regeneration within a bounded number of state transitions (_bounded regeneration restriction_); _ii_) exact transient analysis of STPNs with bounded number of state transitions within the time limit and approximate transient analysis of STPNs, with not restriction on the occurrence of regenerations.

ORIS also offers a basic implementation of transient and steady-state analysis of STPNs with underlying CTMC [30] and transient analysis of STPNs with underlying MRP satisfying the enabling restriction [15] (i.e., at most one general timer enabled in each state), which are the focus of tools like PRISM [22], SHARPE [32], TimeNET [37], and GreatSPN [2]. Moreover, ORIS implements transient and steady-state simulation of STPNs, and nondeterministic analysis of the underlying TPNs [34] based on the enumeration of the _state class graph_, also used in qualitative verification tools like Tina [5], Romeo [12], and Uppaal [3].

ORIS has been used, as a GUI or library, to perform quantitative evaluation of stochastic models in various application domains, e.g., design and testing of real-time software [10, 25], performability evaluation of railway signalling systems [7] and of repair procedures for gas and water distribution net

Figure 1: Use-case diagram of the functionalities provided by the GUI and API of the ORIS tool.

<!-- Pages 2-2 -->

works [8, 11], and human activity recognition for ambient assisted living [9, 6]. The flexible and extensible software architecture enables the agile implementation of new model features and analysis algorithms, and facilitates the integration of the SIRIO library into custom software tools and toolchains, supporting model driven engineering approaches where STPNs are instantiated from domain metamodels and analyzed in automated manner for many parameter values. Moreover, ORIS has been used as a support for teaching quantitative modeling and evaluation of non-Markovian systems in master courses of the University of Florence, e.g., "Quantitative Evaluation of Stochastic Models".

The ORIS tool is freely available at oris-tool.org, and a tutorial is available at oris-tool.org/tutorial. The source code of the SIRIO library is available at github.com/oristool/sirio under the AQPL licence, and a ready-to-use project is available at github.com/oris-tool/sirio-examples.

This paper is a short version of [24]1, where we recall how to build and analyze STPNs (Sections 2 and 3). Then, we discuss how to use ORIS as a toolkit to support model driven engineering from domain metamodels to runtime analysis (Section 4), through an example from the context of smart transportation. Finally, we draw our conclusions (Section 5).

Footnote 1: When referring to ORIS and SIRIO, please cite [24].

## 2 Model Specification

### Stochastic Time Petri Nets (STPNs)

STPNs [35] model concurrent systems with stochastic temporal parameters. As shown in Fig. 2, they consist of: _transitions_ (depicted as vertical bars) modeling activities; _tokens_ within _places_ (depicted as dots inside circles) modeling the system logical state; and _directed arcs_ from _input_ places to transitions and from transitions to _output_ places (depicted as directed arrows), modeling token moves at the execution of activities. A _marking_ assigns a natural number of tokens to each place. A transition is enabled if all its input places contain at least one token; upon firing, it removes one token from each input place and adds one to each output place.

A transition \(t\) is termed immediate (IMM) or deterministic (DET) if its time to fire \(\tau\) is zero or a positive value, respectively. Otherwise, \(t\) is termed exponential (EXP) or general (GEN) if \(\tau\) is a continuous random variable with EXP or GEN Probability Density Function (PDF), respectively.

As stochastic reward nets [31] and stochastic activity networks [28], STPNs support _enabling functions_ restricting the enabling of a transition through constraints on token counts. STPNs also support _update functions_ specifying additional updates of token counts after a firing, _reset sets_ forcing the restart of selected transitions, and _priorities_ imposed among IMM or DET transitions. If omitted, default feature values are an always-true enabling function, an identity update function, an empty reset set, weight 1, and priority 0.

Arc cardinalities larger than 1 could be easily introduced by letting the firing of a transition remove an arbitrary number of tokens from each input place or add an arbitrary number of tokens to each output place. Though supported by SIRIO, arc cardinalities were not included in the ORIS GUI to reduce model clutter, in contrast with explicit features provided by other tools [37]; instead, arc cardinalities can be modeled in ORIS through enabling and update functions.

### Structure of concurrency

We recall the model specification workflow using the example of _software rejuvenation_[33, 27, 13, 20] of Fig. 2, where a software system inspired by [14] is restarted periodically to prevent failures due to _software aging_ and reduce unavailability intervals. First, feasible behaviours are identified by the concurrency structure and qualitative timing constraints. Specifically, the basic structure of concurrency is represented by the underlying Petri Net (PN) (i.e., places, transitions, enabling and update functions, priorities), capturing the concurrency between the aging process of the software system (transitions fail, detect, and repair model the time required by software aging, failure detection, and unplanned repair, respectively) and the rejuvenation mechanism (transitions clock and rejuvenate model the time between two consecutive rejuvenations and the rejuvenation time, respectively). Update functions model the interactions between the software system and the rejuvenation mechanism: the update function of transition clock flushes places Up, Down, and Detected to represent system switch-off during rejuvenation; the update function of transition rejuvenate assigns a token to place Up to model system restart after rejuvenation; the update function of transition detect flushes place Wait to account for disabling of rejuvenation during unplanned repair; and, the update function of transition repair adds a token to place Wait to model reschedule of rejuvenation.

Firm timing constraints and reset sets further restrict possible behaviors by extending the PN into a TPN [4], determining the set of timed firing sequences, i.e., sequences of transition firings, associated with the time between each pair of consecutive firings. In Fig. 2, we assume that the system specification requires the failure detection time to be lower than \(4\,\mathrm{h}\), the repair time to be between \(4\) and \(24\,\mathrm{h}\), the rejuvenation time to be lower than \(2\,\mathrm{h}\), and the rejuvenation period to be \(168\,\mathrm{h}\) (\(7\) days). Thus, detect, repair and rejuvenate have support \([0,4]\)\(\mathrm{h}\), \([4,24]\)\(\mathrm{h}\), and \([0,2]\)\(\mathrm{h}\), respectively, while clock has a deterministic value of \(168\,\mathrm{h}\). Conversely, we assume that the failure time is unbounded, thus fail has support \([0,\infty)\)\(\mathrm{h}\). The initial marking is UpWait, i.e., system up and rejuvenation timer just started.

Figure 2: ORIS GUI: STPN model of software rejuvenation. IMM, DET, EXP, GEN transitions are represented by thin black bars, thick gray bars, thick white bars, black thick bars, respectively, labeled with e, u, r if having non-default value of enabling function, update function, reset set, respectively.

<!-- Pages 3-3 -->

### Stochastic parameters

Feasible behaviours are associated with a measure of probability by setting distributions and weights of transitions, identifying an STPN that casts the timed firing sequences of the underlying TPN into a probability space [25]. ORIS supports _expolynomial_ PDFs [32], i.e., products of exponentials and polynomials, on bounded or unbounded supports, with analytical representation over its domain or piecewise-defined over multiple sub-domains, with EBNF syntax:

\[\textsc{expr} :=\textsc{prod}\ \{\ +\textsc{prod}\ \}\] \[\textsc{prod} :=\textsc{float}\ \{\ *\textsc{term}\ \}\] \[\textsc{term} :=\textsc{x}\ \textsc{x}\ \textsc{-}\textsc{int}\ \ \mathtt{|}\ \mathtt{ Exp[float}\ \textsc{x}\]

where float and int are floating-point and integer constants, respectively, e.g., 4.0 * Exp[-2.0 x] * x^2.

Expolynomials represent common PDFs (e.g., Erlang, uniform) and enable approaches to fit data (e.g., moments [36], shape [19, 26]) obtained in different manners (e.g., estimated from measurements, synthetically generated). In Fig. 2, we assume the failure time was repeatedly measured, with values lower than \(x_{1}=72\,\mathrm{h}\) (3 days), \(x_{2}=144\,\mathrm{h}\) (6 days), and \(x_{3}=216\,\mathrm{h}\) (9 days) with frequency \(p_{1}=0.001\), \(p_{2}=0.006\), and \(p_{3}=0.016\), respectively, and, larger than \(x_{3}\) with frequency \(p_{4}=0.984\) and mean value \(672\,\mathrm{h}\) (28 days). These measurements can be modeled by the PDF of transition fail, piecewise-defined over 4 intervals: _i_) 3 uniform PDFs with value \(0.0000139\), \(0.0000694\), and \(0.000139\) over \([0,72)\), h, \([72,144]\) h, and \([144,216]\) h, respectively, fitting the PDF of time to failure within each interval \([x_{i},x_{i+1})\) as \((p_{i+1}-p_{i})/(x_{i}-x_{i})\ \forall\,i\in\{0,1,2\}\), with \(x_{0}=p_{0}=0\); _ii_) a shifted exponential PDF \(f(x)=p_{3}\alpha\exp(-\lambda x)\) for \(x\in[x_{3},\infty)\) with rate \(\lambda=0.002193\), shift \(x_{3}=216\,\mathrm{h}\), and \(\alpha=0.003522\) with mean value of \(672\,\mathrm{h}\) when \(x>x_{3}\)). Other, more complex, exppolynomial PDFs could be used. Conversely, we assume no measurements for the duration of failure detection, repair, and rejuvenation, associating transitions detect, repair, and rejuvenate with uniform PDF.

Weights are used to select one of the enabled IMM transitions or DET transitions with the same value, modeling discrete probabilistic choices depending on the logical state (e.g., probability of message losses depending on the channel conditions). Weights are defined as expressions of token counts in the current marking, e.g., 2.0*p1. Rates of EXP transitions can also be functions of the current marking, modeling durations depending on the logical state (e.g., service rates depending on the number of available servers).

### Model validation

The model is validated by interactive simulation to achieve confidence about its correspondence with the modeling aim, exploring the state space either manually, by selecting the next transition to fire, or automatically, by specifying a number of transition firings or a stop condition (i.e., function of the current marking). To support inspection, the firing probability and the range of firing times of transitions are evaluated by the method of stochastic state classes [18].

## 3 Model evaluation

### Rewards and stop conditions

_Rewards_ and _stop conditions_ enable the evaluation of the probability of a subset of execution paths satisfying specific criteria, and to calculate the expected value of rewards accrued in each state of such paths, supporting the assessment of non-functional requirements of stochastic systems.

**Rewards.** ORIS supports evaluation of rewards defined from the _marking process_\(\mathbb{M}=\{M(t),\,t\in\mathbb{R}_{\geq 0}\}\) where \(M(t)\) is the marking at time \(t\geq 0\). A reward \(r\) is an expression \(e\) combining constants and token counts so as to define a real-valued function over the set of markings, with EBNF syntax:

\[c :=\mathit{place}\ id\ |\ \ \mathit{constant}\] \[e :=\mathit{c}\ |\ \mathit{(e)}\ |\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{e}\ \mathit{

<!-- Pages 4-4 -->

Step conditions enable evaluation of reach-avoid objectives equivalent to a _bounded until operator_\(\phi_{1}\,\mathcal{U}^{[0,t]}\phi_{2}\) of probabilistic model checking [25], which specifies the set of behaviors where a safety condition \(\phi_{1}\) is always satisfied until a goal condition \(\phi_{2}\) is reached within the time bound \(t\). To evaluate the probability measure of these behaviors, the user can run transient analysis using the stop condition \({}^{1}\phi_{1}\,\mathsf{l}\,\mathsf{l}\,\phi_{2}\) (i.e., stop on illegal or goal states) and evaluate the reward \(\phi_{2}\) for each time instant \(t\) (i.e., compute the probability that a goal state is reached by \(t\) traversing only safe states). Probabilistic until and _probabilistic existence_true\(\mathcal{U}^{[0,t]}\phi_{2}\) are the most frequent specification patterns for quality and dependability requirements of software-intensive systems in domains like automotive systems and railway signalling [17].

**Example.** The model of Fig. 2 is analyzed by regenerative transient analysis with time limit \(t_{max}=$1344\,\mathrm{h}$\) (8 weeks) and step size \(k=$0.005\,\mathrm{h}$\), so that probabilities are evaluated for all \(t=0,k,2k,\ldots,\lfloor\frac{\tau_{max}}{k}\rfloor k\). We evaluate the _transient unavailability_, i.e., the probability that the system is not working at time \(t\), by computing the instantaneous reward \(\mathsf{Down>0}\,\mathsf{l}\,\mathsf{Detected>0}\,\mathsf{l}\,\mathsf{I}\, \mathsf{Rej>0}\), with initial marking \(\mathsf{Up}\,\mathsf{Wait}\). We also evaluate the _cumulative unavailability_, i.e., the expected outage time within \([0,t]\). As shown in Fig. 3, unavailability is very high (nearly 0.993) at time \(168\,\mathrm{h}\), since this is the schedule time of the first rejuvenation and the probability that the system fails sooner is low (nearly 0.009). As time progresses, failures and repairs before rejuvenation become more frequent, reducing unavailability at peaks produced by the initial schedule (rejuvenation is rescheduled after repair), and slightly increasing unavailability between peaks.

We also compute the _transient unreliability_, i.e., transient probability that the system has failed at least once by time \(t\), by computing the instantaneous reward \(\mathsf{Down>0}\) with stop condition \(\mathsf{Down>0}\) and initial marking \(\mathsf{Up}\,\mathsf{Wait}\). As shown in Fig. 3, system reliability is low: it could be improved with more frequent rejuvenations, though reducing availability.

### Analysis engines

ORIS provides a suite of analysis engines (see Fig. 1) implementing different solution methods while leveraging the same input format for rewards and stop conditions. Each engine imposes different limitations on the class of the underlying stochastic process of the STPN, which result in more efficient solution methods, but can require additional care (or approximations) during the modeling phase. Complexity factors of each engine are extensively discussed in [24].

**Markovian Engine.** It implements standard methods for transient and steady-state analysis of CTMCs [30], requiring STPNs with only EXP and IMM transitions, also known as Generalized Stochastic Petri Nets (GSPNs) [1]. To overcome this limitation, each GEN transition can be replaced (prior to analysis) with the sequence of EXP transitions obtained by a phase-type approximation, e.g., through PhFit [19].

**Enabling Restriction Engine.** It implements transient analysis for MRPs under enabling restriction [16], requiring STPNs with at most one GEN transition enabled in each state. It partitions the state space in subgraphs where only a specific GEN transition is enabled: the transient solution of each subgraph (computed with uniformization) is used to evaluate the global and local kernels of the MRP, which are used to solve a system of Volterra integral equations [21].

**Regenerative Engine.** It implements transient and steady-state analysis of MRPs with multiple GEN transitions enabled in each state [18]. Steady-state analysis requires the bounded regeneration restriction, which can be checked for an STPN by the (terminating) algorithm for nondeterministic analysis of the underlying TPN. Transient analysis can lift this restriction by allowing an error in the enumeration of MRP subgraphs [18]. The implementation leverages enumeration of stochastic state classes, which encode (symbolically) the joint PDFs of transition timers after each firing.

**Forward Engine.** It provides transient analysis of STPNs without restrictions on the occurrence of regenerations [18]. The implementation enumerates a single graph of stochastic state classes until the earliest firing times of transitions along each sequence surpass the time bound. To reduce the number of classes, the user can specify a truncation error, comprising the guaranteed error bound between approximate and exact probabilities. A truncation error is required if the STPN allows cycles of transitions firing in zero time [18].

**Nondeterministic Engine.** It implements nondeterministic analysis of the state space of STPNs [34]. The implementation encodes the dense set of timed states reached by an STPN as a directed graph (_state class graph_) where edges are transition firings and nodes are _state classes_ comprising a marking and a set of timer values. This analysis supports verification of qualitative properties of the model.

Figure 3: ORIS GUI: for the STPN model of Fig. 2, plots show transient rewards providing the transient unavailability (top), cumulative unavailability (center), and transient unreliability (bottom).

<!-- Pages 5-5 -->

## 4 Model-Driven Engineering

During early design, as well as implementation and integration stages, stochastic models provide a valuable means to assess non-functional requirements of a system through the evaluation of quantitative performance metrics (e.g., throughput, waiting time, rejection rate) and dependability attributes (e.g., availability, reliability, maintainability, security). Advancements in tools that generate and evaluate these models have enabled model-driven engineering of complex and cyberphysical systems ranging from real-time and self-adapting software components, to critical infrastructures for telecommunication, transportation, or power/water/gas distribution.

Notably, while most existing approaches are limited to stochastic models governed by EXP random variables, ORIS supports models with deterministic timers (e.g., timeouts) and non-EXP durations (e.g., delays in train networks). At the same time, its Java library (SIRIO) and toolkit facilitate the development of domain-specific tools exploring different system designs and parameters. To illustrate this approach, we consider the case study of passenger queues at tram stops.

Domain Model and System RequirementsThe transportation network includes _lines_ and _stations_: trains leave from the initial station of a line at regular time intervals, arriving at each station after a constant delay (the nominal time to travel from the initial station), plus a random _jitter_; the time between consecutive arrivals of passengers to a station is also a random variable. A global admission policy controls the number of passengers allowed to board the train, so that passengers with similar waiting times can be admitted at the following stations; and, if the queue is longer than a given threshold, passengers abandon the station. We evaluate the number of passengers waiting at a station, the probability that at least some passenger will be denied boarding, and the probability that a newly arrived passenger will abandon the station, which might be used to support early evaluation of the impact of social distancing measures during a pandemic.

STPN ModelTo model the passenger queue at a station, we define the model illustrated in Fig. 4: passengers arrive with exponential interarrival time (transition passengerArrival) with rate equal to \(0.01\) times the number of tokens in place Arrival; trains arrive after a deterministic delay equal to \(220\) (transition serviceArrival) plus a jitter distributed over \([0,60]\) according to either a uniform PDF, or the PDF \(f(x)=C[3\exp(-x/10)+(x/10)\exp(-x/10)]\) where \(C=40-100\exp(-6)\). The number of passengers allowed boarding is equal to the number of tokens in place TrainCapacity (i.e., transition boarding has the update function "Queue = max(0, Queue-TrainCapacity)"). When QueueCapacity passengers are already waiting, newly arrived passengers abandon the station (i.e., passengerArrival has enabling function "Queue < QueueCapacity").

Metrics EvaluationThe metrics of interest can be evaluated at each time \(t\) using regenerative transient analysis and rewards "Queue" (expected number of passengers waiting for a train), "If(Queue>TrainCapacity,1,0)" (prob. of at least one boarding denial upon train arrival), and "If(Queue==QueueCapacity,1,0)"(prob. of queue abandonment upon passenger arrival). We repeat the evaluation of these transient rewards for our two choices of jitter PDF, using a time step \(\Delta t=5\) for \(t\in[0,1000]\). As shown in Fig. 5, all metrics drop sharply near the expected arrival times of the trains: the expected number of waiting passengers oscillates between \(10\) and \(20\), while the probability of boarding denials (red) is higher than that of queue abandonment (blue). Using steady-state regenerative analysis, we can evaluate the value of these metrics at steady-state: respectively, \(16.8\), \(0.94\) and \(0.43\) for both jitter PDFs (uniform and the exppolynomial). Each analysis completes in under \(2\) minutes.

## 5 Conclusions

This paper illustrates the usual modeling and evaluation workflow in ORIS. Specifically, ORIS can be used as a GUI, supporting quick development of a model and validation of its operation by interactive simulation or evaluation of quantitative metrics (see Sections 2 and 3). It can be used also as a toolkit, supporting export of the model from the GUI as Java code, using the SIRIO API, allowing the user to introduce quantitative evaluation of parametric non-Markovian models into larger software projects (see Section 4).

Figure 4: STPN model of a passenger queue.

Figure 5: Queue size (green), probability of boarding denial (red), and queue abandonment (blue) for uniform (top) and exppolynomial jitter (bottom).

<!-- Pages 6-6 -->

## References

* [1] M. Ajmone Marsan, G. Conte, and G. Balbo. A class of generalized stochastic Petri nets for the performance evaluation of multiprocessor systems. _ACM Trans. Comput. Syst._, 2(2):93-122, May 1984.
* [2] E. G. Amparore, G. Balbo, M. Beccotti, S. Donatelli, and G. Franceschinis. _30 Years of GreatSPN_, chapter In: Principles of Performance and Reliability Modeling and Evaluation: Essays in Honor of Kishor Trivedi, pages 227-254. Springer, Cham, 2016.
* [3] G. Behrmann, A. David, and K. G. Larsen. A tutorial on uppaal. In _SFM-RT'04_, number 3185 in LNCS, pages 200-236. Springer-Verlag, September 2004.
* [4] B. Berthomieu and M. Diaz. Modeling and Verification of Time Dependent Systems Using Time Petri Nets. _IEEE TSE_, 17(3):259-273, 1991.
* construction of abstract state spaces for Petri Nets and Time Petri Nets. _International Journal of Production Research_, 42(14), 2004.
* [6] M. Biagi, L. Carnevali, M. Paolieri, F. Patara, and E. Vicario. A continuous-time model-based approach for activity recognition in pervasive environments. _IEEE Trans. on Human-Machine Systems_, 49(4):293-303, 2019.
* Level 3. _Transportation Research Part C: Emerging Technologies_, 82:314-336, 2017.
* [8] M. Biagi, L. Carnevali, F. Tarani, and E. Vicario. Model-based quantitative evaluation of repair procedures in gas distribution networks. _ACM Trans. on Cyber-Physical Systems_, 3(2):19:1-19:26, Dec. 2018.
* [9] L. Carnevali, C. Nugent, F. Patara, and E. Vicario. A Continuous-Time Model-Based Approach to Activity Recognition for Ambient Assisted Living. In _QEST'15_, pages 38-53. Springer, 2015.
* [10] L. Carnevali, L. Ridi, and E. Vicario. A quantitative approach to input generation in real-time testing of stochastic systems. _IEEE TSE_, 39(3):292-304, 2013.
* [11] L. Carnevali, F. Tarani, and E. Vicario. Performability evaluation of water distribution systems during maintenance procedures. _IEEE Trans. on Systems, Man and Cybernetics: Systems_, to appear.
* [12] G. Gardey, D. Lime, M. Magnin, and O. Roux. Romeo: a tool for analyzing Time Petri Nets. _CAV'05_, 2005.
* [13] S. Garg, A. Puliafito, M. Telek, and K. Trivedi. Analysis of preventive maintenance in transactions based software systems. _IEEE TC_, 47(1):96-107, 1998.
* [14] S. Garg, A. Puliafito, M. Telek, and K. S. Trivedi. Analysis of software rejuvenation using Markov Regenerative Stochastic Petri Net. In _ISSRE'95_, pages 180-187, 1995.
* [15] R. German. Iterative analysis of Markov regenerative models. _Perform. Eval._, 44(1-4):51-72, 2001.
* [16] R. German, D. Logothetis, and K. S. Trivedi. Transient analysis of Markov regenerative stochastic Petri nets: a comparison of approaches. In _PNPM'95_, pages 103-112, 1995.
* [17] L. Grunske. Specification patterns for probabilistic quality properties. In _ICSE'08_, pages 31-40. ACM, May 2008.
* [18] A. Horvath, M. Paolieri, L. Ridi, and E. Vicario. Transient analysis of non-Markovian models using stochastic state classes. _Perform. Eval._, 69(7-8):315-335, July 2012.
* [19] A. Horvath and M. Telek. PhFit: A General Phase-Type Fitting Tool. In _Computer Performance Evaluation, Modelling Techniques and Tools (TOOLS'02)_, pages 82-91, 2002.
* [20] Y. Huang, C. M. R. Kintala, N. Kolettis, and N. D. Fulton. Software Rejuvenation: Analysis, Module and Applications. In _International Symposium on Fault-Tolerant Computing_, pages 381-390, 1995.
* [21] V. Kulkarni. _Modeling and analysis of stochastic systems_. Chapman & Hall, 1995.
* [22] M. Kwiatkowska, G. Norman, and D. Parker. PRISM 4.0: verification of probabilistic real-time systems. In _CAV'11_, volume 6806 of _LNCS_, pages 585-591. Springer, 2011.
* [23] ORIS. Homepage. [http://www.oris-tool.org](http://www.oris-tool.org), 2021.
* [24] M. Paolieri, M. Biagi, L. Carnevali, and E. Vicario. The ORIS Tool: Quantitative Evaluation of Non-Markovian Systems. _IEEE Trans. on Soft. Eng._, 47:1211-1225, 2021.
* [25] M. Paolieri, A. Horvath, and E. Vicario. Probabilistic Model Checking of Regenerative Concurrent Systems. _IEEE TSE_, 42(2):153-169, Feb 2016.
* [26] P. Reinecke, T. Krauss, and K. Wolter. Phase-Type Fitting Using HyperStar. In _EPEW'13_, pages 164-175, 2013.
* 1590, 2010.
* [28] W. H. Sanders and J. F. Meyer. Stochastic activity networks: formal definitions and concepts. In _School Europ. Educ. Forum_, pages 315-343. Springer, 2000.
* [29] SIRIO. [https://github.com/oris-tool/sirio](https://github.com/oris-tool/sirio), 2021.
* [30] W. J. Stewart. _Introduction to the Numerical Solution of Markov Chains_. Princeton University Press, 1995.
* [31] K. S. Trivedi. _Probability and statistics with reliability, queuing, and computer science applications_. John Wiley and Sons, New York, 2001.
* [32] K. S. Trivedi and R. Sahner. SHARPE at the Age of Twenty Two. _SIGMETRICS Perform. Eval. Rev._, 36(4):52-57, Mar. 2009.
* [33] A. van Moorsel and K. Wolter. Analysis of restart mechanisms in software systems. _IEEE TSE_, 32(8):547-558, Aug 2006.
* [34] E. Vicario. Static analysis and dynamic steering of time-dependent systems. _IEEE TSE_, 27(8):728-748, Aug. 2001.
* [35] E. Vicario, L. Sassoli, and L. Carnevali. Using stochastic state classes in quantitative evaluation of dense-time reactive systems. _IEEE TSE_, 35(5):703-719, Sept./Oct. 2009.
* [36] W. Whitt. Approximating a point process by a renewal process, I: Two basic methods. _Operations Research_, 30(1):125-147, 1982.
* [37] A. Zimmermann. Modelling and Performance Evaluation with TimeNET 4.4. In _QEST'17_, pages 300-303, 2017.