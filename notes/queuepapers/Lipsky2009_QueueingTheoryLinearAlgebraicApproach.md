<!-- Nougat extraction of Lipsky - 2009 - Queueing Theory.pdf -->
<!-- Extraction ID: beddc931-8af7-456c-be5b-a6996e8096e4_20251013_153753 -->
<!-- Actual page count: 560 -->
<!-- Successful chunks: 342 -->
<!-- Failed chunks: 218 -->
<!-- Extraction date: 2025-10-13T16:36:09.047908 -->

<!-- Pages 3-3 -->

Lester Lipsky

Queeting Theory

A Linear Algebraic Approach

Second Edition

<!-- Pages 4-4 -->

Lester Lipsky

Professor Emeritus

Department of Computer Science

and Engineering

University of Connecticut

Storrs, CT 06268-2155

lester.lipsky@uconn.edu

ISBN: 978-0-387-49704-4

e-ISBN: 978-0-387-49706-8

DOI 10.1007/978-0-387-49706-8

Library of Congress Control Number: 2008937578

Mathematics Subject Classification (2000): 60XX, 68XX, 90XX, 60K25, 60J27, 90B22, 60K05

The first edition of this book was first published by: Macmillan (now Pearson Publications, Inc.)

(c) Springer Science+Business Media, LLC 2009

All rights reserved. This work may not be translated or copied in whole or in part without the written permission of the publisher (Springer Science+Business Media, LLC, 233 Spring Street, New York, NY 10013, USA), except for brief excerpts in connection with reviews or scholarly analysis. Use in connection with any form of information storage and retrieval, electronic adaptation, computer software, or by similar or dissimilar methodology now known or hereafter developed is forbidden.

The use in this publication of trade names, trademarks, service marks, and similar terms, even if they are not identified as such, is not to be taken as an expression of opinion as to whether or not they are subject to proprietary rights.

Printed on acid-free paper

springer.com

<!-- Pages 5-5 -->

## Dedication

To my wife, Sue, with whom each day is fresh and new, a truly Markovian relationship.

<!-- Pages 6-6 -->

### A Path to Discovery

Theories of the known which are described by different ideas, may be equivalent in all their predictions and are hence scientifically indistinguishable. However, they are not psychologically identical when trying to move from that base into the unknown. For different views suggest different kinds of modifications which might be made. Therefore, a good scientist today might find it useful to have a wide range of viewpoints and mathematical expressions of the same theory available to him. This may be asking too much of one person. The new students should as a class have this. If every individual student follows the same current fashion in expressing and thinking about the generally understood areas, then the variety of hypotheses being generated to understand the still open problems is limited. Perhaps rightly so,... BUT if the truth is in another direction, who will find it?

Richard P. Feynman

So spoke an honest man, the outstanding intuitionist of our age and a prime example of what may lie in store for anyone who dares to follow the beat of a different drum.

Julian Schwinger

From a special issue on Richard Feynman (who died on 15 February 1988) in Physics Today, February 1989. Feynman's quote (slightly paraphrased here) was taken from his Nobel lecture in June 1965.

[Note: Feynman and Schwinger shared the Nobel prize with S. Tomonaga in 1965 for their work on quantum electrodynamics in the late forties. Working independently, and using radically different methods, they ended up with mathematically equivalent theories. Schwinger and Tomonaga were the "mainstreamers," but everyone calculates using Feynman's method to this day.]

<!-- Pages 7-7 -->

###### Contents

* 1 Preface to Second Edition
* 2 Preface to First Edition
	* 2.1 INTRODUCTION
		* 2.1.1 Background
		* 2.1.1 Basic Formulas
		* 2.1.2 Markov Property
		* 2.1.3 Notation, Pronouns, Examples
	* 2.2 Distribution Functions Over Time
		* 2.2.1 Exponential Distribution (Continuous Time, \(t\))
	* 2.2 Geometric Distribution (Discrete Time, \(n\))
	* 2.3 Chapman-Kolmogorov Equations
		* 2.3.1 Continuous Time
		* 2.3.2 Discrete Time
		* 2.3.3 Time-Dependent and Steady-State Solutions
		* 2.3.1 Some Properties of Matrices
		* 2.3.2 How a System Approaches Its Steady State
* 2 M/M/1 QUEUE
	* 2.1 Steady-State M/M/1-Type Loops
		* 2.1.1 Time-Dependent Solution for \(N=2\)
		* 2.1.2 Steady-State Solution for Any \(N\)
		* 2.1.3 Open M/M/1 Queue (\(N\rightarrow\infty\))
		* 2.1.4 Buffer Overflow and Cell Loss for M/M/1/\(N\) Queues
		* 2.1.5 Load-Dependent Servers
		* 2.1.6 Departure Process
	* 2.2 Relaxation Time for M/M/1/\(N\) Loops
	* 2.3 Other Transient Parameters
		* 2.3.1 Mean First-Passage Times for Queue Growth
		* 2.3.2 \(k\)-Busy Period
			* 2.3.2.1 Mean Time of a Busy Period
			* 2.3.2.2 Probability That Queue Will Reach Length \(k\)
			* 2.3.2.3 Maximum Queue Length During a Busy Period
* 3

<!-- Pages 9-9 -->

* 4M/G/1 QUEUE
	* 4.1 S.S. M/ME/1// \(N\) (and M/ME/1/ \(N\)) Loop
		* 4.1.1 Balance Equations
		* 4.1.2 Steady-State Solution
		* 4.1.3 Departure and Arrival Queue-Length Probabilities
	* 4.2 Open M/ME/1 Queue
		* 4.2.1 Steady-State M/ME/1 Queue
		* 4.2.2 System Times: Pollaczek-Khinchine Formulas
			* 4.2.2.1 Mean Queue Length
			* 4.2.2.2 Queue-Length Probabilities of M/PT/1 Queues
			* 4.2.2.3 Throughput
			* 4.2.2.4 Z-Transform
		* 4.2.3 System Time Distribution
		* 4.2.4 Buffer Overflow and Customer Loss
		* 4.2.5 Distribution of Interdeparture Times
	* 4.3 M/G/1 Queue Dependence On \(n\)
		* 4.3.1 Residual Time as Seen by a Random Observer
		* 4.3.2 Weighted Averages of Matrix Operators
		* 4.3.3 Waiting Time as Seen by an Arriving Customer
		* 4.3.4 System Time of an Arriving Customer
	* 4.4 Relation To Standard Solution
		* 4.4.1 Exponential Moments, \(\boldsymbol{\alpha_{k}(s)}\), and Their Meaning
		* 4.4.2 Connection to Laguerre Polynomials
		* 4.4.3 Connection to Standard Solution
		* 4.4.4 M/M/X// \(N\) Approximations to M/ME/1// \(N\) Loops
	* 4.5 Transient Behavior of M/ME/1 Queues
		* 4.5.1 First-Passage Processes for Queue Growth
			* 4.5.1.1 Conditional Probabilities for Queue Growth
			* 4.5.1.2 Mean First-Passage Time for Queue Growth
		* 4.5.2 Formal Procedure for Finding System Parameters
		* 4.5.3 Properties of the \(k\)-Busy Period
			* 4.5.3.1 Conditional Probabilities for Queue Decrease
			* 4.5.3.2 Mean First-Passage Times for Queue to Drop
			* 4.5.3.3 Probability That Queue Will Reach Length \(n\)
			* 4.5.3.4 Maximum Queue Length of a Busy Period
		* 4.5.4 Mean Time to Failure with Backup and Repair
* 5G/M/1 QUEUE
	* 5.1 Steady-State Open ME/M/1 Queue
		* 5.1.1 Steady-State Probabilities of the G/M/1 Queue
		* 5.1.2 Arrival and Departure Probabilities

<!-- Pages 10-10 -->

5.1.3 Properties of Geometric Parameter \(s\) * 5.1.4 Systems Where Interarrival Times Are Power-Tailed * 5.1.5 Buffer Overflow Probabilities for the G/M/1 Queue * 5.2 ME Representation of Departures * 5.2.1 Arrival Time Distribution Conditioned by a Departure * 5.2.2 Distribution of Interdeparture Times * 5.3 ME/M/1/\(N\) and ME/M/1//\(N\) Queues * 5.3.1 Steady-State Solution of the ME/M/1/\(N\) Queue * 5.3.2 Arrival Probabilities and Customer Loss * 5.4 Steady-State ME/M/C-Type Queues * 5.4.1 Steady-State ME/M/X/ /\(N\) Loops * 5.4.2 Steady-State ME/M/C Queue * 5.4.3 Arrival and Departure Points * 5.5 Transient Behavior of G/M/1 Queues * 5.5.1 First-Passage Times for Queue Growth * 5.5.2 The \(k\)-Busy Period
* 6 M/G/_C_-TYPE SYSTEMS
	* 6.1 Introduction
	* 6.2 Steady-State M/ME/2//\(N\) Loop
		* 6.2.1 Definitions
		* 6.2.2 Balance Equations
		* 6.2.3 Solution of Probability Vectors
	* 6.3 Steady-State M/G/C//\(N\)-Type Systems
		* 6.3.1 Steady-State M/ME/C//\(N\) Loop
		* 6.3.2 Alternate Representation of M/ME/C//\(N\) Systems
		* 6.3.3 Generalized M/ME/C//\(N\) System
		* 6.3.4 Relation to Jackson Networks
		* 6.3.5 Time-Sharing Systems with Population Constraints
	* 6.4 Open Generalized M/G/_C_ Queue
	* 6.5 Transient Generalized M/ME/C Queue
		* 6.5.1 Queue Reduction at \(S_{1}\) with No New Arrivals
		* 6.5.2 Markov Renewal (Semi-Markov Departure)
		* 6.5.3 A Little Bit of Up and Down, with Arrivals
			* 6.5.3.1 First-Passage Processes for Queue Growth
			* 6.5.3.2 First Passages for Queue Decrease
			* 6.5.3.3 MTTF with Backup and Repair
	* 6.6 Conclusions
* 7 G/G/1//N LOOP
	* 7.1 Basis-Free Expression for \(\mathbbm{Pr}[X_{1}<X_{2}]\)
	* 7.2 Direct Products of Vector Spaces
		* 7.2.1 Kronecker Products
		* 7.2.2 \(\Psi\) Projections onto Subspaces
	* 7.3 Steady-State ME/ME/1//\(N\) Loop
		* 7.3.1 Balance Equations

<!-- Pages 11-11 -->

#### 7.3.2 Steady-State Solution

\(7.3.3\) Outline of an Efficient Algorithm

\(7.3.4\) An Example

\(7.4\) A Modicum of Transient Behavior

\(8\) SEMI-MARKOV PROCESS \(8.1\) Introduction

\(8.1.1\) Matrix Representations of Subsystems

\(8.2\) Markov Renewal Processes

\(8.2.1\) Interdeparture Time Distributions

\(8.2.2\) Correlation of Departures

\(8.2.3\) Laplace Transforms

\(8.3\) Some Examples

\(8.3.1\) Departures from Overloaded Server: Renewal Process

\(8.3.2\) Markov Modulated (or Regulated) Processes

\(8.3.2.1\) The Underlying Generator, \(\boldsymbol{\mathcal{Q}}\)

\(8.3.2.2\) Markov Regulated Departure

Process (MRDP)

\(8.3.2.3\) Markov Modulated Poisson

Process (MMPP)

\(8.3.2.4\) Augmented MMPP's (AMMPP)

\(8.3.2.5\) ON-OFF Models (Bursty Traffic)

\(8.3.3\) Merging Renewal Processes

\(8.3.4\) Departures from Overloaded Multiprocessor Systems

\(8.3.5\) Departures from ME/ME/1 Queues

\(8.3.5.1\) If \(S_{2}\) Is Exponential (M/ME/1 Queues)

\(8.3.5.2\) If \(S_{1}\) Is Exponential (ME/M/1 Queues)

\(8.3.5.3\) Both \(S_{1}\) and \(S_{2}\) Are Nonexponential

\(8.3.5.4\) M/M/1//_N_ Queues

\(8.4\) MRP/M/1 Queues

\(8.4.1\) Balance Equations

\(8.4.2\) Some Performance Measures

\(8.4.3\) The G/M/1 Queue as an Example

\(9\) LAQT

\(9.1\) Isometric Transformations

\(9.2\) Linear Algebraic Formulation

\(9.2.1\) Description of a Single Server

\(9.2.2\) Residual Vector and Related Properties

\(9.3\) Networks of Nonexponential Servers

\(9.3.1\) Description of System

\(9.3.2\) Service Time Distribution

\(9.4\) Systems With Two Servers

\(9.4.1\) G/M/1 Queue

\(9.4.2\) Two Nonexponential Servers

\(9.4.3\) Review of Transient Behavior

\(9.5\) Concluding Remarks

<!-- Pages 12-12 -->

**Symbols**

**Abbreviations**

**Bibliography**

**Index**

<!-- Pages 13-13 -->

## Preface to Second Edition

_We have a habit in writing articles published in scientific journals to make the work as finished as possible, to cover up all the tracks, to not worry about the blind alleys or describe how we had the wrong idea first, and so on. So there isn't any place to publish, in a dignified manner, what we actually did in order to get to do the work._

Richard P. Feymann, Nobel Lecture, 1965.

When the first edition of this book first appeared, there were few books that covered Linear Algebraic Queueing Theory (LAQT), all at a higher level. At that time I made the claim that this would become the approach of choice. Now, some 15 years later, the claim has largely been realized, particularly in problems concerning semi-Markov processes and system reliability. The prediction that because transient phenomena could now be expressed in a computationally manageable form, this subject would also become more important, seems to be slowly coming true as well. Many research papers have been published, resulting in several books containing collections of these papers, mostly on computational methods, as in for instance, [4], [5], and [11]. The monograph by Latouche and Ramaswami (leaders in the field) [12] covers the subject well, but at a higher level. (Their title, _Introduction to Matrix Analytic Methods..._ could be modified to _Introduction to Advanced Matrix Analytic Methods..._+.) Yet no new book at the intermediate level has emerged that takes a linear algebraic approach. That is, when possible, theorems are proven by matrix algebraic manipulation, rather than using explicit properties of matrices or probabilistic arguments. Therefore, an updated version of the original is needed.

Footnote †: A definition of _elementary_, or _introductory_ is: "that which the author understands." _Advanced_ means: "that which the author is not sure about," whereas _intermediate_ is: "that which the author figured out while writing the book."

This second edition, in addition to making many corrections and improvements, is larger by a third than the first edition. The increase in size reflects the growing recognition of the importance of processes that generate unboundedly large variances or long-range autocorrelation, as seen in CPU times, file sizes, telecommunications traffic, finance, and insurance claims. Thus an extensive amount of material has been added to Chapter 3 describing a broad set of ME functions. In particular there is an entire section on power-tail (PT), or Pareto distributions (they form a proper subset of the heavy-tailed distributions), including a section showing how they can be represented by ME distributions within the Markovian structure, even though they have infinite moments. They are then used in Chapters 4 and 5 to study queues with

<!-- Pages 14-14 -->

PT service times, and to see how PT renewal processes affect system times.

A new Chapter 8 has been added that covers Semi-Markov processes (SMP), an important topic that is used extensively in queueing models of performance from system reliability to telecommunications systems to performance of computer clusters to inventory problems in operations research. We first give a formal mathematical description of the properties of SMPs and the related Markov Renewal Processes (MRP). Several detailed examples are then presented, each with a different state-space construction. We then look at some _ON-OFF_ models used in modeling telecommunications traffic.

The old Chapter 8 is now Chapter 9, and includes a new section on how to deal with networks of nonexponential servers.

## Acknowledgments

When I decided to write a second edition in 2000 I realized that the original text, written in DITROFF, would have to be translated to LaTeX. Lucky for me that my friend, Dr. Michael Greiner, willingly took on the task of writing the translator and overseeing its execution by Michael Schneider. Without their efforts I might still be doing the translation by hand. I must thank my friends at Technical University of Munich, Prof. Eike Jessen and Dr. Manfred Jobmann, for their longtime support and encouragement from the time I spent my sabbatical year at TUM in 1994. Manfred has carefully read the original and now the final version and has found more errata than I can afford to pay at $1 per error. Don Costello invited me to give a series of lectures and then encouraged me to write the second edition with expanded coverage of heavy-tailed distributions. Thanks to former Dean Amir Fagri and the School of Engineering at UCONN, and my department chair, Reda Ammar, for providing funding and a sabbatical so I could work on the book and hire Justin Besiglio and Robert Sheahan to produce many of the figures herein. In the last two years, Robert and Feng Zhang have generated the rest of the graphs and helped with the formatting of the book. I don't know how I can show proper appreciation of their extraordinary efforts. Thanks to my former students, Jisung Woo, Steve Thompson, Marwan Sleiman, Sarah Tasneem, Cindy Siriwong, Gehan Verasinghe and the many students who have taken my LAQT course but whose names have slipped from my grasp, for sharing in the proofreading. Special thanks to my former students and present collaborators, Hans-Peter Schwefel, Pierre Fiorini, Ahmed Mohamed, and Imad Antonios for their invaluable input. Prof. Sgren Asmussen provided valuable suggestions on making tighter definitions, in particular on defining _heavy-tailed_ distributions and their subsets. I also want to thank Peter Kuhl for spending so much time editing the entire book, as well as other suggestions for improving the text. Any errors that remain are mine alone. My thanks to Springer-Verlag for their offer to publish the book, and thanks most of all to my wife, Sue, for persevering through it all.

Storrs, CT, April 2008

<!-- Pages 15-15 -->

## Preface to First Edition

_"Necessity is the mother of invention" is a misleading proverb._

_"Necessity is the mother of temporary fixups" is much nearer to the truth. The basis of the growth of modern invention is science, and science is largely the outgrowth of intellectual curiosity._

Alfred North Whitehead

At least 50 worthwhile books on queueing theory have been written in the last 35 years. Two or three times as many books have been published in which queueing theory and Markov chains play an important part. Most of these books, even the older ones, are still useful for understanding at least some part of the subject. Why, then, should yet another book be published? The answer, simply, is that there is no book (or even collection of papers) that covers intermediate queueing theory using what I call "Linear Algebraic Queueing Theory" (LAQT). There are in fact only two books which use a linear algebraic approach, both by Marcel Neuts [11] and [12], and both of them are written for experts in the field. I waited five years for someone to write a book that could be used for a first or second course in the subject (never do anything if someone else is going to do it), but to no avail. So in 1988 I started to write it myself.

The reason that LAQT should become familiar to novices as well as to those who are already knowledgeable in intermediate and advanced queueing theory is that any problems that can be cast into a matrix-vector format can easily be adapted to make use of the high-speed parallel and vector processors available today. Also, many problems in queueing theory that traditionally are solved by unrelated mathematical techniques can now be solved in a consistent integrated fashion. This allows for better physical insight. But, most important, many system performance measures that are normally ignored because of their computational and formulated difficulties can be dealt with easily in LAQT. Some examples are: properties of the busy period, departure processes, first-passage times, residual times, distinctions between what an observer sees and what a customer sees, and compound processes in general. Each of these topics is treated here without requiring prior knowledge of the reader. This book makes the following claim. "Any problem that can be solved for exponential servers can somehow be extended to treat nonexponential servers." Of course, it remains to be seen whether the future will vindicate this optimism.

Many decisions had to be made before this book could be written. First, who is the intended audience? There are a half a dozen disciplines that claim queueing theory as one of their "bread-and-butter" techniques. Applied probability, computer science, electrical engineering, management science, operations research, systems engineering, and even physics lay claim to various

<!-- Pages 16-16 -->

parts of this subject as their own, each with its own terminology. Because I dabble in all these fields, I decided to try to write a generic book that could be understood by all. The terms used are defined in relation to customers arriving at, being served by, and departing from subsystems, from the different viewpoints of the customer and of an outside (sometimes random) observer. The mental image one gets is of humans being served by mechanical objects, while being observed by other human beings.

Another decision to be made was the level at which to present the material, namely, as a first or second course in queueing theory, as a reference book for practitioners, or as a monograph for would-be researchers in the field. Once again, I decided to try to aim for all. There is no reason why this material cannot be taught to mathematically mature college seniors or new graduate students who have already had courses in linear algebra and probability theory, but have not necessarily had any queueing theory. Unfortunately this would have required that the first two chapters be expanded to more than twice their present size without ever mentioning LAQT. There are already many books available that give an excellent introduction to queueing theory. Therefore I opted for either a first course, where the student already has had some background in Markov processes and elementary queueing theory, or a second course. For instance, many students in computer science and electrical engineering take a course in applied probability covering material such as that in Chapters 7 and 8 of Trivedi's book [17]. Alternately, many courses in performance modeling (e.g., courses using [18] or [19]) are adequate to serve as an introduction to this book.

We assume that the reader is already familiar with matrix theory. However, except for such elementary formulas as that defining matrix multiplication, we do not expect the student to have any particular theorem at his or her fingertips. Therefore background information is introduced as needed. There is no special section put aside for reviewing linear algebra. We assume the same about the reader's knowledge of integral and differential calculus (in particular, Taylor's series and l'Hospital's rule) and elementary probability theory. For those whose mathematics is a bit rusty, we recommend that an elementary text in each of these areas be kept handy. But worry not; for all the mathematical content, this is not a rigorous text. It is a "why and how to" book. Whenever we would like a matrix to have a particular property, we assume it is so, whether or not we can prove it.

The material is rather densely packed, so several readings and rereadings may be necessary for the less experienced queueing theorist, particularly because there are numerous definitions in the text, and definitions do not usually stick in one's mind without some effort. This problem is reduced somewhat by the book's layout. We are inclined to introduce an idea in one chapter, and then use it again in a subsequent section, but in a more intricate way. We have done our best to give explicit reference to material previously discussed.

<!-- Pages 17-17 -->

## For Instructors and Practitioners

One might say that the "father" of LAQT is Victor Wallace, who in the 1960s introduced the concept of Quasi Birth-Death (QBD) processes and proved that there exists a matrix geometric solution for a large class of such systems, including the open G/G/\(C\) queue [21]. His presentation, although motivated by queueing theory [22], was couched in terms of abstract Markov chains, and so was acknowledged, but was not picked up as a practical way of dealing mathematically, conceptually, or computationally with specific problems in elementary or intermediate queueing theory.

The first researcher actually to take this viewpoint in solving problems specific to queueing theory was Marcel Neuts, who in the mid-1970s introduced _PHase_ distributions [14] and showed that they had matrix representations which could be manipulated algebraically, while operating on state vectors corresponding to the queue length probabilities (one vector for each value of \(n\), the queue length). He strongly argued that a matrix formulation could more easily be handled by computers than could integration or differentiation [14]. Also, since so many problems seemed to have a recursive solution, algorithms for their numerical evaluation became straightforward. However, he and his students concentrated most of their efforts attacking hitherto unsolved problems, and thus remained too abstract to be appreciated by the practical users (as I was then) of queueing theory. It seemed as though this was just another one of the many techniques one might use to solve a small set of problems.

This researcher became interested in the subject in the late 1970s in studying the problem of what happens to a subnetwork of exponential servers when the number of customers who can be active simultaneously is restricted. My students and I soon realized that if the subsystem was restricted to one active customer, then that subsystem was equivalent to a single server with a nonexponential (Coxian, or Kendall [15], or RLT, or matrix exponential) distribution. Then, after John Carroll reduced the balance equations from second-order to first-order difference equations [16], we independently, and virtually simultaneously with Neuts, found the explicit matrix geometric solution to M/G/1 and G/M/\(C\) queues. The two papers appeared back-to-back in the May-June 1982 issue of _Operations Research_[16], [17]. I consider this to be the true beginning of LAQT, for then it became clear that many seemingly diverse problems could be solved using one technique and one viewpoint.

It is interesting to realize that the basis for LAQT was established by Erlang himself [1] when he represented a single server by a series of exponential stages, but linear algebra was not in vogue at the turn of this century, so queueing theory had to be developed entirely within the framework of what is called "modern analysis." The "method of stages" is really a part of LAQT, distorted so it could fit into the classical view, whereas D. R. Cox's work in the 1950s [18], showing iin effect that "every pdf can be approximated arbitrarily closely by a function whose Laplace transform can be written as the ratio of two polynomials (RLT functions)" is really the basis

<!-- Pages 18-18 -->

for claiming that there exists a linear algebraic formulation of every problem which can be formulated otherwise.

You might question whether LAQT really is a peer to the standard variety of queueing theory. Well, for decades now, it has been standard technique in various areas of applied mathematics to replace differential operators on a solution function by an equivalent linear operator on a vector in Hilbert space. In fact, the pair of representations of quantum theory, Werner Heisenberg's _matrix mechanics_ and Erwin Schrodinger's _wave mechanics_, is the prime example of this duality. The proof by John von Neumann that they are mathematically equivalent is closely related to Cox's completeness statement in extending A. K. Erlang's method of stages to include all functions with rational Laplace transforms [12]. Fortunately for physics, linear algebra was a known quantity by the 1920s, so the two viewpoints grew together and have become so intertwined that the typical quantum practitioner switches from one to the other and back again with little difficulty. A similar statement can be made about _linear control theory_. Both of those disciplines deal with functions of complex variables, even though what is actually observed must be real. If physicists can talk about the _charm_ of _quarks_, which can never be seen outside their nuclear home, and electrical engineers can have imaginary currents, surely our customers should be allowed to travel with negative probabilities and complex service times from one phase to another, as long as they remain inside one subsystem or another, and as long as all observable entities are real.

The reader should avoid mapping this material onto already familiar techniques, at least until Chapter 4 has been covered. By then you will see the power and elegance of this methodology, as well as its usefulness, and be able to "switch back and forth without difficulty." Furthermore, because most solutions are in terms of matrix operations rather than integrals, or roots of equations, highly efficient algorithms for both single and parallel computer systems can easily be written. There are several mathematical tool kits readily available (e.g., MATLAB, Mathematica, Maple) that execute matrix equations directly.

### Organization

The book is laid out by chapter in order of increasing complexity of structure. There is more than enough material for a two-semester course, but a one-semester first course or a one-semester second course can easily be fashioned.

In Chapter 1 we make a quick survey of those topics normally connected to Markov chains. Chapter 2 starts out as a continuation of Chapter 1 by using the Chapman-Kolmogorov equations to set up the M/M/1 queue. But we soon switch to the simpler and intuitively more satisfying view associated with steady-state transition diagrams. Every queueing system is made up of two subsystems, each of which contains one exponential server. In Chapter 3 we show that by adding structure to a subsystem we give it a nonexponential (called _Matrix Exponential_, ME) service time distribution. In Chapter 4 we

<!-- Pages 19-19 -->

combine the ideas of the two previous chapters to study the M/G/1 queue (i.e., one nonexponential and one exponential subsystem). As long as our system is closed (finite population of customers), there is no difference between an M/G/1//_N_ loop and a G/M/1//_N_ loop. But if the population is increased unboundedly, one or the other server will saturate. So, if the nonexponential server is the faster one, we have the open M/G/1 queue as given in Chapter 4. However, in Chapter 5 we assume that the exponential server is faster, and derive the properties of an open G/M/1 queue.

In Chapter 6 two or more customers can independently be active at once in one subsystem, the M/G/_C_ system. This increases the complexity of the mathematics required, as well as the computational complexity and sizes of matrices. But it also enormously increases the range of problems that can be solved, the so-called "generalized M/G/_C_ systems." In Chapter 7 we revert to one active customer per subsystem, but now both subsystems have structure, and we are dealing with a G/G/1//_N_ loop. This leads to a different increase in complexity, requiring a _direct product_ of vector spaces, which we must first discuss before actually finding the steady-state solution.

Finally, in Chapter 8 we try to give a linear algebraic formulation that does not depend upon a physical interpretation of individual states. As such, it acts as a review of the book.

The chapters are all structured in more or less the same way, with obvious deviations because of the material. First we find the closed steady-state solution. Then we "open" the loop by increasing the customer population unboundedly. Then we look at certain specialized topics (e.g., load-dependent servers, renewal theory, comparison with other methods). Finally we explore the transient behavior of the appropriate queue.

A one-semester first course would cover Chapter 1 and the steady-state parts of Chapters 2, 3, 4, and 5. Depending on the background of the students, the instructor might add some descriptive material to Chapters 1 and 2.

Assuming that students have already had a course in queueing theory, but not one that covered LAQT, a one-semester second course would skim through Chapter 1 and the first part of Chapter 2. But then Section 2.3 must be covered in earnest, as must the first part of Chapter 3. Except for the material on residual times, which must be covered, Section 3.5 can be omitted. Most of Chapters 4 and 5 should be covered, but the instructor can skip Chapter 6 if desired and go directly to Chapter 7. However, Chapter 6 is potentially of great practical importance, therefore the instructor may prefer to skip Chapter 7 instead. Chapter 9 can be put in or left out, as per taste.

A two-semester course can be given that combines the two one-semester courses in the order just described, or one can go sequentially from beginning to end, skipping those topics which seem inappropriate. However, one cannot study Section 6.5, for example, without first covering the related material in Chapters 2, 4, and 5.

<!-- Pages 20-20 -->

## Acknowledgments

I would like to thank Professor Howard Sholl and BECAT of the University of Connecticut for continued support in the technical creation of this book. In particular, Anthony Guzzi has rewritten DITROFF+ so it actually does what it is supposed to do (at least on my workstation). His devotion to my needs has been beyond the call. Also, I thank John Marshall and Sue Zajac+ for keeping the system up (most of the time) and the secretaries (Jean, Sue, Ruth, Sandi, and Sherry) for keeping me up (most of the time). To my former students, now collaborators, Appie van de Liefvoort (University of Missouri-KC), Aby Tehranipour (Eastern Michigan University), and Yiping Ding (now at BGS Systems, Inc.), I give thanks for technical advice in the various chapters where they are experts. Thanks to Seva nanda Adari, Jinzhu (Jim) Chen, and Houzhong Yan for reading the first draft and pointing out how ideas could be made clearer. I thank the students who were in my class in the fall of 1990 (Somnath Deb, Sharad Garg, Rudi Hackenberg, Chengdong Lu, Jim Moriarty, Carolyn Pe, and Cien Xu), who used the second version of this book and searched for errors of content. Siddhartha Roy and Dilip Tagare meticulously went through the final draft, searching for errors of all kinds (and they found many). Dilip and Ed Bigos were also responsible for generating most of the graphs. To Professors Joseph Macek (University of Tennessee); George Nagy (Rensselaer Polytechnic Institute); Don Costello and Sharad Seth (University of Nebraska); Don Towsley (University of Massachusetts); Victor Wallace (University of Kansas); and Arnie Russek (my thesis advisor), Jim Galligan, and Krishna Pattipati (all of the University of Connecticut), thanks for useful critical comments. I must also thank Macmillan Publishing Company's Ed Maura for taking the initiative in inviting me to do the book, John Griffin who oversaw the project from cover to cover, the unknown proofreader who went through the text with the devotion of a mother combing her daughter's hair, and especially Leo Malek who was determined that this would be a good-looking book. Thanks to Erikson/Dillon Art services for creating such fine figures and page layout, and finally, Janet Pecorelli and the American Mathematical Society's printing service in Providence, RI, for producing such high-quality galley proofs at short notice.

Footnote †: As of May 4, 1996, now known as Sue Marie Lipsky.

Storrs, CT, November 1991

<!-- Pages 21-21 -->

## Chapter 1 Introduction

_The ultimate Markov observation: "Today is the first day of the rest of your life."_

This author is often asked what queueing theory is. First we state that _queueing_ is the only word in the English language with five successive vowels (there is an alternative spelling that deletes the second \(e\), but it is obviously inferior) and that a queue is a line of customers waiting to be served, such as one sees in banks, supermarkets, and fast-food outlets. More often than not, the questioner will interrupt to say, "You've been doing a bad job, and common sense would tell us how to do things better." Of course we have not even begun to explain where the theory comes in ("So, you're in queueing?"). The goal of a mathematical modeler (the class of researchers to which queueing theorists belong) is to describe and understand what is really going on, for only then can someone (not necessarily the modeler) make an informed decision on what should be done to improve things. You, the reader, presumably already know what a queue is and will have the patience to learn some of the theory, particularly that related to our Linear Algebraic Approach to Queueing Theory (LAQT), which doesn't show up until Chapter 3.

### 1.1 Background

Any system in which the available resources are not sufficient to satisfy the demands placed upon them at all times is a candidate for queueing analysis. This is quite a general statement, but in this treatise we have tried to keep our picture as simple and as explicit as possible. We deal with _subsystems_ (or _service centers_), denoted by \(S_{1}\), \(S_{2}\),..., \(S_{m}\). Customers then wander from one subsystem to another, perhaps forever. We are not so ambitious as to consider in detail more than two subsystems at a time, but we do allow each subsystem to have one or more servers in it, where each server is itself made up of one or more stages, or phases. But we are getting ahead of ourselves with such detail.

#### Basic Formulas

What can we say about such systems? What do we know? Well, the single most important rule is _Little's formula_ (1.1.2) [11], which we now describe. Consider an arbitrary subsystem, as shown in Figure 1.1.1. Customers

<!-- Pages 23-23 -->

decreasing function of \(t\) that is the same from day to day. His definition of (1.1.1a), as you may recall, is the following.

_Definition 1.1.1_.

If for all \(\varepsilon>0\), there exists a \(t_{\mathrm{o}}\) such that for all \(t>t_{\mathrm{o}}\), the following is true

\[\left|\frac{N(t)}{t}-\Lambda\right|<\varepsilon\,,\]

then (1.1.1a) is true in the mathematical sense. (We use \(|X|\) to denote absolute value of \(X\).) \(\qed\)

On the other hand, the outside observer, as she counts the arriving customers, would note that \(N(T)\) is a stochastic function (also monotonic non-decreasing) that varies from day to day. Her definition of (1.1.1a) is the following:

_Definition 1.1.2_.

If for all \(\delta\) and \(\varepsilon>0\), there exists a \(t_{\mathrm{o}}\) such that for all \(t>t_{\mathrm{o}}\), the following is true,

\[\operatorname{\mathbbm{Pr}}\left(\left|\frac{N(t)}{t}-\Lambda\right|> \varepsilon\right)<\delta,\]

then (1.1.1a) is true in the probabilistic sense. (The symbol \(\operatorname{\mathbbm{Pr}}(X)\) stands for the phrase "the probability that the expression represented by \(X\) is true.") \(\qed\)

The additional assumption (in both cases) is that the underlying conditions do not change from day-to-day, even though, for the observer, the count will be different each day. Depending on the context, we mean one or the other definition when we write something like (1.1.1a). The reader should spend a few moments reviewing these two ideas.

We now return to our discussion of _Little's formula_. As a second measurement, our observer could keep track of how long each customer spends in the subsystem, for each visit, calling it \(x_{i}\) for the \(i\)-th visitor. Then the average time spent in the subsystem by a typical customer is given by

\[\bar{T}=\frac{1}{N(t)}\sum_{i=1}^{N(t)}x_{i} \tag{1.1.1b}\]

for very large \(t\) (as \(t\to\infty\)).

As a third measurement, or set of measurements, our observer might at random times count how many customers are in the subsystem, and call it \(n_{i}\). (We were rather flippant in the use of _random times_. By that we mean the random observer takes measurements at times that are separated by intervals that are independent and taken from the same exponential distribution, the definition of a Poisson process.) If she does this often enough, say, \(m\) times, she

<!-- Pages 24-24 -->

can claim that the average number of customers in \(S\) (or the _queue length_ at \(S\)) up to any time is given by

\[\bar{q}\,=\ \frac{1}{m}\sum_{i=1}^{m}n_{i}\,. \tag{1.1.1c}\]

If \(m\) and \(t\) are large enough Little's formula relates these three measurements by the simple formula

\[\bar{q}=\Lambda\bar{T}. \tag{1.1.2}\]

Little published his proof in 1961 [11], but it was not satisfactory, and several papers were published subsequently, including S. Stidham's "Last Word" in 1974 [12]. But even that was unsatisfactory to F. J. Beutler who "Revisited" it in 1980 [1]. Since then, rigorous proofs have been published for specific systems (see e.g. [10] and [11]). To this day it is more likely to be called Little's formula instead of Little's theorem or Little's law. Even so, it is used broadly and widely, and no counterexamples of consequence have surfaced. See [13] or [14] for a constructive (and instructive) proof.

Little's formula tells us that given any two of the performance parameters, the third parameter is uniquely determined by (1.1.2). In other words, the three measurements, in principle, are not independent of each other. In fact, Little's formula is true even if \(\bar{T},\ \bar{q},\) and \(\Lambda\) do not approach a limit, just as long as \(n_{i}/N(t)<<1\). In studying real-world systems, cautious experimenters will usually measure all three parameters and then use Little's formula to check for self-consistency and/or reliability of data. In mathematical modeling the limit as \(t\) goes to infinity can be taken correctly, therefore (1.1.2) holds exactly (except for some pathological systems that we ignore here).

The second most important formula, and the first one always derived in any discussion of queueing systems, is the steady-state solution of the open M/M/1 queue. We derive and discuss this in Chapter 2, but for now we merely look at the result. Suppose that customers arrive randomly and independently of each other to a lone server and that the average rate at which they arrive is given by the parameter \(\lambda\). Suppose further that the time between arrivals is a random number taken from the exponential distribution, with mean \(\bar{x}_{2}=1/\lambda\) and that the arrivals are independent of each other. This is known as a _Poisson arrival process_, which we run across again and again throughout the book. Let \(X\) be the random variable (r.v.) denoting the time needed by a customer once he gets to be served. The actual time he needs is also taken from an exponential distribution, but with mean \(\bar{x}_{1}\). We have thus described the M/M/1 queue. The M stands for "Memoryless", or "Markovian" (nobody seems to know which+ ), and means for us that the process being represented by \(M\) comes

<!-- Pages 25-25 -->

from an exponential distribution. The first symbol, [A], in _Kendall notation_[Kendall53]

\[\text{A/B/}C\]

describes the arrival process, the second symbol, [B], describes the service distribution, and the third symbol, \([C]\), tells us how many servers there are in the subsystem. Thus we have a Poisson arrival process [A = M] to a single [\(C\) = 1] exponential server [B = M].

We next define the _utilization factor_ (or _utilization parameter_) to be

\[\rho:=\lambda\bar{x}_{1}=\frac{\bar{x}_{1}}{\bar{x}_{2}}. \tag{1.1.3}\]

Suppose, for instance, that customers need 9 minutes of service, on average, and that they are arriving at the rate of 6 per hour (or 10 minutes between arrivals, on average); then \(\rho=0.9\), and we would expect our server to be busy 90% of the time. Therefore, it will be idle \(1-\rho=0.1\), or 10% of the time. In Chapter 2, Equation (2.1.6b), we show that

\[\bar{q}=\frac{\rho}{1-\rho}\,,\] (1.1.4a) and from Little's formula \[\text{\textcir E}[T]=\frac{\bar{q}}{\lambda}=\frac{\bar{x}_{1}}{1-\rho}. \tag{1.1.4b}\]

According to these formulas, the average customer (remember, a very large number of customers has gone through) will arrive at a queue that already has nine other customers in it (including the one in service) and will have to wait 90 minutes (on average) from the time he arrives at the subsystem to the time he leaves. This behavior is represented in Figure 1.1.2 by the curve labeled M/M/1.

Before going on, we must clarify what is meant by "will see, on average," because in this case an arriving customer will see more than nine customers in the queue one-third of the time, and one-third of the time he will see three or fewer. In fact, he will see exactly nine customers less than 4% of the time. Actually we are still being loose with our words. What we really mean is that "a customer will find nine customers in the queue with a probability less than 0.04." More rigorously, we write the following:

\[\text{\textcir P}\!\text{r}(N=9)<0.04.\]

For averages, we use the following definition.

_Definition 1.1.3_.

Let \(N\) be a random variable denoting the number of customers an arriving customer finds in the queue. Then the _mean number of customers_ is given by

\[\text{\textcir E}[N]:=\sum_{n=0}^{\infty}n\text{\textcir P}\!\text{r}(N=n), \tag{1.1.5a}\]

<!-- Pages 26-26 -->

where for any function of \(N\) we say that

\[\operatorname{\mathbb{E}}[f(N)]:=\sum_{n=0}^{\infty}f(n)\operatorname{\mathbb{P} \!\!\operatorname{\mathbb{r}}}(N=n), \tag{1.1.5b}\]

is the _expected value_ (or _expectation value_) of \(f(n)\). We also use "_average value_" although it has a broader meaning in everyday usage. It is common notation in queueing theory books to use \(\bar{q}\) for \(\operatorname{\mathbb{E}}[N]\). We do so here. 

Because the precise terminology is so bulky, we tend to use the vague expressions that we hope we have clarified in this section. The reader should always be prepared to insert the precise wording when necessary.

Returning to the M/M/1 queue, we see an apparent contradiction. From an outside observer's (e.g., manager's) viewpoint, the server is idle (dawdling) 10% of the time, whereas from a customer's point of view, the queue is (almost) always very long. The explanation has to do with the unpredictability of arrivals and time for service, for sometimes customers will seem to come in bunches, and sometimes one customer will require far more than the average service time. For instance, the probability that 2 or more customers will arrive

Figure 1.1.2: Steady-state mean response times for various single-server queues. The horizontal axis is the utilization factor \(\rho\) from (1.1.3). The average arrival rate must be smaller than the service rate (\(\rho<1\)), otherwise the queue will back up indefinitely. All but two of the curves represent queues with Poisson arrivals, for which (1.1.6) is applicable. The squared coefficients of variation for the various service time distributions are \(C_{v}^{2}=0\) (M/D/1), \(C_{v}^{2}=1\) (M/M/1), and \(C_{v}^{2}=2,5,10\) (worse than exponential, \(G_{2}\), \(G_{5}\), \(G_{10}\)). The other two curves have _deterministic_ arrivals (the time between successive arrivals is constant) corresponding to the D/M/1 and D/D/1 queues, respectively. It is clear that all the curves blow up at \(\rho=1\).

<!-- Pages 27-27 -->

in one mean interarrival time, is greater than 26% \(\mathbf{Pr}(n\geq 2)=2/e\)], and 13% \((1/e^{2})\) of the customers will need more than twice the mean service time. These large fluctuations will cause the queue to back up at times. Once the queue backs up, it will be difficult for it to drain quickly. As an example, suppose that at some time there are 10 customers at \(S\). Then it will take about 90 minutes (on average) to service them. But in that time, approximately 9 new customers will arrive, and it will take another 81 minutes to satisfy them. So on and on it goes. The inverse question, "How long will it take to get 10 customers in the queue in the first place?" is also important. After all, some systems may not exist long enough to reach their steady state. In this case, (2.3.3b) tells us that we can expect over 13 hours to elapse before an observer will find 10 customers in the queue, and over 80 customers will have come and gone by then. We look at this transient behavior very closely throughout the book.

This very simplest of systems tells us that if you try to keep your server busy most of the time, you will have to pay for it in vastly degraded service to your customers. This has nothing to do with overworking your servers and thereby making them less efficient or tired or lazy. Nor is it due to the arrival of an unexpectedly large group of customers all at once. It is due entirely to the irregularity and unpredictability of arrivals and service demands. More complicated or more sophisticated or more realistic systems share this behavior; that is, they all depend on the term \(1/(1-\rho)\). Unfortunately, these explanations are not intuitively satisfying to the typical observer, despite their validity. Somehow, people always say, "If I were in charge, I would do things better." Even people who are in charge say it, but they say, "If I _really_ were

Figure 1.1.3: \(T\times(1-\rho)\) versus \(\rho\) for the same service distributions as in Fig 1.1.2. All but the D/M/1 queue (6) are straight lines, and all are finite at \(\rho=1\).

<!-- Pages 28-28 -->

in charge \(\ldots\)." This only points out all the more strongly that we, the human species, have extremely poor intuition concerning statistically fluctuating phenomena. This is all the more reason to have mathematical models to protect us from our faulty feelings. That is why the M/M/1 queue is so important even though it oversimplifies almost all real systems. However inaccurate it is, it is far more reliable than our intuition, because it contains that ubiquitous denominator, \(1-\rho\).

What, then, can be done to improve service? Obviously, more servers can be added (i.e., go to an M/M/\(C\) queue in Section 2.1.5, where \(C\) is the number of customers who can be served simultaneously), if more money is available. Alternatively, the behavior of the customers can be controlled for example, by not permitting them to demand much more service time than the average customer gets. ("Sorry, your time is up".)+ In the early 1930s, F. Pollaczek [20] and A. Y. Khinchine [17] separately studied the steady-state M/G/1 queue (the G means that the service distribution is _General_; i.e., it can be almost anything) and derived what has come to be known as the P-K formula, which we discuss in detail in Chapter 4. That formula [Equations (4.2.6)] shows that the mean number of customers waiting for service (including the one being served) depends only on their arrival rate \(\lambda\), and the mean (\(\bar{x}=\mbox{\sf E}\hskip-2.845276pt\mbox{\sf E}[X]\)) and _variance_ (of the service time distribution. It is usually expressed in terms of the _squared coefficient of variation_, \(C_{v}^{2}:=\sigma^{2}/\bar{x}^{2}\), as given here.

Footnote †: Note, however, that if this is done, not only will the fluctuations be reduced, but the mean service time will be reduced as well. Customers will not necessarily get what they came for.

\[\bar{q}:=\mbox{\sf E}\hskip-2.845276pt\mbox{\sf E}[N]=\rho+\frac{\lambda^{2}}{ 1-\rho}\cdot\frac{\mbox{\sf E}\hskip-2.845276pt\mbox{\sf E}[X^{2}]}{2}=\frac{ \rho}{1-\rho}+\frac{\rho^{2}}{1-\rho}\cdot\frac{C_{v}^{2}-1}{2}\:,\] (1.1.6a) The mean system time comes from Little's formula ( 1.1.2 ), using \[\rho=\lambda\bar{x}\] and \[\mbox{\sf E}\hskip-2.845276pt\mbox{\sf E}[T]=\frac{\bar{q}}{\lambda}=\bar{x}+ \frac{\lambda}{1-\rho}\cdot\frac{\mbox{\sf E}\hskip-2.845276pt\mbox{\sf E}[X^{ 2}]}{2}=\frac{\bar{x}}{1-\rho}+\frac{\rho\bar{x}}{1-\rho}\cdot\frac{C_{v}^{2} -1}{2}\:. \tag{1.1.6b}\]

These reduce to Equations (1.1.4) when \(C_{v}^{2}=1\). Equation (1.1.6a) shows that even if every customer were given exactly the same amount of service time (i.e., \(C_{v}^{2}=0\)), the mean queue length would only be reduced to half, and \(1-\rho\) is still in its denominator. Furthermore, if no constraint were placed on the customers with the greatest demands, the mean queue length (and mean waiting time) could become arbitrarily large (i.e., when \(C_{v}^{2}\gg 1\)). That is, there is no upper bound on how bad it could get. The mean system time from Equation (1.1.6b) for \(C_{v}^{2}=0\) is plotted in Figure 1.1.2 with the label _best of Poisson arrivals_ (M/D/1). The _worse cases_ are for various values of \(C_{v}^{2}\) greater than 1. There is no _worst_ case, because we can always find a service distribution with a larger \(C_{v}^{2}\).

A more convenient way to compare system times is to look at \(g(\rho):=(1-\rho)\mbox{\sf E}\hskip-2.845276pt\mbox{\sf E}[T]\), for this function does not blow up as \(\rho\) approaches 1. In fact, for

<!-- Pages 29-29 -->

M/G/1 queues, from (1.1.6b)

\[g(\rho)=\bar{x}+\rho\bar{x}\cdot\frac{C_{v}^{2}-1}{2}.\]

That is, \(g(\rho)\) is a straight line with \(g(0)=\bar{x}\) for all service time distributions, and \(g(1)=\bar{x}(C_{v}^{2}+1)/2\). This is seen in Figure 1.3. For G/M/1, and other queues, \(g(\rho)\) is not a straight line, but for well-behaved systems \(g(1)\) is still finite, as seen by the D/M/1 queue, labelled 6.

One way to modify the performance of a single steady-state queue is to control the arrival pattern of customers by, for instance, scheduling them to come at 10-minute intervals, as doctors and dentists do. In Chapter 5 we look at the G/M/1 queue and see that even if customers come exactly at their appointed times, the waiting time, [from Equation (5.1.7c)], will again only be cut approximately in half (again with a variant of \(1-\rho\) in its denominator), because of the uncertainty of how long service will take. This is shown in Figures 1.2 and 1.3 with the curve labeled _best of exponential servers_ (D/M/1) [12].

Only complete control of both arrivals and service times will yield the desired efficiency of no waiting. This is shown in Figure 1.2 by the horizontal line labeled _ideal_ (D/D/1). But in that case, will the customers get anything near what they came for? The job of queueing theorists is to analyze systems with given, or possible, performance characteristics as described by their arrival and service distributions. Optimally, we would prefer to leave the arrival and service demands (needs) alone and change the inanimate system characteristics. We leave it to the CEOs, politicians, management consultants, and other (so-called) efficiency experts to modify or control customer and server behavior to suit their goals.

Since the early 1970s, networks of queues have been studied and applied to numerous areas in computer science and engineering with a high degree of success. The basis for this success was due to Jackson [13] and Gordon and Newell [14], who showed that certain classes of steady-state queueing networks with any number of service centers could be solved using a _product-form solution_. Subsequently, Buzen [15] showed that the ominous-looking formulas the previous researchers had derived were actually computationally manageable, and thereafter the performance analysis of queueing networks began to blossom into a research field of its own. The theory has ultimately been extended to include, for instance, multiple classes, other service time distributions if the queueing discipline is not first-come, first-served (FCFS), and state-dependent routing [1]. _Jackson networks_, as they are now called, have been so successful in so many areas that it is hard to see where they do not apply. Their success lies in their ability to fit the measurements of any given queueing network. The reason is that the product-form solution has enough free parameters in it to fit anything (see Section 4.4.4). They also contain, hidden within them, the all-important denominator \(1-\rho\). The fact that it is hidden within the complex formalism can be valuable, because questioners are then unlikely to say "I can do better." One is far less likely to argue with the output of a sophisticated computer pro

<!-- Pages 30-30 -->

gram that requires an enormous amount of data input than with an algebraic formula or the verbal arguments of an "expert."

But the ability of Jackson networks to predict is an open question. It is important to emphasize that _they do not apply to systems where there are population size constraints_, or to _non-steady-state systems_, or _nonexponential servers with FCFS queueing discipline_. This book therefore goes in a direction orthogonal to that covered by Jackson networks. Only in Chapters 4 and 6 do we discuss the connection. We show in Section 4.4.4 in what sense they are not valid for FCFS M/G/1 queues. In Section 6.2.4 we introduce _generalized_ M/G/\(C//N\) networks and show that they reduce to (single-class) Jackson networks only when \(N\leq C\). The meaning of all this becomes clear as the reader goes through the book. At the moment it is only important for those already familiar with Jackson networks to realize that there is much in queueing theory that is not covered by Jackson networks.

As you might surmise from this discussion, just about everything that has been done in queueing theory has assumed the steady state. Very little is known about transient behavior, for one of two reasons. We do not know which of these two statements is valid:

1. Transient behavior is unimportant; therefore, it is not studied.
2. Transient behavior is too difficult to measure and analyze; therefore, it is declared to be unimportant.

A growing number of researchers (including this author) have "declared" that transient behavior should be considered important (see, e.g., [10]); therefore, we devote a considerable amount of space and effort in each chapter to its analysis. If it should no longer prove too difficult to study, perhaps more researchers will agree that it is important.

#### Markov Property

The reader is not expected to know anything special about Markov chains, the property that Markov introduced and built on in 1907 [17]. It is, however, an important underpinning of the approach expounded here. There are many books that cover this in detail at multiple levels, from basic (e.g., [12], [13], and [14], and many more) to advanced (e.g., [15], [16], and [17]). We assume that the reader already has some passing knowledge of the subject, but we introduce concepts as needed.

We first describe what we mean by a _state_. A complete specification of a system or subsystem is collectively called a state. No two states can have the same complete specification; therefore, they must differ in at least one aspect. For example, for the purposes of coin-flipping, a coin can be in only one of two states, heads or tails. Two coins, collectively, can be in one of three states, _HH_, _HT_, or _TT_. So after the flips we could say (assuming it is true) that "the system is in state _HT_." We also use the word to describe the probability that the flips will result in one state or another. That is, we could say before

<!-- Pages 31-31 -->

the flips (or without having seen the results) that "the system is in state \(\mathbf{p}\)," where

\[\mathbf{p}=[\,0.25\,,\ 0.50\,,\ 0.25\,],\]

corresponding to the probability for each of the three states to occur. If we must make a distinction, we will call the former a _pure state_, and the latter a _composite state_. We will also refer to the triplet of values, \(\mathbf{p}\), as a _state vector_. Now you might ask if _HT_ is completely specified, because it could have been _ht_ or _th_. From the coin flipping game point of view, or if we cannot tell which coin is which, there is only the one _external state_, \(HT\), but it has two _internal states_. The other two external states, _HH_ and _TT_, have only one internal state each. The set of internal states corresponding to an external state is referred to as its _state space_. Thus we say that

\[\Xi_{HT}\ :=\ \{\,ht\,,\,th\,\}\]

or that "\(ht\) is an element of \(\Xi_{HT}\)," written

\[ht\ \in\Xi_{HT}\,.\]

If this seems confusing, it should become clearer over time, because we use these terms regularly. For instance, suppose that we are studying a subsystem, represented by the symbol \(S\). If we could look inside we would see, say, three exponential servers (which we call _phases_). Next suppose that only one customer can be inside the subsystem at a time, and there are five customers there altogether (one inside and four outside). Then we say that the subsystem is in external state [5] and that the system has three internal states. We might write \(\Xi_{5}=\{1,2,3\}\).

In general, the sum of probabilities of being in a set of internal states with the same external state will be the probability of being observed in that external state. This is quite analogous to the terms "sample" and "event" used in many probability texts, where an event is a set of samples, and the probability of an event is the sum (or integral) of probabilities over the sample points [10]. In our case, the external states are mutually exclusive, and the internal states (sample points) may not be individually measurable or even physically meaningful (we may not always be allowed to look inside \(S\)). Even so, we use the rather picturesque description of customers meandering, sometimes with negative probabilities, through networks of exponential servers (phases), whose service times may be complex numbers. Even if this annoys the realist within each of us, it helps us to picture and remember the process being discussed and to distinguish it from similar processes that might also be of interest. But in the end, the mathematical conclusions must be correct if the theory is to be meaningful.

Suppose that a system can be completely described as being in one of a countable (either finite or infinite) number of states. The set of states is discrete, thus the system cannot gradually go from one state to another. Therefore at a later time it will hop to another of those states. In time, then, the history of the system can be described by a sequence of states. Such a sequence

<!-- Pages 32-32 -->

is called a _chain_. The Markov property states that the probability that the system will be in a particular state at the next moment of time (i.e., after the next hop) depends only on the state it is in now, not where it was previously. A _Markov chain_ is a sequence of states generated by a process that satisfies the Markov property. This abstract idea becomes meaningful once we look at some simple systems. For now we give the formal definition of a discrete Markov chain.

_Definition 1.1.4_.: Let \(\Xi\) be a countable set of states. Furthermore, let \(\boldsymbol{\mathcal{S}}=\{I_{\mathrm{o}},\,I_{1},\,I_{2},\,\ldots,\,I_{n},\,\ldots\}\) be a discrete sequence of random variables, each of which takes its values from \(\Xi\). In general we might expect that the value \(I_{n}\) takes on would depend on the values taken by \(I_{\mathrm{o}}\) through \(I_{n-1}\). But if

\[\begin{array}{l}\boldsymbol{\mathbbm{Pr}}(I_{n}=\ell_{n}\,|\,I_{\mathrm{o}}= \ell_{\mathrm{o}},\,I_{1}=\ell_{1},\,\cdots,\,I_{n-1}=\ell_{n-1})\\ \\ \qquad\qquad=\boldsymbol{\mathbbm{Pr}}(I_{n}=\ell_{n}\,|\,I_{n-1}=\ell_{n-1}), \end{array}\]

where \(\ell_{k}\in\Xi\), then \(\boldsymbol{\mathcal{S}}\) is a _discrete Markov chain_. 

Although not all aspects of queueing theory are described by Markov processes, there are few known analytical techniques that go beyond the Markov property. Thus we should say a few words about the so-called _memoryless_ property. Only a system with one state is truly memoryless. (See Section 1.2.1). A system can be extended to include pseudostates that serve the purpose of "remembering" some of the past. It is not uncommon to construct such states even though they are not observable, as long as the formalism is maintained.

The question then is: "what is a non-Markovian system?" This can be answered in the following way. In general, a system's future behavior depends on its entire past history and thus it must "remember" everything. A Markovian system, on the other hand, can remember only a part of its history and thus must discard old information as new events occur. Two points follow directly from this idea. First, for short amounts of time (depending on the size of the state space), a Markovian model would be an excellent representation of a non-Markovian system.

Over long periods of time, however, a Markovian system will forget its initial state and thus would be a poor approximation for those systems that do depend on their initial state.

#### Notation, Pronouns, Examples

The following notational standards are adhered to as closely as possible. All matrices (two-subscripted arrays) are represented by boldface capital letters (e.g., \(\mathbf{M}\)), while their components are noted in either of two ways, \(M_{ij}\) or \((\mathbf{M})_{ij}\), depending on the context. Similarly, all vectors (single-subscripted arrays) are represented by boldface lowercase letters [e.g., \(\mathbf{v}\) has components \(v_{i}\) or \((\mathbf{v})_{i}\)]. Row vectors and column vectors play distinctly different roles

<!-- Pages 33-33 -->

in the formalism presented here. As in many books on matrix theory, the symbol "\({}^{\prime}\,\)", means _transpose_, but we are always interested in an object or its transpose, never both, so \(\mathbf{v}^{\prime}\) always denotes a column vector. Sometimes we discuss a set of vectors or matrices, such as \(\{\mathbf{v}_{1},\mathbf{v}_{2},\mathbf{v}_{3}\}\). In this case, the subscripts are also set in boldface type. So the \(j\)-th component of the \(i\)-th vector is \((\mathbf{v}_{i})_{j}\).

We also strictly adhere to the following convention on the use of pronouns. We are always talking about "customers", the "author", _random observer_ (or _outside observer_), "servers" (or "service centers" or "subsystems"), and the "reader". To minimize the ambiguity, we always refer to the reader as "you"; a customer is "he"; an observer (random or outside) is "she;" and a "server" (service center, or subsystem), is "it." Thus the following statement has an unambiguous meaning: "_We_ point out to _you_ that _she_ sees _him_ enter _it_." Translation: "The reader should note that the observer sees the customer enter the subsystem." However she may not be able to see what he does after he enters (although she might figure out what he is _probably doing_).

All equations, definitions, figures, examples, and exercises are numbered in sequence by chapter and section (but not subsection). Thus "Figure 2.3.4" is the fourth figure in Section 2.3. Also, "(4.1.13d)" is the fourth [d] equation in the thirteenth set of equations in Section 4.1, whereas "Equations (4.1.13)" refers to all four of (4.1.13a), (4.1.13b), (4.1.13c), and (4.1.13d). Note that an object such as "(4.1.13)" without a qualifier always refers to an equation. Otherwise we say "Definition 4.5.7," and so on. Since lemmas are really theorems, and both can have corollaries, we have chosen to number them together in a single sequence. Thus we have Lemma 4.2.1, Theorem 4.2.2, and Corollary 4.2.2, but no Theorem 4.2.1. Clearly, Corollary 4.2.2 is a corollary to Theorem 4.2.2.

To help the reader quickly locate a word or phrase from the index, such objects usually appear on the page referenced in _bold-faced, italic font_. This is particularly true if the term is defined or extensively discussed there.

We have given many examples throughout the book, most of them involving numerical computation, invariably summarized by a family of curves in a graph. Most of the exercises we have asked the student to perform are proofs or other mathematical manipulations. The examples can easily be made into exercises by having the student redo the example using a different distribution function. In a class environment, each student can be assigned a different function. Then a comparison study can be made by the class as a whole to see how the different functions affect the particular phenomenon being studied.

### Distribution Functions Over Time

We use the word _system_ in referring to a closed entity, one in which customers neither enter nor leave. Yet we often use _closed system_ to retain clarity. On the other hand, a _subsystem_ is one to which customers come and go. The simplest of all subsystems has only one state, with at most one customer. Then that state is either occupied or unoccupied. In the next two sections we

<!-- Pages 36-36 -->

It is common practice to use \(\bar{t}\) for \(\mbox{\sf E}\!\left[T\right]\). We often do that here, but will generally avoid expressions such as \(\bar{t}^{2}\). Also, both letters, \(x\) and \(t\), will be used as the time variable. We try our best not to use \(\bar{x}\) and \(\bar{t}\) in the same context.

Another much used function is the _variance_, symbolized by \(\sigma^{2}\) and defined by

\[\sigma^{2}:=\mbox{\sf E}\!\left[(T-\mbox{\sf E}\!\left[T\right])^{2}\right]= \int_{\rm o}^{\infty}\left(t-\bar{t}\right)^{2}f(t)\,dt\] (1.2.4a) which can be shown to be equal to \[\sigma^{2}=\mbox{\sf E}\!\left[T^{2}\right]-\mbox{\sf E}\!\left[T\right]^{2}= \mbox{\sf E}\!\left[T^{2}\right]-\bar{t}^{2}. \tag{1.2.4b}\]

The _standard deviation_ of \(f(t)\) is symbolized by \(\sigma\), which satisfies the obvious, \(\sigma:=\sqrt{\sigma^{2}}\). In words, \(\sigma\) is a measure of the \(spread\) about the mean; the smaller \(\sigma\) is, the narrower the distribution. We usually deal with functions that are defined only for positive \(t\), therefore a relative width is often useful. Hence we have the _coefficient of variation_, whose square is defined by

\[C_{v}^{2}\ =\frac{\sigma^{2}}{(\mbox{\sf E}\!\left[T\right])^{2}}. \tag{1.2.4c}\]

We hope this discussion has not brought on more confusion than it has allayed. We have found that trivial notational problems such as these often prevent understanding of expressions with which the reader would otherwise have no trouble.

Let us return to where we were before the pause. Continuing from (1.2.1b) and (1.2.2a), the pdf for the exponential distribution is

\[f(t)\ =-\frac{dR(t)}{dt}\ =\mu\ e^{-\mu t}.\] (1.2.5a) The mean lifetime for the process is \[\mbox{\sf E}\!\left[T\right]:=\int_{\rm o}^{\infty}t\,f(t)\,dt=\int_{o}^{ \infty}t\,\mu\,e^{-\mu\,t}\,dt=\frac{1}{\mu}. \tag{1.2.5b}\]

The reciprocal of the mean lifetime, in this case \(\mu\), is interpretable as the _service rate_, or the rate of leaving. The \(n\)-th moment for the exponential distribution is

\[\mbox{\sf E}\!\left[T^{n}\right]=\frac{n!}{\mu^{n}}\,. \tag{1.2.5c}\]

The variance is \(\sigma^{2}=1/\mu^{2}\) and the squared coefficient of variation \(C_{v}^{2}=1\).

Finally, we show that exponential distributions have the memoryless property [the reverse of what we did to get (1.2.1)]. Let \(T\) be the random variable denoting the time that the subsystem stops being active. Suppose that the subsystem has been actively servicing the customer for some time, \(t\). What is the probability that it will continue to be active more than a further time \(x\)? By definition

\[R(t+x)=\mbox{\sf P}\!\left[\mbox{\sf P}\!\left[T>t+x\right]\right.\]

<!-- Pages 38-38 -->

with probability \(p\). If \(R_{\rm o}=1\), then \(R_{1}=p\) and \(R_{2}=pR_{1}=p_{2}\). In general, the probability \(R_{n}\) that it will still be busy by the \(n\)-th step is equal to \(p\cdot R_{n-1}\), from which it follows that

\[R_{n}=p^{n}. \tag{1.2.7a}\]

\(R_{n}\) is the discrete analogue of \(R(t)\), so we could call it the _discrete reliability function_. The analogue to \(f(t)\) (sometimes called the _probability mass function_ or _discrete density function_), symbolized by \(f_{n}\), is the probability that the server will finish in exactly \(n\) steps. It is known that \(b_{n}\) is the _geometric distribution_, or the negative binomial distribution of order \(1\), but we calculate it here by doing the analogue of differentiation:

\[f_{n}\ =R_{n-1}-R_{n}=(1-p)p^{n-1}. \tag{1.2.7b}\]

Let \(N\) be the random variable denoting the number of steps taken before completion. Then

\[{\rm\kern 1.2pt\vrule height 6.0pt depth 0.0pt width 0.4pt\kern-3.0ptE}[N]=\sum_{n=1}^{ \infty}n\,f_{n}=(1-p)\sum_{n=1}^{\infty}n\,p^{n-1}=\frac{1}{1-p}\,. \tag{1.2.7c}\]

Equation (1.2.1b) and Equations (1.2.5) are much closer to Equations (1.2.7) than it would seem by superficial examination. Suppose that although time is a continuous parameter, the system of Section 1.2.1 is examined only at regular intervals, as with the cinema or video. Let \(\delta\) be the time between snapshots. Then \(t=n\delta\). Using this in (1.2.1b), we get

\[R(t)=e^{-\mu\delta}=\left(e^{-\mu\delta}\right)^{n}. \tag{1.2.8a}\]

Let \(p=e^{-\mu\delta}\); then \(R(t)=R_{n}\). At least as far as the reliability function is concerned, a discrete time system is indistinguishable from a continuous-time system in which observations are made at regular intervals. Equations (1.2.5b) and (1.2.7c) do not yield identical values, but the following inequality is satisfied.

\[\delta\left({\rm\kern 1.2pt\vrule height 6.0pt depth 0.0pt width 0.4pt\kern-3.0ptE}[N]-1 \right)<{\rm\kern 1.2pt\vrule height 6.0pt depth 0.0pt width 0.4pt\kern-3.0ptE}[T]<\delta\,{\rm\kern 1.2pt \vrule height 6.0pt depth 0.0pt width 0.4pt\kern-3.0ptE}[N]. \tag{1.2.8b}\]

The proof follows directly by substituting for \(p\) and letting \(u=\mu\delta\). Then (1.2.8b) converts [after multiplying all terms by \((e^{u-1})/\,\delta\)] to the inequality

\[1<\frac{e^{u}-1}{u}<e^{u},\quad\mbox{ for }\,u>0.\]

Equation (1.2.8b) says that the uncertainty in \({\rm\kern 1.2pt\vrule height 6.0pt depth 0.0pt width 0.4pt\kern-3.0ptE}[T]\), when measured to the nearest (rounded up) multiple of \(\delta\), is less than one time unit, which is as close as a discrete and continuous system can come to each other. This is true even for more general systems, where the strict inequality may be replaced by \(\leq\).

### 1.3 Chapman-Kolmogorov Equations

We now consider a system that has many states of possible existence. In Chapter 2, when we deal with queues the states are explicitly described. For

<!-- Pages 39-39 -->

now it is sufficient to consider a state to be one possible complete specification of the system's condition. The system can be in one and only one state at a time, and in the course of time it will change from one state to another. The set of all possible states is called the _state space_. Probability books often identify these with _samples_ in a _sample space_. If the space is finite, or at most countably infinite, we have a _discrete state space_. We are interested exclusively in systems with discrete state spaces. As our system evolves in time, it must "jump" from one state to the next, because there is no continuum of states in a discrete space to match the continuous time parameter. A sequence of such states is called a _chain_, and if the Markov property holds, we have a _Markov chain_. Of course, time can be continuous or discrete, giving a _continuous Markov chain_ or _discrete Markov chain_. If the state space is uncountable, change _chain_ to _process_.

#### Continuous Time

As with most expositions purporting to start from scratch, the first few sections are overladen with definitions. Let \(i\) and \(j\) take on positive integer values, corresponding to the possible states of the system. Then

_Definition 1.3.1_.:

\(\Xi\ :=\ \{i\mid i\,\text{is a state of the system}\}\). We read this as: "\(\Xi\) is the set of all \(i\), such that i is a state of the system." We also call \(i\) a _pure state_ of the system. If \(\Xi\) is a finite set of states with, say, \(m\) members (i.e., \(m=|\Xi|\)), we can write \(1\leq i\leq m\), or \(i\in\Xi\) (\(i\) is an element of \(\Xi\)). 

Next, define the following.

_Definition 1.3.2_.:

\(\pi_{i}(t):=\) _probability that the system will be in state \(i\in\Xi\) at time \(t\). \(\pi(t)\)_ is an \(m\)-dimensional row vector whose \(i\)-th component is \(\pi_{i}(t)\), and is called the _state probability vector_ or just the _probability vector_. \(\pi(0)\) is referred to as the _initial state of the system_. 

We often say that "the system is in state \(\pi\)" when we mean that "the system is in state \(i\in\Xi\) with probability \(\pi_{i}\)." If a distinction between the two ideas is necessary, we say that the system is in _composite state_\(\pi\), as opposed to _pure state_ i. In this case, \(\pi_{j}=\delta_{ij}\), where \(\delta\) is defined as follows.

_Definition 1.3.3_.:

The _Kronecker delta_ has the values

\[\delta_{ij}\ =\left\{\begin{array}{ll}0&\text{for}\quad i\neq j\\ 1&\text{for}\quad i=j\end{array}\right..\]

It can be thought of as the \(ij\)-th component of the identity matrix. 

The movement of the system from state to state is governed by the following.

<!-- Pages 40-40 -->

**Definition 1.3.4**: \(P_{ij}:=\) _probability that the system will jump to \(j\in\Xi\) upon leaving state \(i\in\Xi\). The matrix \(\mathbf{P}\), defined by \((\mathbf{P})_{ij}=P_{ij}\), is called a **transition matrix** if \(P_{ij}\geq O\) and \(\sum_{j=1}^{m}P_{ij}\leq 1\) for all \(i\) and \(j\). It is also referred to as a **Markov matrix** or a **stochastic matrix** if \(\sum_{j=1}^{m}P_{ij}=1\). If \(\sum_{j=1}^{m}P_{ij}<1\) for some \(i\), then \(\mathbf{P}\) is called a **substochastic matrix**. Formally we follow Definition 1.1.4 and write

\[P_{ij}=\mathbf{P}\!\mathbf{r}(I_{n}=j\,|\,I_{n-1}=i).\]

We assume that transition probabilities are independent of how long the process was running. That is, \(\mathbf{P}\) is independent of \(n\), (i.e., the number of steps that have already been made). This is known as a _stationary process_[10].

Because a system, by definition, is closed, the sum of probabilities of all possible jumps must be \(1\). That is,

\[\sum_{j=1}^{m}P_{ij}\ =\ 1.\] (1.3.1a) By introducing the special row vector, \[\boldsymbol{\epsilon}:=[\ 1,\ 1,\ 1,\ \cdots\,\ 1]\,,\] with \[\boldsymbol{\epsilon^{\prime}}\] being the **transpose** (i.e., column vector) of \[\boldsymbol{\epsilon}\], ( 1.3.1a ) can be rewritten in matrix form as \[\mathbf{P}\boldsymbol{\epsilon^{\prime}}=\boldsymbol{\epsilon^{\prime}}.\] (1.3.1b) Many matrices in this book have this property so we give it a special name.

**Definition 1.3.5**: Any matrix that satisfies ( 1.3.1b ) is called an _isometric matrix_. Thus \(\mathbf{P}\) is _isometric_. Using an extended view of the definition, we can say that \(\boldsymbol{\epsilon^{\prime}}\) itself is isometric, because its row sum (only one term) is \(1\). In Section 3.4.2 we give an extended rationale for this nomenclature when we show that many formulas are invariant to isometric transformations.

Note that ( 1.3.1b ) is a matrix equation, whereas ( 1.3.1a ) looks explicitly at the components. The reader need not be concerned at the moment with the subtle distinction we are trying to makei here. However, as the book evolves, we will tend to ignore the properties of the individual matrix elements. It is the matrix as a whole that operates on the system's present state vector and changes it to the future state vector. Therefore, we almost never make use of the property \(P_{ij}>0\). However, we are always concerned to see if a matrix is isometric, for this is an algebraic property of the matrix. When we prove that a square matrix is isometric, the reader is welcome to think of it as being a stochastic matrix, but we seldom prove it.

<!-- Pages 41-41 -->

We next derive the generalization of (1.2.1a), keeping in mind that the system can go to any state, including the one it is in presently, or one it previously visited. However, not only is there more than one server, but there are two time parameters. \(t\) is the time from when the process began being observed, and \(x\) is the time since the last event occurred. Without the memoryless assumption, it would be almost impossible to find a solvable analytic formulation. Therefore, \(R_{i}(\delta|t,x)\) (the probability that the system will be in state \(i\) at time \(t+\delta\), given that it was in state \(i\) at time \(t\) and has been there continuously for a time interval \(x\)) reduces to \(R_{i}(\delta)\). With this understood, we have

\[\pi_{i}(t+\delta)=\pi_{i}(t)R_{i}(\delta)+\sum_{j}\pi_{j}(t)[1-R_{j}(\delta)]P _{ji}+O(\delta^{2}).\]

In words, the probability that the system will be in state \(i\) at time \(t+\delta\), \([\pi_{i}(t+\delta)]\), is equal to the probability that it was in state \(i\) at time \(t\,[\pi_{i}(t)]\), and has remained there for time \(\delta\,[R_{i}(\delta)]\), plus the sum of probabilities that it was in some other state, \(j\) (including \(i\)), at time \(t\,[\pi_{j}(t)]\), left that state within the interval \(\delta\), \([1-R_{j}(\delta)]\), and went to \(i\,[P_{ji}]\), plus multiple transitions \([O(\delta^{2})]\). As with the derivation of (1.2.1a), replace \(R_{i}\) with its Taylor expansion, subtract \(\pi_{i}(t)\) from both sides of the equation, divide by \(\delta\) and take the limit for \(\delta\) goes to \(0\), and get

\[\frac{d\pi_{i}(t)}{dt}=\sum_{j}\pi_{j}(t)\mu_{j}P_{ji}-\pi_{i}(t)\mu_{i}.\] (1.3.2a) This is one form of the _Chapman-Kolmogorov (C-K) equation_. It can be expressed more elegantly as a matrix equation in the following way. We have already defined the row vector: \[\boldsymbol{\pi}(t):=\ [\pi_{1}(t),\pi_{2}(t),\cdots],\] and now introduce a diagonal matrix.

_Definition 1.3.6_.

\((\textbf{M})_{ij}=\mu_{i}\delta_{ij}\), _where \(\delta_{ij}\), is the Kronecker delta_ defined above. In other words, \(M\) is a diagonal matrix, with diagonal elements \(M_{ii}=\mu_{i}\), where \(\mu_{i}\) is the rate of leaving state \(i\). \(M\) is called the _completion rate matrix_. It is also referred to as the _holding rate matrix_, but that term is not used here. 

We now can rewrite (1.3.2a) as

\[\frac{d\boldsymbol{\pi}(t)}{dt}=\boldsymbol{\pi}(t)\textbf{M}\textbf{P}- \boldsymbol{\pi}(t)\textbf{M}=-\boldsymbol{\pi}(t)\textbf{Q}, \tag{1.3.2b}\]

where the _transition rate matrix_ (also called the _infinitesimal rate matrix_, or simply _rate matrix_) \(Q\), is defined by

\[\textbf{Q}:=\textbf{M}(\textbf{I}-\textbf{P}). \tag{1.3.2c}\]

<!-- Pages 42-42 -->

Although equivalent to the usual definition (most researchers define \(-\boldsymbol{Q}\) as the transition rate matrix), \(\boldsymbol{Q}\) is given in a somewhat different form because we have separated the process of leaving a state \([\boldsymbol{M}]\) from that of deciding which state to go to next \([\boldsymbol{P}]\). This is most useful to us in succeeding chapters. \(\boldsymbol{M}\) governs the time between events and \(\boldsymbol{P}\) controls what happens when an event occurs. Thus we can look at the behavior of systems conditioned by the occurrence of specific events. For instance, in Chapter 4 we not only study the steady-state probabilities of finding an M/G/1 queue in a given state, but also analyze the probabilities of being in a given state after a departure or after an arrival.

Let us define \(\mathbf{o}\) to be the row vector of all \(0\)s. It is clear from (1.3.1b) and (1.3.2c) that \(\boldsymbol{Q}\,\boldsymbol{\epsilon}^{\prime}=\mathbf{o}^{\prime}\), so upon multiplying (1.3.2b) from the right with \(\boldsymbol{\epsilon}^{\prime}\), it follows that

\[\frac{d}{dt}[\boldsymbol{\pi}(t)\,\boldsymbol{\epsilon}^{\prime}]=0. \tag{1.3.2d}\]

In other words, \(\boldsymbol{\pi}(t)\,\boldsymbol{\epsilon}^{\prime}\) is a constant that we may presume to be \(1\) for all \(t\), because

\[\left[\boldsymbol{\pi}(t)\boldsymbol{\epsilon}^{\prime}\right]_{t=\mathrm{o}} =\sum_{i}\pi_{i}(0)=1\]

This is no more than would be expected in a closed system.

The solution to (1.3.2b), another form of the C-K equation, is the matrix equivalent of (1.2.1b), namely

\[\boldsymbol{\pi}(t)=\boldsymbol{\pi}(0)\boldsymbol{G}(t), \tag{1.3.2e}\]

where

\[\boldsymbol{G}(t)\,=\exp(-t\,\boldsymbol{Q}).\] (1

<!-- Pages 45-45 -->

**Exercise 1.3.4:** A simple example of both (1) and (2) is given by

\[\boldsymbol{P}=\left[\begin{array}{cccc}0&1&0&0\\ 0&1&0&0\\ 0&0&0&1\\ 0&0&1&0\end{array}\right].\]

Find the eigenvalues and eigenvectors of \(\boldsymbol{P}\). Clearly, states 1 and 2 are disjoint from 3 and 4, and state 1 is transient.

#### Time-Dependent and Steady-State Solutions

As you may have seen from Exercise 1.3.3, (1.3.2e) is not as explicitly useful as it seems. More useful solutions of this are covered in depth in the literature. We discuss it slightly here, enough to see how \(\boldsymbol{\pi}(t)\) varies with time, and do some examples in detail in Chapter 2. First we review a little matrix theory.

##### 1.3.3.1 Some Properties of Matrices

The _eigenvalues_ of a matrix (also called _proper values_, or _characteristic values_) \(\mathbf{X}\) are the roots of its _characteristic equation_,

\[\phi(\lambda)\ :=\mid\lambda\mathbf{I}-\mathbf{X}\mid=0, \tag{1.3.6}\]

where \(\mid\cdot\mid\) denotes the _determinant_ of any square matrix. In other words, \(\lambda_{i}\) is an eigenvalue of \(\mathbf{X}\) if and only if it is a root of \(\phi(\lambda)\) [i.e., \(\phi(\lambda_{i})=0\)]. If \(\mathbf{X}\) is of finite dimension, say \(m\), then \(\phi(\lambda)\) is a polynomial of degree \(m\), with \(m\) roots. If a particular root appears more than once, it is a _multiple root_, and we say there is a _degeneracy_ in that eigenvalue. Otherwise, it is a _simple root_.

Corresponding to each \(\lambda_{i}\) is at least one _left eigenvector_ and one _right eigenvector_ (also called _proper vector_), satisfying the following.

\[\mathbf{u_{i}}\mathbf{X}=\lambda_{i}\mathbf{u_{i}}\quad\text{ and }\quad\mathbf{X}\, \mathbf{v_{i}^{\prime}}=\lambda_{i}\mathbf{v_{i}^{\prime}}.\] (1.3.7a) For any square matrix the number of right eigenvectors belonging to each eigenvalue is greater than or equal to one, and less than or equal to the degree of multiplicity of that root. If the number of eigenvectors belonging to a given eigenvalue is strictly less than the degree of multiplicity of that root, then the matrix is said to be a _defective matrix_. There are as many left as there are right eigenvectors, and they satisfy the following _orthogonality condition_: \[\mathbf{u_{i}}\mathbf{v_{j}^{\prime}}=0\quad\text{ for }\quad\lambda_{i}\neq\lambda_{j}.\] (1.3.7b) This condition guarantees that eigenvectors belonging to different eigenvalues are automatically linearly independent. The general case can be treated with some difficulty, but for now assume that the \[\lambda_{i}^{\prime}\]s are distinct. Then the set of

<!-- Pages 46-46 -->

left (or right) eigenvectors forms a complete set. That is, every \(m\)-dimensional row (column) vector can be written as a linear combination of left (right) eigenvectors. Then we say that each eigenvector is a _basis vector_, and the set of left (right) eigenvectors is a _basis set_ for all row (column) vectors.

It can also be assumed that

\[\mathbf{u_{i}}\mathbf{v^{\prime}_{i}}=1. \tag{1.3.7c}\]

Note that each \(\mathbf{u_{i}}\) is a row vector with \(m\) components \([(\mathbf{u_{i}})_{k},1\leq k\leq m]\) and that each \(\mathbf{v^{\prime}_{i}}\) is a column vector, also with \(m\) components. Consider the \(m\times m\) matrices

\[(\mathbf{U})_{ik}:=(\mathbf{u_{i}})_{k}\]

and

\[(\mathbf{V})_{ki}:=(\mathbf{v^{\prime}_{i}})_{k}.\]

Equations (1.3.7) imply that \(\mathbf{U}\) and \(\mathbf{V}\) are inverses of each other, (i.e., \(\mathbf{U}\,\mathbf{V}=\mathbf{V}\,\mathbf{U}=\mathbf{I}\)).

If all the eigenvalues of \(\mathbf{X}\) are distinct, the _spectral decomposition theorem_ states that (where \(m\) is the dimension of \(\mathbf{X}\))

\[\mathbf{X}=\sum_{i=1}^{m}\lambda_{i}\mathbf{v^{\prime}_{i}}\,\mathbf{u_{i}} \quad\text{ and}\quad\mathbf{I}=\sum_{i=1}^{m}\mathbf{v^{\prime}_{i}}\,\mathbf{u_{i}}.\] (1.3.8a) Note that whereas \[\mathbf{u_{i}}\,\mathbf{v^{\prime}_{j}}=\sum_{k=1}^{m}(\mathbf{u_{i}})_{k}\,( \mathbf{v^{\prime}_{j}})_{k}\]

(_inner, dot_ or _scalar product_) is a scalar, the object \(\mathbf{v^{\prime}_{j}}\,\mathbf{u_{i}}\) (_outer product_) is an \(m\)-dimensional matrix of rank \(1\), where all rows are proportional to each other and to \(\mathbf{u_{i}}\). That is, \((\mathbf{v^{\prime}_{j}}\,\mathbf{u_{i}})_{kl}=(\mathbf{v^{\prime}_{j}})_{k}\, (\mathbf{u_{i}})_{l}\). It follows from the orthogonality conditions above that

\[\mathbf{X}^{k}=\sum_{i=1}^{m}\lambda_{i}^{k}\mathbf{v^{\prime}_{i}}\,\mathbf{ u_{i}} \tag{1.3.8b}\]

and more generally,

\[f(t\mathbf{X})=\sum_{i=1}^{m}f(t\lambda_{i})\mathbf{v^{\prime}_{i}}\,\mathbf{ u_{i}}, \tag{1.3.8c}\]

where \(f(x)\) is any function expressible in a Maclaurin series. Theorem 1.3.1 follows directly from this.

We make a final comment in this section that will be useful in Chapter 3. Each of the eigenvectors, \(\mathbf{u_{i}}\) and \(\mathbf{v^{\prime}_{i}}\) of (1.3.7a) is determined by a homogeneous equation. Thus if \(\mathbf{u_{i}}\) satisfies (1.3.7a) so does \(c\mathbf{u_{i}}\), where \(c\neq 0\). Similarly with \(c^{\prime}\mathbf{v^{\prime}_{i}}\). The product of the constants can be determined by (1.3.7c). That is, let \(\mathbf{\bar{u}_{i}}\) and \(\mathbf{\bar{v}^{\prime}_{i}}\) be the computed solutions to (1.3.7a) for eigenvalue \(\lambda_{i}\), but

<!-- Pages 48-48 -->

**Theorem 1.3.3:** Let a system \(S\) have \(m\) states. The time spent in state \(i\) is exponentially distributed with parameter \(\mu_{i}\). Let \(\boldsymbol{\pi}(t)\), \(\boldsymbol{P}\) and \(\boldsymbol{M}\) be as described in Definitions 1.3.2, 1.3.4, and 1.3.6, respectively. Define \(\boldsymbol{Q}\) as in (1.3.2c). Then \(\boldsymbol{\pi}(t)\) evolves in time according to (1.3.9c). It approaches its limit \(\boldsymbol{\pi}\) as \(t\) approaches \(\infty\). \(\boldsymbol{\pi}\) satisfies (1.3.9a), which can be rewritten in the following way.

\[\boldsymbol{\pi M}=\boldsymbol{\pi M}\boldsymbol{P}.\]

This is called the (vector) _steady-state balance equation_ (or just _vector balance equation_, and \(\boldsymbol{\pi}\) is the _steady-state vector_. This equation has the following physical interpretation. \(\pi_{i}\mu_{i}\) (the \(i\)-th component of vector \(\boldsymbol{\pi M}\)) is the _probability rate_ of leaving state \(i\). \(\sum_{j=1}^{m}\pi_{j}\,\mu_{j}\,P_{ji}\) (the \(i\)-th component of the vector \(\boldsymbol{\pi M}\boldsymbol{P}\)) is the probability rate of entering state \(i\) from all other states. The equality of the two flows, together with \(\boldsymbol{\pi\epsilon^{\prime}}=1\), uniquely determines \(\boldsymbol{\pi}\). \(\blacksquare\)

Before going on, we note that if the set of states can be partitioned into two subsets, such that there is no way to get from one subset to the other, then \(\lim_{t\to\infty}\boldsymbol{\pi}(t)\) depends on the probability that the system began in one subset or the other. But this also implies that the eigenvalue \(0\) is degenerate, and there are at least two left eigenvectors with eigenvalue \(0\), call them \(\boldsymbol{\pi_{1}}\) and \(\boldsymbol{\pi_{2}}\). In other words, \(\lim_{t\to\infty}\boldsymbol{\pi}(t)=a\boldsymbol{\pi_{1}}+(1-a)\boldsymbol{ \pi_{2}}\). It is not hard to see that if such a partition exists, we can treat both subsets independently and solve them separately. Therefore, we can assume that our system is connected (i.e., _irreducible_), so the \(0\) eigenvector \(\boldsymbol{\pi}\) is unique.

The question, "How long will it take to get to the asymptotic region?" is not easy to answer, but one rule of thumb involves the _relaxation time_ (\(RT\)) [10], (also called the settling time) defined by

\[\frac{1}{RT}:=\min_{i=2}^{m}[\Re(\lambda_{i})]. \tag{1.3.11}\]

In words, list the real parts of all the eigenvalues of \(\boldsymbol{Q}\). (They all must be positive, or else we are in trouble.) Pick the smallest one. Then the reciprocal of that number is \(RT\). If \(t\) is much greater than \(RT\), we can expect that \(\boldsymbol{\pi}(t)\) will be close to \(\boldsymbol{\pi}\). For \(t\) small enough, the system is said to be in a _transient region_ and displays transient behavior. But as \(t\) gets larger, the difference between \(\boldsymbol{\pi}(t)\) and \(\boldsymbol{\pi}\) eventually becomes small. Look at the following string of inequalities for the \(k\)-th component of their difference.

\[\left|[\boldsymbol{\pi}(t)-\boldsymbol{\pi}]_{k}\right|= \left|\sum_{i=2}^{m}\alpha_{i}e^{-t\lambda_{i}}(\mathbf{u_{i}})_{ k}\right|\leq\sum_{i=2}^{m}|\alpha_{i}|\left|(\mathbf{u_{i}})_{k}\right|\,\exp[-t \,\Re(\lambda_{i})]\] \[\leq e^{-t/RT}\sum_{i=2}^{m}|\alpha_{i}|\left|(\mathbf{u}_{i})_{ k}\right|=Ce^{-t/RT}.\]

We see that the upper bound of the difference drops at least by a factor of \(e\) for each time unit \(RT\), but \(C\) could be enormous, so it could take a long time before the actual difference \(|\boldsymbol{\pi}(t)-\boldsymbol{\pi}|\) shows this behavior.

<!-- Pages 51-51 -->

As already mentioned, although all irreducible chains have only one eigenvalue equal to 1, they can have other eigenvalues whose modulus is 1. For example, the \(\boldsymbol{P}\) in Exercise 1.3.3 has eigenvalues +1 and -1. When this is the case, the limit as \(n\) goes to infinity of \(\lambda_{i}^{n}\) does not exist for some \(i\), so \(\boldsymbol{\pi_{d}}(n)\) has no limit [unless \(\boldsymbol{\pi_{d}}(0)\mathbf{v}_{\mathbf{i}}^{\prime}=0\)]. In other words, there may be no steady state.

What, then, does \(\boldsymbol{\pi_{d}}\) mean? The answer comes from the discrete-time average equivalent to Equations (1.3.12). Define

\[\boldsymbol{\bar{G}_{d}}(N):=\frac{1}{N}\left(\boldsymbol{I}+\boldsymbol{P}+ \cdots+\boldsymbol{P}^{N-1}\right)=\boldsymbol{\epsilon^{\prime}\,\pi_{d}}+ \frac{1}{N}\sum_{k=0}^{N-1}\left(\sum_{i=2}^{m}\lambda_{i}^{k}\mathbf{v}_{ \mathbf{i}}^{\prime}\mathbf{u}_{\mathbf{i}}\right)\]

\[=\boldsymbol{\epsilon^{\prime}\,\pi_{d}}+\frac{1}{N}\

<!-- Pages 52-52 -->

**Exercise 1.3.7:** Let (where \(0<a<1\))

\[\boldsymbol{P}=\left[\begin{array}{ccc}0&a&1-a\\ 1&0&0\\ 1&0&0\end{array}\right].\]

Find all the eigenvalues and eigenvectors of \(\boldsymbol{P}\), solve for \(\boldsymbol{\pi_{d}}(n)\), and show that for large \(n\), \(\frac{1}{2}[\boldsymbol{\pi_{d}}(n)+\boldsymbol{\pi_{d}}(n+1)]\) approaches \(\boldsymbol{\pi_{d}}\).

Despite the fact that there was much matrix theory in this chapter, we have not yet touched upon what is meant by LAQT. That must wait until Chapter 3. From now on we consider only continuous-time systems. It should not be inferred from this that discrete-time systems are less utilitarian. There is some belief, in fact, that they could be more useful. Some day we may try to treat the queueing world as a movie in discrete time.

<!-- Pages 53-53 -->

## Chapter 2 M/M/1 Queue

_I'm sure that I've never been in a queue as slow as this._

Any Customer, Anywhere, Anytime

_Nobody goes there anymore. It's too crowded._

Yogi Berra

The M/M/1 queue, the simplest and most elementary of all queues, is covered it here in some detail. But what we discuss differs from that covered in the usual first course in queueing theory, and we use different techniques to accomplish our goals. Our purpose is threefold. First, we want to connect Chapter 1 with queueing theory and familiarize the reader with our terminology. Second, we want to set up points of view and techniques that are used in later chapters when LAQT is finally introduced. Third, we want to reinforce the view that the behavior of a queueing system in the transient or small time region may be important more often than we have thought heretofore, and that it is possible to study that region realistically and perform calculations relatively easily, in fact, in some cases with the same ease (or difficulty) as with the steady state.

All systems treated in this book are _closed_. That is, there is always a fixed number of customers in the system. Each system is made up of two subsystems that interact with each other exclusively by exchanging customers. If \(N\), the fixed number of customers, is large enough, we show that one of the subsystems must become saturated (\(\mathbb{Pr}\)(subsystem is idle) \(\rightarrow\) 0). It then becomes a steady source of customers to the other subsystem. _Open systems_, then, are those where \(N\) is so large that one of the subsystems is continuously fed by the other which is at full capacity (almost) all the time. We make this clear in what follows.

### 2.1 Steady-State M/M/1-Type Loops

Consider the system shown in Figure 2.1.1. It is made of two subsystems, called \(S_{1}\) and \(S_{2}\). At any time, \(S_{1}\) has \(n\) customers, \(S_{2}\) has \(k\) customers, and the system as a whole has \(N=n+k\) customers. In this chapter both \(S_{1}\) and \(S_{2}\) are memoryless and thus have exponential service time pdfs of the form \(\mu\exp(-\mu x)\) and \(\lambda\exp(-\lambda x)\), respectively (which from a formal point of view

<!-- Pages 55-55 -->

that both \(S_{1}\) and \(S_{2}\) are unchanged at time \(x\). Next define

\[B_{<}(x):=1-R_{1}(x)R_{2}(x)\]

as the probability that at least one of the subsystems has done something by time \(x\). Then

\[b_{<}(x):=\frac{d}{dx}B_{<}(x)=(\mu+\lambda)e^{-(\mu+\lambda)x}\]

is the desired pdf. Therefore the process in which one of two things can happen is exponentially distributed, with service (departure in this case) rate \((\mu+\lambda)\).

In summary, the completion rate matrix looks like

\[\textbf{{M}}=\left[\begin{array}{ccccc}\lambda&0&0&\cdots&0\\ 0&\mu+\lambda&0&\cdots&0\\ 0&0&\mu+\lambda&\cdots&0\\ \vdots&\vdots&\vdots&\cdots&\vdots\\ 0&0&0&\cdots&\mu\end{array}\right].\] (2.1.1a) The transition matrix **P** from Equations ( 1.3.1 ) has the following values. For \[n=0\], the only thing that can happen is for a customer to leave \[S_{2}\] and go to \[S_{1}\], so \[P_{01}=1\]. Similarly, \[P_{N,N-1}=1\]. For all other \[n\], one of two things could happen. Either a customer could leave \[S_{2}\] and go to \[S_{1}\], or the reverse. In the first case the system would go from state \[n\] to \[n+1\], and in the other case the system would go from \[n\] to \[n-1\]. The probability that one would happen over the other is proportional to the separate subsystems' (servers') service rates, \[\mu\] and \[\lambda\]. In other words, \[P_{n,n+1}=\lambda/(\mu+\lambda)\]. We show this by evaluating the probability that \[S_{2}\] will finish before \[S_{1}\]. This will occur if \[S_{2}\] finishes around time \[t\] [ \[b_{2}(t)dt]\] while \[S_{1}\] is still running [ \[R_{1}(t)]\] for any \[t>0\] (integrate over \[t\] ). This gives us \[\textbf{{Pr}}(S_{2}\text{will finish before }S_{1})=\int_{\text{o}}^{\infty}b_{2}(t)R_{1}(t)dt\] \[=\int_{\text{o}}^{\infty}\lambda e^{-\lambda\,t}e^{-\mu\,t}dt= \lambda\int_{\text{o}}^{\infty}e^{-(\mu+\lambda)t}dt=\frac{\lambda}{\mu+ \lambda}\,.\] (2.1.1b) What we have just shown is important enough to be summarized in a theorem.

**Theorem 2.1.1:** Let \(X_{1}\) and \(X_{2}\) be independent random variables having exponential distribution functions with rates \(\mu\) and \

<!-- Pages 56-56 -->

and

\[b_{<}(x)=(\mu+\lambda)e^{-(\lambda+\mu)x}.\]

Furthermore, \(\Pr(X_{2}<X_{1})\) is given by (2.1.1b). Because both \(X_{1}\) and \(X_{2}\) are exponentially distributed, these results do not depend upon which server started first. 

The entire \(\boldsymbol{P}\) matrix is the following.

\[\boldsymbol{P}=\left[\begin{array}{cccccccc}0&1&0&0&\cdots&0&0&0\\ \frac{\mu}{\mu+\lambda}&0&\frac{\lambda}{\mu+\lambda}&0&\cdots&0&0&0\\ 0&\frac{\mu}{\mu+\lambda}&0&\frac{\lambda}{\mu+\lambda}&\cdots&0&0&0\\ \vdots&\vdots&\vdots&\vdots&\cdots&\vdots&\vdots&\vdots\\ 0&0&0&0&\cdots&0&\frac{\lambda}{\mu+\lambda}&0\\ 0&0&0&0&\cdots&\frac{\mu}{\mu+\lambda}&0&\frac{\lambda}{\mu+\lambda}\\ 0&0&0&0&\cdots&0&1&0\end{array}\right]. \tag{2.1.1c}\]

Finally, \(\boldsymbol{Q}=\boldsymbol{M}(\boldsymbol{I}-\boldsymbol{P})\) can easily be calculated to give us

\[\boldsymbol{Q}=\left[\begin{array}{cccccccc}\lambda&-\lambda&0&0&\cdots&0&0&0 \\ -\mu&\mu+\lambda&-\lambda&0&\cdots&0&0&0\\ 0&-\mu&\mu+\lambda&-\lambda&\cdots&0&0&0\\ \vdots&\vdots&\vdots&\vdots&\cdots&\vdots&\vdots&\vdots\\ 0&0&0&0&\cdots&\mu+\lambda&-\lambda&0\\ 0&0&0&0&\cdots&-\mu&\mu+\lambda&-\lambda\\ 0&0&0&0&\cdots&0&-\mu&\mu\end{array}\right]. \tag{2.1.1d}\]

This procedure of calculating \(\boldsymbol{Q}\) in two steps rather than directly, as is usually done, seems cumbersome, but its utility becomes clear in later chapters.

\(\boldsymbol{Q}\) matrices of the form in (2.1.1d) (i.e., those that are tridiagonal) generate what are known as _birth-death processes_. In general, if the states can be linearly ordered, and transitions only occur between neighboring states (i.e., given that the system is in state \(n\), it can only go to \(n-1,\;n\), or \(n+1\)), then we have a birth-death process. This can be generalized in the following way. Suppose that the states of the system can be partitioned into subsets that are linearly ordered as \(\{\Xi_{\text{o}},\,\Xi_{1},\,\Xi_{2},\,\ldots,\,\Xi_{n-1},\,\Xi_{n},\,\Xi_{n+1},\,\ldots\}\). If transitions can only occur between adjacent sets, we have a _Quasi Birth-Death (QBD) process_[26]. The \(\boldsymbol{Q}\) matrix for a QBD process looks like (2.1.1d), except that each of the elements is itself a matrix. All the processes discussed in this book are QBD. This means leaving out such topics as bulk arrival processes, a typical topic in other queueing theory books.

#### 2.1.1 Time-Dependent Solution for \(\boldsymbol{N=2}\)

The time-dependent solution for \(N=1\) was actually done in Exercise 1.3.3. The next simplest nontrivial case is \(N=2\). Here

\[\boldsymbol{Q}=\left[\begin{array}{ccc}\lambda&-\lambda&0\\ -\mu&\mu+\lambda&-\lambda\\ 0&-\mu&\mu\end{array}\right]. \tag{2.1.2}\]

<!-- Pages 57-57 -->

Obviously, \(\boldsymbol{\epsilon^{\prime}}\) (\(\boldsymbol{\epsilon}=[1,1,1]\)) is a right eigenvector of \(\boldsymbol{Q}\) with eigenvalue \(0\), and it is not hard to find its companion, the left eigenvector with eigenvalue \(0\) [i.e., \(\boldsymbol{\pi}(2)\,\boldsymbol{Q}=\mathbf{o}\)]. One proves by direct substitution that

\[\boldsymbol{\pi}(2)=\frac{1}{1+\rho+\rho^{2}}[1,\ \rho,\ \rho^{2}],\]

where \(\rho=\lambda/\mu\) and \(\boldsymbol{\pi}\,\boldsymbol{\epsilon^{\prime}}=1\). The components of the total probability vector \([\boldsymbol{\pi}(2)]_{j}\) are the steady-state probabilities of finding \((j-1)\) customers at \(S_{1}\). Put colloquially, after a long time, a random observer who may come along will find \(j-1\) customers at \(S_{1}\) with probability \([\boldsymbol{\pi}(2)]_{j}\). The eigenvalues of \(\boldsymbol{Q}\) satisfy the polynomial equation coming from Equations (1.3.6),

\[\phi(\beta)=\beta^{3}-2(\mu+\lambda)\beta^{2}+(\mu^{2}+\mu\lambda+\lambda^{2} )\beta=0.\] (2.1.3a) The roots of this equation are (for convenience we let the indices take on values \[0\] to \[N=2\] rather than the convention used in Chapter 1) \[\beta_{\mathrm{o}} =0 \tag{2.1.3b}\] \[\beta_{1} =\mu(1+\rho+\sqrt{\rho})\] (2.1.3b) \[\beta_{2} =\mu(1+\rho-\sqrt{\rho}).\]

\(\beta_{\mathrm{o}}\) is the root corresponding to the steady-state solution, whereas \(\beta_{1}\)and \(\beta_{2}\) moderate the transient behavior. Now \(\beta_{2}<\beta_{1}\), so the relaxation time from Equations (1.3.11) is \(1/\beta_{2}\). Because the time units are arbitrary, we must establish some comparison to learn something from the formula. One convenient time unit to use in this case is the mean time for a single customer to go around the loop once, unimpeded. A simple way to do this is to let \(1/\mu+1/\lambda=1\); then, from Equations (1.3.11),

\[RT(\rho)=\frac{\rho}{(1+\rho)(1+\rho-\sqrt{\rho})}.\]

In this case it should be easy to see that \(RT\) is maximal when \(\rho=1\) and that \(RT(\rho)=RT(1/\rho)\). We examine the general case in Section 2.2, but we note that these results are typical.

**Exercise 2.1.1:** For a cycle time of \(1\) (\(1/\mu+1/\lambda=1\)) show that the formula above is true, and draw a graph of \(RT\) versus \(\rho\). When is \(RT\) a maximum? Prove that \(RT(\rho)=RT(1/\rho)\).

**Exercise 2.1.2:** Find all the left and right eigenvectors of \(\boldsymbol{Q}\) and verify that Equations (1.3.8a) are satisfied. Construct \(\boldsymbol{G}(t)\) from (1.3.9a), and then \(\boldsymbol{\pi}(t;2)\), where \(\boldsymbol{\pi}(0;2)\) is one of [1 0 0], or [0 1 0], or [0 0 1].

<!-- Pages 58-58 -->

#### Steady-State Solution for Any \(N\)

The steady-state solution for the M/M/1//N queue is, of course, well known and is shown in every book that discusses queueing theory to any extent. We discuss it briefly here to show how one goes from closed to open systems. Our assumption in this section is that \(S_{2}\) is load independent. That is, the service rate of \(S_{2}\) is the same irrespective of how many customers are in its queue.

From (1.3.9) and (1.3.10), the steady-state solution of our loop satisfies \(\boldsymbol{\pi}\,\boldsymbol{Q}=\mathbf{o}\), which from (1.3.2c) is the same as \(\boldsymbol{\pi}\,\boldsymbol{M}=\boldsymbol{\pi}\,\boldsymbol{M}\,\boldsymbol {P}\). (See Theorem 1.3.3 for a summary.) These equations are referred to as the steady-state _balance equations_. In the notation of Chapter 1, the left-hand side (\(\pi_{i}\,\mu_{i}\)) is interpreted as the probability rate of leaving state \(i\), and the right-hand side is the probability rate of entering state \(i\). And, of course, they are equal when a system reaches its steady state.

At this point it is advantageous for us to change our notation, to be consistent with succeeding chapters, where \(\boldsymbol{\pi}\) takes on a different meaning. The abstract state \(i\) stands for there being \(n=i-1\) customers at \(S_{1}\), we therefore define the following.

_Definition 2.1.1_.: \(r(n;N):=\) _steady-state probability that there are n customers at \(S_{1}\), where \(N\) is the (fixed) number of customers in the system overall. Then \(r(n;N)\) replaces \([\boldsymbol{\pi}(N)]_{i}\quad(n=i-1)\) everywhere. _

For the M/M/1//N queue, these equations become, using (2.1.1d),

\[\begin{split}\lambda r(0;\,N)&=\mu\,r(1;N),\\ (\mu+\lambda)r(n;\,N)&=\lambda r(n-1;\,N)+\mu\,r(n+1 ;\,N),\\ \mu\,r(N;\,N)&=\lambda\,r(N-1;\,N),\end{split}\] (2.1.4a) where \[0<n<N\]. It is common to represent these equations graphically by what are called _state transition rate diagrams_ (or simply _transition diagrams_), as shown in Figure 2.1.2. Each arrow corresponds to going from the state represented by the circle at the tail to the state represented by the circle at the head, with probability rate equal to the probability of being at the tail times the rate corresponding to the arrow. Every closed curve encompassing part of the graph represents a valid balance equation, where

Figure 2.1.2: State transition rate diagram for an M/M/1//N queue, representing the probability rate of going from the tail to the head of each arrow. The three closed, dashed curves correspond to the three equations of (2.1.4a).

<!-- Pages 60-60 -->

there are \(N\) customers in the loop._ Then

\[\Lambda(N):=\frac{P_{i}(N)}{T_{i}}\] (2.1.5a) is the rate at which customers enter and leave the loop, and is independent of \[i\]. \[\Lambda(N)\] can be referred to as the _system throughput_. In fact, this formula is valid for networks of any number of servers, as long as customers do not have the option of using a different server if the one they want is busy, and if the servers are not load dependent. 

\(P_{1}(N)\) is 1 minus the probability that \(S_{1}\) is idle, so from (2.1.4b) with \(n=0\), and (2.1.4d),

\[P_{1}(N)=1-r(0;N)=1-\frac{1}{K(N)}=\frac{K(N)-1}{K(N)}=\rho\frac{K(N-1)}{K(N)}\;. \tag{2.1.5b}\]

Similarly, from (2.1.4c),

\[P_{2}(N)=1-r(N;N)=\frac{K(N)-\rho^{N}}{K(N)}=\frac{K(N-1)}{K(N)}\;. \tag{2.1.5c}\]

Figure 2

<!-- Pages 61-61 -->

Then, because \(\rho=T_{1}/T_{2}\), we show that the throughput as seen at \(S_{1}\) is the same as that seen at \(S_{2}\):

\[\Lambda(N)=\frac{P_{1}(N)}{T_{1}}=\frac{1}{T_{2}}\frac{K(N-1)}{K(N)}=\frac{P_{2} (N)}{T_{2}}\;. \tag{2.1.5d}\]

**Example 2.1.2:** We can understand the throughput behavior by looking at Figure 2.1.4, which shows \(\Lambda(N)\) as a function of \(N\) for several values of \(\rho\). Note that \(\Lambda(N;\rho)=\Lambda(N;1/\rho)\). In all cases, \(\Lambda(N)\) saturates as \(N\) becomes increasingly large, and we see behavior typical of even more complicated queueing systems. That is, \(\Lambda(N+1)>\Lambda(N)\) for all \(N\), but

\[[\Lambda(N+2)-\Lambda(N+1)]<[\Lambda(N+1)-\Lambda(N)].\]

This is the law of diminishing returns. "Adding yet one more customer to the system will increase throughput, but the increase will not be as much as it was in adding the previous customer." Finally,

\[\lim_{N\to\infty}[P_{1}(N)+P_{2}(N)]=1+\rho,\quad\text{ for }\rho\leq 1.\]

That is, in general, only one server will saturate, and the other will be busy only a fraction of the time. Only when \(\rho=1\) will both servers approach full capacity with ever-increasing \(N\). \(\blacktriangle\)

**Exercise 2.1.3:** Prove that the limit given in the preceding equation is indeed true. What is the limit when \(\rho\) is greater than \(1\)? Also prove that \(\Lambda(N;\rho)=\Lambda(N;1/\rho)\) when \(T_{1}+T_{2}=1\).

#### Open M/M/1 Queue \((\boldsymbol{N\to\infty})\)

We can find the open system solution by doing the following. When \(\rho<1\), Equations (2.1.4) retain their meaning for large \(N\). In this case,

\[\lim_{N\to\infty}K(N)=\frac{1}{1-\rho},\]

so

\[r(n):=\lim_{N\to\infty}r(n;N)=(1-\rho)\rho^{n}\] (2.1.6a) and \[\lim_{n\to\infty}r(n)=0.\]

That is, when \(N\) is very large, the probability that \(S_{2}\) will be idle is negligible, so it is continually serving customers whose interdeparture times are exponentially distributed. Each new customer starts up in the same way the previous one did, so \(S_{2}\) becomes a steady Poisson process of arrivals to \(S_{1}\)

<!-- Pages 63-63 -->

\[\lim_{N\to\infty}\Lambda(N)=\frac{1}{T_{2}}\frac{1}{\rho}=\frac{1}{T_{1}}\quad \text{ for }\rho\geq 1.\]

In other words, we have proven what should be obvious. The throughput of the system is bounded by the maximal throughput of the slower server, the _bottleneck_. The two equations can be summarized by

\[\lim_{N\to\infty}\Lambda(N)=\min\biggl{(}\frac{1}{T_{1}},\frac{1}{T_{2}}\biggr{)}\,. \tag{2.1.6c}\]

A perhaps more interesting question to answer is: how long will a customer be at \(S_{1}\), both waiting for and being served? This turns out to be easy to answer once the mean queue length is known. The relevant expression, _Little's formula_, which we introduced in (1.1.2), existed for many years before being proven under certain conditions by J. D. C. Little in 1961 [11]. Recall that it is valid for any subsystem that has been in operation long enough so that the number of customers who have come and gone is far greater than the number presently there or who were there originally. Restated simply,

\[\bar{q}_{s}=\Lambda\bar{T}_{s},\] (2.1.7a) where \[\Lambda\] is the mean arrival rate to (and departure rate from) the subsystem and \[\bar{T}_{s}\] is the mean time spent there by each customer. In our case, \[\Lambda=\lambda\] and \[\rho=\lambda/\mu\], so from ( 2.1.6b ), we have proven ( 1.1.4b ) \[\bar{T}_{s}=\frac{\bar{q}_{s}}{\lambda}=\frac{\bar{x}}{1-\rho},\] (2.1.7b) where \[\bar{x}=1/\mu\] is the mean service time of \[S_{1}\]. Note that if \[\rho=0\] (no customers waiting at all), the mean time a customer remains in the system is the expected \[\bar{x}\], and as with the mean queue length, the time a customer must wait grows unboundedly as \[\rho\] approaches 1.

It is useful to tighten up our terminology somewhat. Often, one wishes to make a distinction between the time spent waiting for service and the time in service. We use the term _system time_ or _total time_ spent in, say, \(S_{1}\) as the time spent by a customer from the moment he enters \(S_{1}\)'s queue until he leaves that subsystem. In a closed loop, this also corresponds to the time interval from the moment the customer leaves \(S_{2}\) until he returns. For that reason, this time interval is also called the _response time_ for \(S_{1}\). We use the three terms interchangeably, tending to prefer the first two when discussing open systems, whereas the latter tends to be used more in dealing with time-sharing systems.

In many applications, the time spent being served is considered useful, and only the time spent waiting in the queue is wasted. This time is called both _queueing time_ and _waiting time_. We try to use the latter term, for there is some ambiguity here when load-dependent servers are considered (see the following section and Section 5.4), or when we consider "generalized M/G/\(C\) systems" in Chapter 6, for then it is not always clear when waiting ends and service begins. We often talk about _queue length_, or the _number of customers_

<!-- Pages 64-64 -->

in the queue_, and when we do, we invariably mean "the number of customers at, or in, \(S_{i}\)," that is, including those being served.

If only one customer can be served at a time, and the performance of \(S_{1}\) is the same no matter how many customers are in its queue, the steady-state mean system time \(\bar{T}_{s}\) and mean waiting time \(\bar{T}_{w}\) are related by the simple relation

\[\bar{T}_{s}=\bar{T}_{w}+\bar{x}_{1}. \tag{2.1.7c}\]

From Little's formula, the number in the queue and the number in \(S_{1}\) are related by the slightly strange formula

\[\bar{q}_{s}=\bar{q}_{w}+\rho. \tag{2.1.7d}\]

The reason \(\rho\) appears instead of 1 is that sometimes there is no one waiting when someone is being served. It is pleasant to realize that (2.1.7c) and (2.1.7d) are true for any distribution, but the reader should be careful to observe the restrictions as stated in the beginning of this paragraph.

#### Buffer Overflow and Cell Loss for M/M/1/\(N\) Queues

An important problem in designing systems with queues involves deciding how much space should be provided to accommodate waiting customers. We look at this issue in two ways. First consider that a _waiting room_ is made up of a _primary buffer_ that can accommodate, say \(N_{1}\) customers, and a secondary buffer, or _backup buffer_, that can hold as many as needed. An example of this might be a cache interfacing a bulk storage device with a communications channel. Then the question is the following.

(1) What is the probability that an arriving customer will not be able to fit into the primary buffer, or in other words, will the _buffer overflow_?

One could instead assume that there is only a primary buffer, with no backup. Then an arriving customer, seeing a full buffer, would give up and disappear, or what is mathematically equivalent, return to the queue at \(S_{2}\). The question then is the following.

(2) What is the probability that an arriving customer will be rejected from the queue at \(S_{1}\)?

The first case corresponds to an M/M/1 queue, and the second corresponds to an M/M/1/\(N_{1}/N\) queue. The latter expression requires some interpretation. If \(N_{1}<N\) and we are to assume that customers arriving at a full queue would have to instantly return to the end of the queue at \(S_{2}\), then \(S_{2}\) is always busy, so \(N\) might just as well be \(\infty\). For this reason, the M/M/1/\(N\) queue is considered to be open even though the population at \(S_{1}\) is always less than or equal to \(N_{1}\).

If, on the other hand, \(N_{1}\geq N\) the buffer can never be full to an arriving customer. Therefore,

\[\mbox{M/M/1/$N_{1}$}\equiv\left\{\begin{array}{lcl}\mbox{M/M/1/$N_{1}$}& \quad\mbox{for}&N_{1}<N\\ \mbox{M/M/1/$/N$}&\quad\mbox{for}&N_{1}\geq N\end{array}\right.\]

<!-- Pages 65-65 -->

In general, the solutions for M/G/1//\(N\) loops are very similar to those for M/G/1/\(N\) queues. The difference becomes significant in Section 5.3 when we compare the G/M/1//\(N\) and G/M/1/\(N\) queues, but we give a short explanation here. When a customer arrives at an M/M/1/\(N\) queue that already has \(N\) customers, the arriving customer is turned away. Each subsequent arrival will be turned away until \(S_{1}\) has a completion. Given that the arrival process is a Poisson process, the time for the next arrival is exponentially distributed, but now starting at the time of the departure, having no memory of the previous arrival. The M/M/1//\(N\) loop behaves in the following way. If all \(N\) customers are at \(S_{1}\), there can be no further arrivals until \(S_{1}\) has a completion. After such a completion, \(S_{2}\) can service its new arrival, thereby preparing a new arrival for \(S_{1}\). We see that shutting off the arrival process has the same effect as turning away arrivals, but only if the arrival process is memoryless, that is, Poisson.

Cases (1) and (2) both talk about an _arriving customer_, whereas we have given solutions for a random observer \([r(n)]\). Therefore we must introduce some new variables.

_Definition 2.1.3_

\(a(n;\,N):=\) _probability that a customer arriving at \(S_{1}\) in an M/M/1//\(N\) loop will see \(n\) customers already in the queue, including the one in service_. By this definition, it must be that_

\[a(N;\,N)=0.\]

_After all, the arriving customer is one of the \(N\) customers in the system, so he can see at most \(N-1\) customers before him at \(S_{1}\). _

We give similar definitions for the M/M/1/\(N\) queue, using \(\boldsymbol{f}\) (for _finite buffer_) as the distinguishing marker.

_Definition 2.1.4_

\(r_{\!f}(n;\,N):=\) _probability that a random observer will see n customers at or in \(S_{1}\) for an M/M/1/\(N\) queue._

\(a_{\!f}(n;\,N):=\) _probability that a customer arriving at an M/M/1/\(N\) queue will see \(n\) customers already in the queue, including the one in service_. By this definition, \(a_{\!f}(N;\,N)\) is the probability that an arriving customer will be turned away (i.e., the _customer loss_ probability). If we were dealing with the tranmission of packets or cells in telecommunications we would call this _packet loss probability_ or _cell loss probability_. _

In Chapters 4 and 5 we give a more rigorous argument for the following equations, but for the systems of interest here the following arguments are sufficient. Because we are looking at Poisson arrivals, each arriving customer has no knowledge of when the previous customer arrived, therefore he will see the same thing that a random observer does, except that he cannot see \(N\) customers already in the queue. Therefore,

\[a(n;\,N)=\left\{\begin{array}{ll}c(N)\,r(n;\,N)&\quad\text{for}\;0\leq n<N\\ 0&\quad\text{for}\;n=N\end{array}\right..\]

<!-- Pages 66-66 -->

The sum of the \(a(n;\,N)\)'s must be 1, therefore it follows that \(c(N)=(1-\rho^{N+1})/(1-\rho^{N}).\) We can now summarize the steady-state properties of the M/M/1//\(N\) queue in the following theorem.

**Theorem 2.1.2:** The steady-state probabilities of finding \(n\) customers in an M/M/1//\(N\) loop are given by Equations (2.1.4), namely,

\[r(n;N)=\frac{\rho^{n}}{K(N)},\ \ \ \ \ 0\leq n\leq N,\]

where \(K(N)=N+1\) for \(\rho=1,\) and for \(\rho\neq 1\)

\[K(N):=\sum_{n=0}^{N}\rho^{n}=\frac{1-\rho^{N+1}}{1-\rho}=1+\rho K(N-1).\]

The probability that a customer arriving at \(S_{1}\) will find \(n\) customers already there is given by

\[a(n;\,N)=\frac{1-\rho}{1-\rho^{N}}\rho^{n}\ \ \ \text{for}\ 0\leq n<N,\] (2.1.8a) and \[a(N;\,N)=0.\] For \[\rho=1,\ a(n;\,N)=1/N.\] In other words, \[a(n;\,N)=r(n;\,N-1)\] for \[n<N\].

The probability that an arriving customer will see \(N_{1}\leq n<N\) or more customers already in the queue (_overflow probability_) is given by:

\[P_{o}(N_{1};\,N):=\sum_{n=N_{1}}^{N-1}a(n;\,N)=\frac{\rho^{N_{1}}-\rho^{N}}{1 -\rho^{N}}\,. \tag{2.1.8b}\]

For \(\rho<1\) the open M/M/1 queue steady-state probabilities, from (2.1.6a) and (2.1.8a), are

\[a(n)=r(n)=\lim_{N\to\infty}r(n;\,N)=(1-\rho)\rho^{n}. \tag{2.1.8c}\]

Here, the arriving customer and the random observer see the same queue lengths.

The mean queue length, from (2.1.6b) is

\[\bar{q}_{s}=\frac{\rho}{1-\rho}\]

and the mean system time, from (2.1.7b), is

\[\bar{T}_{s}=\frac{\bar{x}}{1-\rho},\]

where \(\rho=\lambda/\mu\) and \(\bar{x}=1/\mu.\) Also,

\[P_{o}(N_{1}):=\lim_{N\to\infty}P_{o}(N_{1};\,N)=\rho^{N_{1}}. \tag{2.1.8d}\]

We have used the subscript \(\boldsymbol{o}\) to denote primary buffer \(\boldsymbol{o}\)verflow.

<!-- Pages 67-67 -->

The steady-state solutions for the M/M/1/\(N_{1}\) queue are easy to write down, because an arriving customer in a Poisson arrival process sees the same thing as the random observer, even if the finite buffer is full. Therefore, we have the following.

**Theorem 2.1.3:** Systems with finite buffers have the following probabilities.

\[a_{\!f}(n;\,N_{1})=r_{\!f}(n;\,N_{1})=r(n;\,N_{1})=\frac{1-\rho}{1-\rho^{N_{1} +1}}\rho^{n}.\] (2.1.9a) These equations are valid for all \(\rho\). The probability that an arriving customer will find the buffer full, and be turned away is given by:

\[P_{\!f}(N_{1})=a_{\!f}(N_{1};\,N_{1})=\frac{1-\rho}{1-\rho^{N_{1}+1}}\rho^{N_{ 1}}. \tag{2.1.9b}\]

In telecommunications systems, this is known as the _cell loss probability_ or _packet loss probability_.

The mean queue length, \(\bar{q}_{\!f}(N_{1})\), is

\[\bar{q}_{\!f}(N_{1}):=\sum_{n=1}^{N_{1}}n\,r_{\!f}(n;\,N_{1})\]

\[=\frac{\rho}{1-\rho}\left[\frac{1+N_{1}\rho^{N_{1}+1}-(N_{1}+1)\rho^{N_{1}}}{ 1-\rho^{N_{1}+1}}\right]. \tag{2.1.9c}\]

Note that \(\bar{q}_{\!f}(N_{1})\) does not blow up at \(\rho=1\). In fact \(\bar{q}_{\!f}(N_{1}|\rho=1)=N_{1}/2\), and \(P_{\!f}(N_{1}|\rho=1)=1/(N_{1}+1)\). In other words, a relatively small loss of cells can yield a manageable size queue. (Recall that the mean queue length for a queue with an infinite buffer, where no losses are allowed, is infinite when \(\rho=1\)).

Let \(T_{\!f}(N)\) be the random variable denoting the system time for a customer that is not rejected. Then

\[\mbox{\bf E}[T_{\!f}(N_{1})]=\frac{1/\mu}{1-\rho}\left[\frac{1+N_{1}\rho^{N_{ 1}+1}-(N_{1}+1)\rho^{N_{1}}}{1-\rho^{N_{1}}}\right]. \tag{2.1.9d}\]

This last equation requires some explanation which we give in the following proof.

**Proof:** In order to get (2.1.9d) from (2.1.9c) using Little's formula, one must use the _effective_ arrival rate to the queue. That is, one must include only those customers that are not turned away. That is,

\[\lambda_{\!f}(N_{1}):=\frac{\lambda}{1-P\!f\!f(N_{1})}=\frac{1-\rho^{N_{1}}}{ 1-\rho^{N_{1}+1}}\,\lambda.\]

Then (2.1.9d) follows from

\[\mbox{\bf E}[T_{\!f}(N_{1})]=\frac{\bar{q}_{\!f}(N_{1})}{\lambda_{\!f}(N_{1})}.\]

<!-- Pages 68-68 -->

An alternate proof is given as an exercise.

Note that the effective arrival process is no longer a Poisson process. In fact, it's no longer a renewal process. Observe that the customers are not thrown away randomly. If one is thrown away, then the next one is also likely to be lost. \(\mathbf{QED}\)2

Footnote 2: These letters stand for the time-honored Latin phrase _Quod Erat Demonstrandum_, whose translation is "which was to be demonstrated." **QEDdesignates the end of a proof.**

**Exercise 2.1.4:** Using (2.1.9b) and given a fixed value for the probability \(p_{\ell}\) of customer loss, show that \(\rho\) must always be less than \(1/(1-p_{\ell})\) in order that \(P_{\!f}(N)\leq p_{\ell}\), no matter how large \(N\) is. [See Equations (2.1.10) for a general proof.]

**Exercise 2.1.5:** One can derive (2.1.9d) directly from the definition of \(a_{\!f}(n;\,N_{1})\). The service distribution is exponential here, therefore the mean time remaining for the customer in service at the moment a new customer arrives is \(1/\mu\), the same as from the beginning of service. If a customer arrives with \(n<N\) already in the queue, then he must expect to wait \([(n+1)/\mu]\) units of time until all those in front and he himself are served. The probability that he will find \(n\) in the queue, given that he will be accepted, is given by \(a_{\!f}(n;\,N_{1}\,|\,\mbox{accepted}):=a_{\!f}(n;\,N_{1})/[1-P_{\!f}(N_{1})]\) Then

\[\bar{T}_{\!f}(N_{1})=\sum_{n=\mbox{\scriptsize o}}^{N_{1}-1}\left[\frac{n+1} {\mu}\right]a_{\!f}(n;\,N_{1}\,|\,\mbox{accepted}).\]

Use this expression to derive (2.1.9d)

Before closing this section we compare \(P_{\!o}(N_{1})\) and \(P_{\!f}(N_{1})\) and discuss their uses and significance. First note that \(P_{\!f}(N_{1})<P_{\!o}(N_{1})\) for every \(\rho\), remembering that \(P_{\!o}(N_{1})\) is not defined for \(\rho\geq 1\). The reason should be clear, because the finite buffer system throws away customers, and thus processes fewer of them than the overflow system for any given arrival rate. In exchange for this, the mean queue length and the mean waiting time for the customers is considerably reduced. For instance, let \(\rho=1\) and \(N_{1}=10\). Then the mean queue length in the back-up buffer of the M/M/1 queue is infinite, but \(\bar{q}_{\!f}(10)=5\). This can be evaluated from (2.1.9c) by using L'Hospital's rule, or by recognizing that \(a_{\!f}(n;\,N_{1};\;\rho=1)=1/(N_{1}+1)\;\forall\;n\). We see, then, by throwing away one customer in 11, one allows the others to get decent service; that is, \(\bar{T}_{\!f}(10;\,\rho=1)=5.5/\mu\).

<!-- Pages 70-70 -->

**Exercise 2.1.7:** Suppose that a router has enough space to hold 20 packets, and that \(\rho=0.9\). What percentage of packets will be lost if there is no backup buffer? By how much must the service rate \([\mu]\) be increased to reduce losses by a factor of 10? How much buffer space must be added for the same reduction? Redo the problem for overflow to a backup buffer.

#### Load-Dependent Servers

The solutions for the M/M/1 queue can be extended without much difficulty to the M/M/C/ \(/N\), and even somewhat more general, queues. Suppose that there are \(C\) identical exponential servers in \(S_{1}\), each with service rate \(\mu\), feeding off a single queue. That is, as long as there are \(n\geq C\) customers at \(S_{1}\), all of the servers will be active, and as long as \(n\leq C\), none of the customers will be waiting to be served. As we already know, if several exponential servers are busy, the probability rate for something to happen is the sum of their service rates. Therefore, we can define a service rate for \(S_{1}\) that depends on the number of customers there. That is, let \(\mu(n)\) be the service rate of \(S_{1}\) when there are \(n\) customers there; then

\[\mu(n)=\left\{\begin{array}{ll}n\,\mu&\quad\mbox{for}\,\,\,n\leq C\\ C\,\mu&\quad\mbox{for}\,\,\,n\geq C.\end{array}\right.\] (2.1.11a) We think of \[S_{1}\] as a load-dependent server. Actually, the formulas we derive in this section do not depend on the explicit form we have just given the \[\mu\]'s; thus we can immediately generalize, and let \[\mu(1)\], \[\mu(2)\], and so on, be any positive numbers. The reader may think of \[S_{i}\] as a _multiple server_ subsystem, or as a single server whose service rate changes (not necessarily by integral units) with change of queue length. See the end of this section for further notational discussion.

Another formulation, which we adopt here, is to introduce the _load-dependence factor_\(\alpha_{1}(n)\), which is the ratio of service rates \(\mu(n)\) and \(\mu(1)\). By definition, \(\mu(1):=\mu\), \(\alpha_{1}(1)\) always equals 1, and \(\alpha_{1}(n)=\mu(n)/\mu\), which for a subsystem with \(C\) identical servers gives the following.

\[\alpha_{1}(n)=\left\{\begin{array}{ll}n&\quad\mbox{for}\,\,\,n\leq C\\ C&\quad\mbox{for}\,\,\,n\geq C.\end{array}\right. \tag{2.1.11b}\]

Clearly, \(\mu(n)=\alpha_{1}(n)\mu\). Similarly, we can view \(S_{2}\) as a load-dependent server, with load-dependence factor \(\alpha_{2}(n)\). Then \(\lambda(n)=\alpha_{2}(n)\lambda\). Next look at Figure 2.1.2. The arrow going from \(n\) to \(n-1\) corresponds to the probability rate of going from \(n\) to \(n-1\), which can happen only if there is a completion at \(S_{1}\). The rate for this to happen is \(\mu(n)\). Similarly, the arrow going from \(n\) to \(n+1\)

<!-- Pages 71-71 -->

corresponds to an arrival from \(S_{2}\), whose rate must be \(\lambda(N-n)\). Then all the arrows pointing to the left should be labeled (reading from right to left)

\[\mu(N),\,\mu(N-1),\,\ldots,\,\mu(n+1),\,\mu(n),\,\mu(n-1),\,\ldots,\,\mu(1),\]

and those pointing to the right are labeled (reading, this time, from left to right)

\[\lambda(N),\,\lambda(N-1),\,\ldots,\,\lambda(N-n+1),\,\lambda(N-n),\lambda(N- n-1),\,\ldots,\,\lambda(1).\]

Before solving for the M/M/C//\(N\) loop, let us review the meaning of a _state transition-rate diagram_. If, as in Figure 2.1.2, a single node is encircled, the sum of the probability rates entering the circle minus the sum of those leaving must be zero in the steady state. Suppose, instead, that two adjacent nodes are enclosed together. Then the arrows connecting them would not be included in the balance equations. But this would yield the same as one would get by adding the single equations together. After all, each of the two arrows appears in each equation, once as leaving one node, and once as entering the other, canceling out when the two equations are added. In general, then, we can say that for _any_ closed curve, what goes in must equal what goes out for the steady state to occur. Now consider the closed curve that encompasses all nodes from \(0\) to \(n\). Only one arrow goes in, and one arrow goes out, so we have the simple set of first-order difference equations:

\[\lambda(N-n)r(n;N)=\mu(n+1)r(n+1;N)\quad\text{for $0\leq n<N$}.\] (2.1.12a) In particular, \[r(1;N)=\frac{\lambda(N)}{\mu(1)}r(0;N)\] (2.1.12b) and \[r(2;N)=\frac{\lambda(N-1)}{\mu(2)}r(1;N)=\frac{\lambda(N)\,\lambda(N-1)}{\mu(1 )\,\mu(2)}r(0;N). \tag{2.1.12c}\]

Next, following the notation of [10], let \(\rho=\lambda/\mu\), \(\beta_{i}(0):=1\), and for \(n>0\),

\[\beta_{i}(n):=\alpha_{i}(n)\beta_{i}(n-1)=\alpha_{i}(1)\alpha_{i}(2)\cdots \alpha_{i}(n).\] (2.1.13a) For a subsystem with \[C\] identical servers, we have \[\beta_{i}(n):=\left\{\begin{array}{cc}n!&\text{for $n\leq C$}\\ C!\,C^{n-c}&\text{for $n\geq C$}.\end{array}\right.\] (2.1.13b) Then with only a little trickery, the general solution becomes \[r(n;\,N)=\frac{1}{K(N)}\frac{\rho^{n}}{\beta_{1}(n)\,\beta_{2}(N-n)},\] (2.1.14a) where, owing to the fact that the sum of probabilities must be \[1\], \[K(N):=\sum_{n=0}^{N}\frac{\rho^{n}}{\beta_{1}(n)\beta_{2}(N-n)}\,. \tag{2.1.14b}\]

<!-- Pages 73-73 -->

where \(\bar{\alpha}_{2}(n):=\bar{\lambda}(n)/\bar{\lambda}(1)\), \(\bar{\beta}_{2}(0):=1\), and

\[\bar{\beta}_{2}(n):=\bar{\alpha}_{2}(n)\,\bar{\beta}_{2}(n-1).\]

The \(\bar{\alpha}_{2}\)s can be interpreted as a slowdown of the arrival process because of the increasing queue length, so this is referred to as an M/M/\(C\) queue with _discouraged arrivals_. This may be a misnomer in some countries where consumer goods are scarce. In those places, we are told, arrival rates to queues actually increase with queue length. Mathematically, because \(K\) in this case is not a convolution, \(\beta_{1}\) and \(\bar{\beta}_{2}\) can be combined into a single load-dependent factor. However, for more general queues (e.g., M/G/\(C\) and G/M/\(C\)) the two must still be kept separate. The third view, which ends up being the same as the first, considers all customers, while they are at \(S_{2}\), to act independently. That is, each customer spends a random amount of time at \(S_{2}\), with mean \(Z\), and then, independently of the other customers, goes to \(S_{1}\). The completion rate is exactly \((N-n)/Z\). \(Z\) is called the _think time_, or _delay time_, and \(S_{2}\) is called a _think stage_ or _time-sharing stage_ or _delay stage_, as well as some other names. Clearly, as \(N\) goes to infinity, the arrival rate grows unboundedly, thereby swamping \(S_{1}\). In reality, there never are an infinite number of potential customers, but there may be so many and they may stay at \(S_{2}\) so long that \(n\) (the number at \(S_{1}\)) is always small compared to \(N\), so the departure rate from \(S_{2}\) is more or less constant. In mathematical terms, let \(Z\) grow unboundedly with \(N\), and let

\[\lambda_{\infty}=\lim_{N\to\infty}\frac{N}{Z}.\]

This yields the same solution as case 1.

In all these cases we can make a statement that generalizes (2.1.6c). Let \(\mu_{\infty}\) be the limiting value of \(\mu(N)\); then

\[\lim_{N\to\infty}\Lambda(N)=\min(\mu_{\infty},\lambda_{\infty})\,. \tag{2.1.16}\]

Once again, the throughput of the system is bounded by the maximal capacity of its slowest server.

**Example 2.1.3:** The simplest example of a load-dependent queue is the M/M/2 queue. In this case, \(\beta_{1}(n)=2^{n-1}\), \(\bar{\beta}_{2}(n)=1\),

\[r(0)=\frac{2-\rho}{2+\rho},\]

and

\[r(n)=\frac{2}{K}\left(\frac{\rho}{2}\right)^{n}\quad\mbox{for}\;n>0,\]

where

\[K=2\,\frac{2+\rho}{2-\rho}.\]

We leave it for the reader in Exercise 2.1.8 below to show that

\[\bar{q}_{s}=\frac{4\rho}{4-\rho^{2}},\quad\mbox{and}\quad\bar{T}_{s}=\frac{4 \bar{x}}{4-\rho^{2}}.\]

<!-- Pages 75-75 -->

with time. Inevitably then, the system time, as given by (2.1.7b) will become intolerably long. Call this \(System\) (\(A\)). This leads to two questions: How can the service be improved? And for what value of \(\lambda\) should the improvement be implemented? We consider two possible changes for improvement: either add a second server, or replace the existing one by another that is faster. For simple analysis we assume that the new server is twice as fast. In the latter case, this is still an M/M/1 queue where \(\mu\Rightarrow 2\mu\). Call this \(System\) (\(D\)). In the former case consider two possible implementations. Arriving customers come to a dispatching point, and are then randomly assigned (with equal probability) to either of the two servers, where they then queue for service. It can be shown that this is equivalent to having each server see a Poisson arrival stream, but with arrival rate \(\lambda/2\). This yields two M/M/1 queues. Call this \(System\) (\(B\)). Finally, for \(System\) (\(C\)), customers queue up at the dispatching point, and are assigned to a processor as soon as it becomes idle. This is the M/M/2 described in this section. In Chapter 5 we present another dispatching option.

**Exercise 2.1.9:** Using the results of the previous exercise, show that \(T_{A}>T_{B}>T_{C}>T_{D}\) for all \(0<\lambda<2\). In fact, show that:

\[T_{B}=2\,T_{D}\quad\mbox{and}\quad T_{C}=T_{D}+\frac{1}{2+\lambda}.\]

We seem to have shown that "twice as fast is always better than twice as much," but remember, we have only shown this for Poisson arrivals to exponential servers. In Chapter 6 we show that if the squared coefficient of variation, \(C_{v}^{2}\) is large, this is not necessarily the case.

We have seen _how_ a system might be improved, and now we look at the question as to _when_ it would be cost effective to do so.

<!-- Pages 76-76 -->

**Exercise 2.1.10:** Suppose that one single-speed server costs \(C\) dollars per hour to rent, and that each customer is paid \(S\) dollars per hour. Assume that when a customer is waiting for, or receiving service, his time is being wasted. Then at all times, on average, there are \(\bar{q}_{s}\) customers wasting their time. The total cost then can be given as

\[\$_{A}=C+S\,\bar{q}_{A}(\lambda)\quad\text{and}\quad\$_{I}=2\,C+S\,\bar{q}_{I}( \lambda),\]

where \(I\in\{B,\,C,\,D\}\). We are assuming that the double-fast server costs as much as two single servers. Clearly, for \(\lambda\) very small, \(\$_{A}\) is smaller than the other three, and it doesn't pay to upgrade. But \(\$_{A}\) blows up at \(\lambda=1\) whereas the others don't blow up until \(\lambda=2\). Therefore, the curves must cross somewhere for \(0<\lambda<1\). This must be true for any values of \(C\) and \(S\). In fact, the crossing point depends only on their ratio, \(r=S/C\). Make a graph of the four \(\$_{I}\)s for \(0\leq\lambda<1\) for \(r=0.1,\ 1.0,\ 10.0\), showing the crossings in each case. What are the values of \(\lambda_{I}\) at those points? Now draw three curves on the same graph of \(\lambda_{I}\) versus \(r\).

#### 2.1.6 Departure Process

Let us now consider one last steady-state process before moving on to the transient behavior of the M/M/1 queue. Suppose that an observer is sitting just downstream from \(S_{1}\), measuring the time between departures, without knowing the state of the system. What would she expect to see? In other words, given that a customer has just left, what is the time until the next one leaves \(S_{1}\)? We are asking for the distribution of _interdeparture times_. First we give some appropriate definitions.

_Definition 2.1.5_.

\(X_{d}(N):=\)_r.v. denoting the time between departures for a steady-state M/M/1//N queue \((\)interdeparture times\()\)_.

\[X_{d}:=\lim_{N\to\infty}X_{d}(N)\]

\(b_{d}(t;\,N):=b_{X_{d}(N)}(t)=\) density function for the process. 

This question was originally considered by P. J. Burke [10] and is easy enough to find out once we accept a theorem about M/M/1 queues that is be proven in Section 4.1.3, Theorem 4.1.4. This theorem states that for both open and closed M/M/1 queues, and more generally, M/G/1 (but _not_ G/M/1) queues, the steady-state probability that a departing customer will leave \(n\) fellow customers behind at \(S_{1}\) is the same as the steady-state probability of finding \(n\) there, except that he will never leave \(N\) customers behind, because he, at least, must be at \(S_{2}\). Let \(d(n;N)\) be this probability; then from (2.1.4b)

<!-- Pages 79-79 -->

In general, finding the eigenvalues of a matrix is not a trivial task, particularly if one wants to express them in terms of unspecified parameters rather than numerically. If the dimension of the matrix is small enough, as with (2.1.2) and (2.1.3), the eigenvalues can be found by straightforward, if tedious, methods. In the case of our \(\boldsymbol{Q}\), one of the eigenvalues is zero, thus the characteristic equation can be written as degree \(N\) rather than \(N+1\), the size of \(\boldsymbol{Q}\). It is well known that no general formula (such as the quadratic equation) exists for the roots of polynomials of degree greater than four, nor can one ever be found. (If you have ever used the cubic or quartic formulas to get analytic expressions, you might be inclined to say that even four is too big.) Therefore, unless one is "lucky" (as with the zero eigenvalue), the task is hopeless for \(N>4\).

By a fortuitous stroke of good fortune, because the \(\boldsymbol{Q}\) of (2.1.1c) is so repetitive, \(\phi_{N}(\beta)=|\boldsymbol{Q}-\beta\boldsymbol{I}|\) satisfies a recurrence relation in \(N\) which turns out to be similar to that satisfied by Chebyshev polynomials of the second kind, from which all the eigenvalues can be obtained. The details can be found in [13]. As always, \(\beta_{\mathrm{o}}=0\), and

\[\beta_{k}=\mu+\lambda+2\sqrt{\mu\,\lambda}\,\cos\frac{k\pi}{N+1}\quad\text{ for }k=1,2,3,\ldots,N.\] (2.2.1a) The smallest \[\beta\] is \[\beta_{N}\], which therefore must be \[1/RT\]. As in Exercise 2.1.1, it is convenient to express the relaxation time in units of the time it takes a lone customer to make one cycle \[(1/\mu+1/\lambda)\]. Then, recalling that \[\rho=\lambda/\mu\], and \[\cos[\pi N/(N+1)]=-\cos[\pi/(N+1)]\], we get the following expression for the _normalized relaxation time_. (2.2.1b) \[T(\rho,\,N):=\frac{\mu\lambda}{\mu+\lambda}RT=\frac{\rho}{(1+\rho)}\left(1+ \rho-2\sqrt{\rho}\,\cos\frac{\pi}{N+1}\right)^{-1}.\]

\(T\) is invariant to the replacement of \(\rho\) with \(1/\rho\); that is, \(T(\rho,N)=T(1/\rho,N)\).

Next, we look at \(T(\rho,N)\) when \(N\) is very large. For \(\rho\neq 1\), \(T(\rho,N)\) has a finite limit as \(N\) goes to infinity. Thus the relaxation time for an open system (normalized so that \(1/\mu+1/\lambda=1\)) is

\[T(\rho)\;:=\lim_{N\to\infty}T(\rho,N)=\frac{\rho}{(1+\rho)(1-\sqrt{\rho})^{2} }=T(1/\rho).\] (2.2.2a) It is not hard to show that \[T(\rho)\] approaches \[0.5/(1-\rho)^{2}\] when \[\rho\] is close to \[1\] [12]. As so often happens, \[\rho=1\] must be treated as a special case. We can either set \[\rho=1\], or let \[N\to\infty\], but not both at the same time. \[T(1,N)\] goes to infinity as \[\mathrm{O}(N^{2})\]. We show this by setting \[\rho\] equal to \[1\] in (2.2.1b) to get \[T(1,N)=\frac{1}{2}\left(2-2\cos\frac{\pi}{N+1}\right)^{-1}=\frac{1}{4}\left(1- \cos\frac{\pi}{N+1}\right)^{-1},\] and then use Maclaurin's expansion for \[\cos x\,\left[\cos x=1-x^{2}/2+\mathrm{O}(x^{4})\right]\] : \[T(1,N)=\frac{1}{4}\left[\frac{1}{2}\left(\frac{\pi}{N+1}\right)^{2}+\mathrm{O }\left(\frac{1}{N^{4}}\right)\right]^{-1}\]

<!-- Pages 81-81 -->

are initially at the slower server, very few completions would have to occur to approach the steady state, because very few customers are ever likely to be at the faster server at any one time. Even so, the mean time for one slow server completion (in units of the cycle time) is \(1/(1+\rho)\), which (for small \(\rho\)) is \(1/\rho\) times larger than \(T(\rho,N)\). On the other hand, if all the customers are initially at the faster server, the steady state cannot be approached until almost all of them have been served at least once. The mean time for this is of the order of \(\rho N/(1+\rho)\). The two conditions together imply that

\[0\leq RT\leq\frac{N}{\rho}T(\rho,N),\quad\text{for $\rho<1$.} \tag{2.2.2c}\]

\(RT\) could be \(0\) if the system were initially in its steady state, which means that all queue lengths are possible from the beginning (i.e., we do not know anything).

### 2.3 Other Transient Parameters

In this section we introduce alternative ways (other than \(RT\)) of examining the transient region. We are pleased to find that some of the objects we needed for the steady-state solution are also used here. As with every Markov chain, only one thing at a time can happen in a queueing network; the evolution of the system in time is marked by a discrete sequence of events. We call the interval after one event up to and including the next event an _epoch_.

Figure 2.2.2: **Relaxation times as a function of system population \(N\) for M/M/1 / \(N\) loops**. The RT's for \(\rho\) and \(1/\rho\) are identical; therefore, we only show curves for \(\rho\leq 1\). As \(N\to\infty\), all curves except that for \(\rho=1\) will saturate.

<!-- Pages 82-82 -->

This deviates from conventional use. Feller [14] prefers to use _epoch_ to mean the time the event occured (not the interval). Sometimes, the time between events is called the _sojourn time_.

Such sequences, or epochs, can be represented by _time-dependent state transition diagrams_. The technique described here is easily generalized to include nonexponential and even more general service centers, and that is done in succeeding chapters.

#### 2.3.1 Mean First-Passage Times for Queue Growth

As a first application, we examine the time it takes for a queue to grow from \(0\) to some integer \(n\). Such processes are referred to as _first passages_, and the average times for such events to take place are called _mean first-passage times_, or simply _first-passage times_. The points at which a Markov chain reaches each length for the first time are called _ladder points_. All the things that happen from the time the queue reaches \(j\) to the time it reaches \(j+1\) is said to have "occurred during the \(j\)-th epoch."

Looking at Figure 2.1.1, suppose that initially all the customers are at \(S_{2}\); then in mean time \(1/\lambda\) the first event occurs, corresponding to an arrival to \(S_{1}\) (epoch \(0\) has ended). After that, one of two events can occur: either the customer at \(S_{1}\) returns to \(S_{2}\), or another customer from \(S_{2}\) goes to \(S_{1}\). The sequence of possible events grows factorially after that, and it becomes thoroughly impractical to enumerate all of them. However, if in any sequence the system returns to a state it was in previously, a recursive relation can be set up that may be solvable. This is known as a _regenerative process_[15]. We show how this works in this section and use it frequently in subsequent chapters. To apply this method, one must start with single jumps. So we define

_Definition 2.3.1_.: \(\tau_{u}(n):=\textbf{mean first-passage time}\) _for the queue at \(S_{1}\) to go from \(n\) to \(n+1\). The \(n\)-th epoch begins with \(n\) customers at \(S_{1}\). Customers may leave and arrive in arbitrary order, but eventually there will be \(n+1\) customers at \(S_{1}\) for the first time (end of epoch \(n\) and beginning of epoch \((n+1)\). The mean time for this to happen is \(\tau_{u}(n)\). The subscript \(u\) stands for _u_p. (In subsequent sections we will have occasion to use \(d\) for _d_own and \(m\) for _m_ax.) 

Consider Figure 2.3.1. The circles on the lowest horizontal line correspond to the set of states the system can be in initially, which in the present case is labeled by the number of customers at \(S_{1}\). The second horizontal line represents the state the system is in after one transition. The average time elapsed between the two lines depends on the initial state. Thus if the system started with all customers at \(S_{2}\) [\(n=0\)], the mean time for the first transition would be \(1/\lambda\). Similarly, if all customers were initially at \(S_{1}\)[\(n=N\)], the average time elapsed would be \(1/\mu\). For all other initial states, the time would be \(1/(\mu+\lambda)\). A straight arrow corresponds to a single direct transition, with the probability that it will occur written near it. For instance, the system can go

<!-- Pages 83-83 -->

from \(n\to n+1\) in one step, with probability \(\lambda/(\mu+\lambda)\), with a mean time delay of \(1/(\mu+\lambda)\). A wavy arrow corresponds to the sum of all possible ways the system can get from the tail to the head for the first time, irrespective of the number of transitions taken. Thus the arrow labeled "\(\tau_{u}(n)\)" includes not only the direct transition (\(n\to n+1\)), but also (\(n\to n-1\to n\to n+1\)), and (\(n\to n-1\to n-2\to n-1\to n\to n-1\to n\to n+1\)) and the infinite number of other sequences that eventually lead to \(n+1\).

Our ability to represent an infinite number of sequences by a single symbol is the key to setting up a soluble set of recursive relations. If the system starts with \(n\) at \(S_{1}\), an event will occur in mean time \(1/(\mu+\lambda)\). That event can be one of two things. Either the queue will go directly to \(n+1\), or it will drop to \(n-1\), in which case it will take time \(\tau_{u}(n-1)\) to get back to \(n\), and a further \(\tau_{u}(n)\) to finally get to \(n+1\). Mathematically we can write

\[\tau_{u}(n)=\frac{\lambda}{\mu+\lambda}\cdot\frac{1}{\mu+\lambda}+\frac{\mu}{ \mu+\lambda}\left[\frac{1}{\mu+\lambda}+\tau_{u}(n-1)+\tau_{u}(n)\right],\]

where \(\tau_{u}(0)=1/\lambda\). For convenience, drop the subscript \(u\) when no confusion is likely to arise. The two terms without a \(\tau\) in them combine to yield the following.

\[\tau(n)=\frac{1}{\mu+\lambda}+\frac{\mu}{\mu+\lambda}[\tau(n-1)+\tau(n)].\] (2.3.1a) We interpret this as follows. It takes a mean time of \(1/(\mu+\lambda)\) for something to happen. If the event was an arrival, we are done. The probability that it was not an arrival is \[\mu/(\mu+\lambda)\], in which case the queue will have dropped back to \[n-1\] and take a mean time of \[[\tau(n-1)+\tau(n)]\] to first get back to \[n\] and then to \[n+1\]. Note that \[\tau(n)\] appears on both sides of the equation, indicating that the system got back to where it started, and that is what

Figure 2.3.1: Time-dependent state transition diagram for a closed M/M/1 / \(N\) loop, describing the mean time \([\tau_{u}(n)]\) for a queue to grow by one customer. See text for details.

<!-- Pages 85-85 -->

\[t(0\to n)=\frac{n(n+1)}{2\mu}\quad\text{ for }\rho=1. \tag{2.3.3c}\]

Equations (2.3.3) can be thought of as the mean rate at which a queue grows in time. For instance, we see from (2.3.3c) that for \(\rho=1\) and large \(n\), \(t(0\to n)\) grows as \(n^{2}\). We can get a different insight to this process by thinking of \(t(0\to n)\) as the independent variable. Then we see that \(n\) grows as the square root of \(t\). This is quite similar to behavior of a _random walk_ process, and is in fact a special type of random walk with a barrier. [15] considers such processes to be _renewal processes_.

For \(\rho<1\), (2.3.3b) implies that \(\mu\,t(0\to n)\) approaches \((1/\rho)^{n}/(1-\rho)^{2}\) as \(n\) gets increasingly large. Considering \(n\) as the dependent variable, it follows that \(n\) grows as the \(\log t\). This is indeed an extremely slow growth rate, for although all queue lengths are possible, when \(\rho\) is less than 1, long queue lengths take exponential time to be reached even once.

Finally, for \(\rho>1\), (2.3.3b) implies that \(t(0\to n)\) and \(n\) grow proportionally. This actually makes intuitive sense, whereas the two previous examples are a consequence of statistical fluctuations. Clearly, the arrival rate exceeds the service rate, so with every passing unit of time, customers who have yet to be served accumulate at \(S_{1}\) in proportion to the difference between the arrival and service rates, namely \(\mu(\rho-1)\). Examples for all three cases are shown in Figure 2.3.2. Asymptotic behavior can be summarized by the following equations.

\[n(t) \to\frac{\log(\mu\,t)}{\log(1/\rho)}\quad\text{ for }\rho<1, \tag{2.3.4a}\] \[n(t) \to\sqrt{2\mu\,t}\quad\text{ for }\rho=1,\] (2.3.4b) \[n(t) \to\mu\,t(\rho-1)+\frac{1}{\rho-1}\quad\text{ for }\rho>1. \tag{2.3.4c}\]

These three asymptotic forms are quite different, yet if \(\rho\) is close to 1, \(\mu\,t\) must be rather large before the three will look considerably different.

**Example 2.3.1:** It can be seen from Figure 2.3.2 that the closer \(\rho\) is to 1, the larger \(\mu\,t\) will be before (2.3.4a) or (2.3.4c) deviate from (2.3.4b). An interesting consequence of this is the following. In taking data of such a system (or an ensemble of such systems), an observer cannot measure very accurately what \(\rho\) is, without waiting an extremely long time. Also, note that even after 50 cycle times, the queue has not come anywhere near its steady-state mean queue length for \(\rho>0.9\).

<!-- Pages 86-86 -->

**Exercise 2.3.1:** An interesting variation of \(t(0\to n)\) is to find the mean number of arrivals before the queue reaches its steady-state mean queue length for the first time. Here \(\rho\) must be less than 1, and \(\lambda\,t(0\to n)\) is that quantity, for any \(n\). Let \(n\) be \(\bar{q}\) from (2.1.6b) and draw a curve of \(\lambda\,t(0\to\bar{q})\) versus \(\rho\), for \(\rho\) between 0 and 1. How do these results compare with Figures 2.2.2 and 2.3.2?

#### 2.3.2 \(k\)-Busy Period

A much-used view of queueing systems that does not require waiting for the steady-state is the _busy period_. By definition, a busy period begins when a customer arrives at an empty subsystem and ends when a customer leaves behind an empty subsystem. Put differently, the busy period is the interval between idle periods. In general, one can imagine starting with \(k\) customers at \(S_{1}\) and then have customers come and go until, eventually, the queue drains. This is known as the _\(k\)-busy period_, with \(k=1\) being simply the busy period. A good insight into system behavior can often be gained by taking data over several busy periods, and comparing with analytical results. Unlike the steady state, each period has a well-defined beginning and end.

Figure 2.3.2: Number of customers versus mean first-passage time for the queue at \(S_{1}\) to grow from 0 to \(n\), \(t(0\to n)\), as given by Equations (2.3.3). Equations (2.3.4) show that when \(\rho<1\), \(n\) grows as \(\log\,t\), but when \(\rho>1\), \(n\) grows linearly with \(t\). Yet \(t\) must be very large for this behavior to become apparent if \(\rho\) is close to 1.

<!-- Pages 87-87 -->

#### Mean Time of a Busy Period

The first parameter we consider is the mean time for the busy period. This can be calculated in a manner very similar to the preceding section. Whereas in that section we were interested in queue growth, here we are interested in queue-length reduction. We use the same symbols as before [\(\tau\) and \(t(0\to n)\), etc.], and when a distinction between the two types is necessary, we use subscripts \(u\) for "up" and \(d\) for "down". Otherwise, the subscripts are omitted.

In analogy with Section 2.3.1, with the apparent added restriction that the queue never exceeds \(N\), define the following.

_Definition 2.3.3_

\(\tau_{d}(n;N):=\) _mean first-passage time for the queue at \(S_{1}\) to **drop** from \(n\) to \(n-1\)_, _in an_ M/M/1/ /_N loop_. Given that there are only \(N\) customers in the system, the queue can never exceed \(N\). The process begins with \(n\) customers at \(S_{1}\) and ends when the queue reaches \(n-1\) for the first time and could have risen to \(N\) any number of times in that period of time. 

This actually is exactly analogous to Definition 2.3.1, because \(\tau_{u}(n)\) includes the self-evident constraint that the queue can never drop below 0.

Figure 2.3.3 is similar to Figure 2.3.1, but now the \(\tau_{d}\)-s are pointing toward lower lengths. As before, in mean time \(1/(\mu+\lambda)\), something happens, and if that something is not a departure, then with probability \(\lambda/(\mu+\lambda)\) it is an arrival that raises the queue length by 1, after which it will drift back down to \(n\) in time \(\tau_{d}(n+1;N)\), and finally, to \(n-1\) in further time, \(\tau_{d}(n;N)\). This leads to (dropping the subscripts \(d\))

\[\tau(n;N)=\frac{1}{\mu+\lambda}+\frac{\lambda}{\mu+\lambda}[\tau(n+1;N)+\tau( n;N)], \tag{2.3.5a}\]

Figure 2.3.3: Time-dependent state transition diagram for a closed M/M/1//\(N\) loop describing the mean time [\(\tau_{d}(n)\)] for a queue to decrease by 1 customer. \(\tau_{d}(1)\) is the mean busy period. See text for full details.

<!-- Pages 88-88 -->

where \(\tau(N;N)=1/\mu\). Making the substitution \(\rho=\lambda/\mu\) and the usual rearrangements, we get

\[\mu\tau(n;N)=1+\rho\mu\tau(n+1;N). \tag{2.3.5b}\]

Directly substituting into (2.3.5b) for \(n=N-1\) and \(N-2\), it follows that \(\mu\tau(N-1;N)=1+\rho\), and \(\mu\tau(N-2;N)=1+\rho+\rho^{2}\). One can easily guess, and prove by induction, that

\[\tau(N-k;\,N)=\frac{1}{\mu}\sum_{i=0}^{k}\rho^{i}=\frac{1-\rho^{k+1}}{\mu(1- \rho)}\quad\text{for }\rho\neq 1\] (2.3.6a) and \[\tau(N-k;\,N)=\frac{k+1}{\mu}\quad\text{for }\rho=1, \tag{2.3.6b}\]

where \(k=N-n\). It is clear that when \(\rho\geq 1\), \(\tau_{d}\) grows unboundedly with \(N\) (and \(k\)), but when \(\rho<1\), then

\[\tau_{d}(n):=\lim_{N\to\infty}\tau_{d}(n;\,N)=\frac{1/\mu}{(1-\rho)}\cdot \tag{2.3.6c}\]

We see then, that for an open system, the mean time for a queue to drop by \(1\) is the same for all \(n\), a result that some might call obvious.

By definition, the mean time for a busy (\(1\)-busy) period is the same as the mean time to eventually go from \(n=1\) to \(n=0\). The _\(k\)-busy time_ is defined as follows.

_Definition 2.3.4_

\(t_{d}(k\to 0;\,N):=\)_the mean time for the **k-busy period** of an \(\text{M/M/1}\,//\,N\) loop._ The process begins with \(k\) customers at \(S_{1}\), and ends when there are \(0\) customers there for the first time. 

First we have

\[t_{d}(1\to 0;\,N)=\tau(1;\,N)=\frac{1-\rho^{N}}{\mu(1-\rho)}\quad\text{for }\rho\neq 1\] (2.3.7a) and \[t_{d}(1\to 0;\,N)=\frac{N}{\mu}\quad\text{for }\rho=1. \tag{2.3.7b}\]

As with the \(\tau_{d}\)s, when \(\rho\geq 1\), the mean extent of the busy period grows unboundedly with \(N\), but when \(\rho<1\), the limit for \(t_{d}(1\to 0;\,N)\) exists and approaches [the same as (2.3.6c)]

\[t_{d}:=t_{d}(1\to 0)=t_{d}(1)=\frac{1/\mu}{(1-\rho)}. \tag{2.3.7c}\]

This expression looks familiar. It tells us that the mean busy period for an open M/M/1 queue is the same as its mean system time as given by (2.1.7b).

<!-- Pages 89-89 -->

Actually, (2.3.7c) gives the mean time of a busy period for all open M/G/1 queues (but not G/M/1 queues), whereas the expression for the mean system time for M/G/1 queues [see (4.2.6e) and (4.2.6f)], is more complicated.

An expression for \(t_{d}\) can be derived in the following way. Any single server queue (open or closed) will alternate between busy and idle periods. Let \(T_{i}\) and \(X_{i}\) be the lengths of the \(i\)-th busy and idle periods, respectively. Then

\[R_{b}(m):=\frac{\sum_{i=1}^{m}T_{i}}{\sum_{i=1}^{m}(T_{i}+X_{i})} \tag{2.3.7d}\]

is the fraction of time \(S_{1}\) is busy during the first \(m\) cycles. As \(m\) gets very large, \((\sum T_{i}/m)\) approaches \(t_{d}\), \((\sum X_{i})/m\) approaches the mean idle time (call it \(t_{I}\)), and \(R_{b}\) approaches \(1-r(0,\,N)=\Pr(S_{1}\) is busy). When we put this all together, we get

\[t_{d}=t_{I}\frac{1-r(0,\,N)}{r(0,\,N)}\;. \tag{2.3.7e}\]

For every open single-server queue \((N\to\infty)\), \(r(0,\,N)\to 1-\rho\), and for Poisson arrivals, \(t_{I}=1/\lambda\). All this yields (2.3.7c).

In direct analogy with Equations (2.3.3) we see that the mean time for the \(k\)-busy period is

\[t_{d}(k\to 0;N)=\sum_{j=1}^{k}\tau_{d}(j;N)=\frac{1/\mu}{1-\rho}\sum_{j=1}^{k} (1-\rho^{N-j+1}),\]

which after some straightforward manipulation yields

\[\mu\,t_{d}(k\to 0;N)=\frac{k}{1-\rho}-\frac{\rho^{N-k+1}}{(1-\rho)^{2}}+ \frac{\rho^{N+1}}{(1-\rho)^{2}}\quad\mbox{for $\rho\neq 1$}\] (2.3.8a) and \[\mu\,t_{d}(k\to 0;N)=kN-\frac{k(k-1)}{2}\quad\mbox{for $\rho=1$}. \tag{2.3.8b}\]

As with the \(\tau_{d}\)s for open systems, the \(k\)-busy period is infinite when \(\rho\geq 1\), but when \(\rho<1\),

\[\mu\,t_{d}(k\to 0)=\frac{k}{1-\rho}. \tag{2.3.8c}\]

This makes sense, because it takes a time \(1/[\mu\,(1-\rho)]\) [or what is the same thing, \(\rho/[\lambda(1-\rho)]\)] for an open queue to drop by 1, so if there were \(k\) customers to start with, it should take \(k\) times \(\lambda\rho/(1-\rho)\) to drop to 0.

##### 2.3.2.2 Probability That Queue Will Reach Length \(k\)

Although the time for a busy period may be important, it is by no means the only parameter worth examining. From an experimental point of view, it is easy to measure, for instance, the number of busy periods in which a given queue length was reached or the maximum queue length reached. It is desirable, therefore, to be able to compute these quantities as well.

<!-- Pages 90-90 -->

By now we should be getting pretty good at working with time-dependent state transition diagrams. Unfortunately we now have a new complication. All objects we looked at previously in this section were certain to happen. The busy period was certain to end (if \(\rho\leq 1\)), and all queue lengths will occur eventually. But now we have to worry whether a busy period will end before reaching a given queue length. Such processes are known as _taboo processes_ (it is taboo - or tabu - to reach that given length) which we now define.

_Definition 2.3.5_

Let \(\Xi\) be the set of all possible states of a system. Let \(\Xi_{1}\) and \(\Xi_{2}\) be disjoint proper subsets of \(\Xi\). That is, \(\Xi_{1}\cap\Xi_{2}=\emptyset\) (empty). Also, let \(\Xi_{1}\cup\Xi_{2}\subset\Xi\) (proper subset). That is, \(\Xi_{3}:=\Xi-[\Xi_{1}\cup\Xi_{2}]\neq\emptyset\) (not empty). In other words, \(\Xi_{1},\;\Xi_{2}\), and \(\Xi_{3}\) form a _partition_ of \(\Xi\) (every \(s\in\Xi\) is in one, and only one of the \(\Xi_{i}\)s). A _taboo process_ is one that starts in some state \(s_{i}\in\Xi_{3}\), and ends when the system finds itself in some state \(s_{\!f}\in\Xi_{1}\cup\Xi_{2}\). The process succeeded if \(s_{\!f}\in\Xi_{1}\), and failed if \(s_{\!f}\in\Xi_{2}\) (the taboo states). We are usually interested in \(\textbf{Pr}(s_{\!f}\in\Xi_{1}\,|\,s_{i}\in\Xi_{3})\) (i.e., the probability that the outcome was _good_). If \(\Xi_{2}\) is empty then \(\textbf{Pr}(\cdot)=1\), unless there is no way to get from \(s_{i}\) to \(\Xi_{1}\), in which case \(\textbf{Pr}(\cdot)=\infty\), because by our definition, the process never ends. 

The next processes are examples of taboo processses.

The procedure for calculating probabilities for queue changes is similar to that for calculating the mean time for the change to occur. First we must calculate the probabilities for one step at a time, and then take the product of the probabilities (note that we take the sum of the step times) for the complete process. First define the following.

_Definition 2.3.6_

\(W_{u}(n):=\) _probability that the queue at \(S_{1}\) will go from \(n\) to \(n\!+\!1\) during a busy period_ (i.e., without going to \(0\)). The process begins with \(n\) customers at \(S_{1}\), and ends when the queue (including the active customer) either reaches \(n+1\) or \(0\). The queue can fall and rise any number of times before the process ends. This is a taboo process where \(\Xi=\{s\,|\,0\leq s<\infty\}\), \(\Xi_{1}=\{s\,|\,s>n\}\), \(\Xi_{2}=\{0\}\) and \(\Xi_{3}=\{s\,|\,0<s\leq n\}\). The process starts with \(s_{i}=n\in\Xi_{3}\), and ends when \(s_{\!f}=n+1\in\Xi_{1}\) (good) or when \(s_{\!f}=0\in\Xi_{2}\) (bad). So \(W_{u}(n)=\textbf{Pr}(s_{\!f}\in\Xi_{1}\,|\,s_{i}=n)\). The reader should decide if the taboo concept is helpful for understanding particular processes. 

The queue either goes up [with probability \(\lambda/(\mu+\lambda)\)], or goes down [\(\mu/(\mu+\lambda)\)], in which case it must eventually get back to \(n\) without first going to \(0\) [\(W_{u}(n-1)\)], and then get to \(n+1\), [\(W_{u}(n)\), another regenerative process]. The equation describing this is

\[W_{u}(n)=\frac{\lambda}{\mu+\lambda}+\frac{\mu}{\mu+\lambda}[W_{u}(n-1)W_{u}( n)]. \tag{2.3.9a}\]

<!-- Pages 92-92 -->

Note that (2.3.11a, b, and c) are valid for any customer population as long as \(k\leq N\). Thus they are valid for open systems as well. Observe that as might be expected if \(\rho\leq 1\), then \(W_{u}(1\to k)\) approaches \(0\) as \(k\) gets increasingly large. However, if \(\rho>1\), then

\[\lim_{k\to\infty}W_{u}(1\to k)=\lim_{k\to\infty}\frac{(1-\rho)\rho^{k-1}}{1- \rho^{k}}=1-\frac{1}{\rho}\,. \tag{2.3.11d}\]

In other words, for an open system with \(\rho>1\), the probability that the queue will grow to infinity without the busy period ever ending is \(1-1/\rho\). That is, the probability that a busy period will end is \(1/\rho\). A process that is not guaranteed to end is sometimes referred to as having a _defective probability distribution_[13]. When \(\rho=1\), we have the interesting apparent contradiction that each busy period will surely end \([1-W_{u}(1\to\infty)=1]\), but on average it will take an infinite amount of time to do so.

##### 2.3.2.3 Maximum Queue Length During a Busy Period

The last property that we study in this chapter is the probability that \(S_{1}\)'s maximum queue length in a busy period will be \(k\). Call this \(W_{m}(k;N)\), where \(N\) is the total number of customers in the system. To evaluate this, we not only use the \(W_{u}\)'s of the preceding section, but we also evaluate the probabilities of coming down without ever exceeding \(k<N\). So, define the following.

_Definition 2.3.8_

\(W_{d}(n,k;N)=\) _probability that the queue at \(S_{1}\) will go from \(n\) to \(n-1\) without exceeding \(k\), where \(N\geq k\geq n>0\). The process begins with \(n\) customers at \(S_{1}\) and ends when the queue either reaches \(n-1\) or \(k+1\). Put differently, \(W_{d}(n,k;N)\) is also the probability that the queue will reach \(n-1\) before going to \(k+1\). For \(k=N\), then, \(W_{d}(n,N;N)=1\), because it is certain that the queue will eventually drop by \(1\) from any \(n\). This is yet another taboo process, where \(\Xi_{1}=\{j\,|\,j<n\}\), \(\Xi_{2}=\{j\,|\,k<j\leq N\}\), and \(\Xi_{3}=\{j\,|\,n\leq j\leq k\}\). 

Next we recognize that for \(k<N\),

\[W_{d}(k,k;N)=\frac{\mu}{\mu+\lambda}=\frac{1}{1+\rho}\,.\] (2.3.12a) For \[n<k\], the recursive formulas are exactly analogous to ( 2.3.9 ), namely \[W_{d}(n,k;N)=\frac{\mu}{\mu+\lambda}+\frac{\lambda}{\mu+\lambda}[W_{d}(n+1,k;N )W_{d}(n,k;N)],\] which leads to \[W_{d}(n,k;N)=[1+\rho-\rho W_{d}(n+1,k;N)]^{-1}.\] (2.3.12b) The usual guess and proof by induction gives us an explicit expression for \[W_{d}(n,k;N)=\frac{K(k-n)}{K(k-n+1)}\quad\text{for}\;k<N. \tag{2.3.12c}\]

<!-- Pages 93-93 -->

Notice that this expression is independent of \(N\), as long as \(k<N\). For \(k=N\) it is clear that \(W_{d}(N,N;N)=1\), because the queue cannot grow beyond \(N\). It follows from (2.3.12b) that if \(W_{d}(n+1,N;N)=1\), then \(W_{d}(n,N;N)\) must also equal \(1\). Therefore,

\[W_{d}(n,N;N)=1\quad\text{for }1\leq n\leq N. \tag{2.3.12d}\]

This merely states the obvious, that a closed system will experience every queue length with certainty (not once, but over and over), and of course, irrespective of what \(\rho\) is. It is nice to know that our mathematics sometimes produces the expected. Remember, though, that (2.3.12d) is not necessarily true of open systems.

**Exercise 2.3.2:** Given Equations (2.3.10) and (2.3.12a), prove by induction that (2.3.12c) is the unique solution of (2.3.12b).

Our next task is to calculate the object in the following definition.

_Definition 2.3.9_

\(W_{d}(k\to 0;N):=\) _probability that the queue at \(S_{1}\) will drop from \(k\to 0\) without ever exceeding \(k\)_, _in an_ M/M/1//_N loop_. The process begins with \(k\) customers at \(S_{1}\), and ends when it reaches either \(k+1\) or \(0\).

This must be the product of the probabilities of events cascading downward one stepat a time. Therefore, given that \(K(0)=1\), this is

\[W_{d}(k\to 0;N)=\prod_{n=1}^{k}W_{d}(n,k;N)=\frac{K(k-1)}{K(k)}\frac{K(k-2)}{K(k-1 )}\cdots\frac{K(1)}{K(2)}\frac{K(0)}{K(1)}.\]

All but one of the terms cancel, leaving us with the simple formula

\[W_{d}(k\to 0;N)=\frac{1}{K(k)}=\frac{1-\rho}{1-\rho^{k+1}},\] (2.3.13

<!-- Pages 96-96 -->

## Chapter 3 M. E. Functions

_I shall never believe that God plays dice with the universe_ Albert Einstein

_Einstein, stop telling God what to do._ Niels Bohr

_God not only plays dice. He also sometimes_

_throws the dice where they cannot be seen._

Stephen Hawking

We are now ready to give structure to the subsystems \(S_{1}\) and \(S_{2}\). In Chapter 2 we assumed that each subsystem had only one internal state, which was equivalent to assuming that they were exponential servers. Now we assume that \(S_{1}\) has \(m\) states, but defer consideration of \(S_{2}\) until Chapter 4. Without loss of generality, a subsystem with \(m\) states can be viewed as a network of exponential _phases_, or _stages_, that can be accessed by only one customer at a time; the rest of the customers wait outside until the active one leaves. We show that such a subsystem is in turn equivalent to a single server whose pdf is certainly not exponential. In fact, every pdf that can be written as a finite sum of terms of the form \(x^{k}\exp(-\mu x)\) (any number of terms with any nonnegative integer \(k\), with any number of different \(\mu\)'s whose real part is positive) is equivalent to a subsystem of this form. We know that functions of this type can approximate every pdf arbitrarily closely in some sense. Therefore, we can say that the _closure_ of this set (infinite sums) contains all (well, maybe almost all) pdfs. We also know that every one of these functions has a Laplace transform that can be written as a ratio of two polynomials. Such functions are said to have _Rational Laplace Transforms_ (RLT).

### 3.1 Properties of a Subsystem, \(S\)

Once again, we must start with a series of definitions. Let our subsystem \(S\) be made up of a collection of phases as shown in Figure 3.1.1. The term _stage_ is often used instead of _phase_, and if we are thinking of a subsystem made up of real components, each of these phases, or stages, would be an exponential server in its own right. The reader is welcome to think of them in this light, and indeed we talk of them as though they _are_ real. However, in

<!-- Pages 97-97 -->

the long run they are merely meant to be mathematical building blocks for constructing the matrix operators we need for _Linear Algebraic Queueing Theory_ (**LAQT**). Therefore, we (almost always) adhere to Neuts' convention and call them _phases_[10], because that word is as far from the real thing as we can get.

As in Section 1.3.1, \(\mathbf{M}\) is the _completion rate matrix_ whose diagonal elements are the completion rates of the individual phases in \(S\). \(\mathbf{P}\) is again the transition matrix where \([\mathbf{P}]_{ij}=P_{ij}\) is the probability that a customer will go from phase \(i\) to phase \(j\) when service is completed at \(i\). However, now \(\mathbf{P}\) is not isometric, because it does not satisfy (1.3.1b). Now it is possible for a customer to leave. We define an _exit vector_\(\mathbf{q}^{\prime}\), where \([\mathbf{q}^{\prime}]_{i}=q_{i}\), is the probability of leaving \(S\) when service is completed at \(i\). It then follows that

\[\mathbf{P}\boldsymbol{\epsilon}^{\prime}+\mathbf{q}^{\prime}=\boldsymbol{ \epsilon}^{\prime}.\] (3.1.1a) If \[\mathbf{q}^{\prime}\neq\mathbf{o}^{\prime}\] (with no negative components) and \[P_{ij}\geq 0\], then \[\mathbf{P}\] is said to be substochastic. Assume that for each \[i\] there exists a path to some \[j\] for which \[q_{j}\neq 0\]. This is equivalent to saying that no matter where a customer starts in \[S\], he will eventually leave. It turns out to be equivalent to the statement that \[\left(\mathbf{I}-\mathbf{P}\right)\] has an inverse. We now show that if \[\left(\mathbf{I}-\mathbf{P}\right)\] has an inverse, the customer can always get out (eventually). Let \[x_{i}\] be the probability that a customer who started at phase \[i\] will eventually leave, and let \[\mathbf{x}^{\prime}\] be the column vector whose \[i\] -th component is \[x_{i}\]. Then we can say that the probability of leaving eventually is equal to the probability of leaving immediately \[[q_{i}]\] plus

Figure 3.1.1: Typical subsystem \(\boldsymbol{S}\), with \(\boldsymbol{m}\) phases, and where only one customer can be active at a time. \(\mathbf{p}\) is the _entrance vector_, whose \(i\)-th component is the probability that a customer, upon entering \(S\), will go to phase \(i\). \(\mathbf{q}^{\prime}\) is the _exit vector_, whose \(i\)-th component is the probability that a customer, upon completing service at phase \(i\), will leave \(S\). \(\mathbf{P}\) is the _substochastic transition matrix_, whose \(ij\)-th component is the probability that a customer who has just finished service at \(i\) will go to \(j\). Each phase has exponentially distributed completion time, with mean completion rate \(\mu_{i}=\left(M\right)_{ii}\).

<!-- Pages 98-98 -->

the probability of going instead to some other phase \(j\) [\(P_{ij}\)] and eventually leaving from there [\(x_{j}\)]. Mathematically, this is

\[x_{i}=q_{i}+\sum_{j=1}^{m}P_{ij}x_{j},\]

or in matrix form (another regenerative process),

\[\mathbf{x^{\prime}}=\mathbf{q^{\prime}}+\mathbf{P}\mathbf{x^{\prime}}.\]

This can be rewritten as \((\mathbf{I}-\mathbf{P})\mathbf{x^{\prime}}=\mathbf{q^{\prime}}\). If the inverse exists, there is only one solution to this equation. From (3.1.1a), we have

\[\mathbf{q^{\prime}}=(\mathbf{I}-\mathbf{P})\boldsymbol{\ell^{\prime}}, \tag{3.1.1b}\]

so \(\mathbf{x^{\prime}}=\boldsymbol{\ell^{\prime}}\). In other words, \(x_{i}=1\) for all \(i\); that is, the customer can always get out. The converse is a little different. If the customer can always get out, we only need

\[\lim_{n\to\infty}\mathbf{P}^{n}\boldsymbol{\ell^{\prime}}=\mathbf{o^{\prime}},\]

which is a little weaker than requiring that \((\mathbf{I}-\mathbf{P})^{-1}\) exist. If \(\mathbf{P}\) is substochastic, this must always be true. We avoid the rigorous mathematical issues underlying this by assuming that \((\mathbf{I}-\mathbf{P})\) has an inverse, and leave it at that. A necessary and sufficient condition for this to be true is for \(\mathbf{P}\) to have no eigenvalue equal to \(1\), which physically implies that there are no closed loops and therefore no _absorbing states_ (or _sink states_) in \(S\).

Finally we define the _entrance vector_\(\mathbf{p}\) whose component \(p_{i}\) is the probability that upon entering \(S\), a customer will go directly to phase \(i\). Because the customer must go somewhere, \(\sum_{i=1}^{m}p_{i}=1\), or \(\mathbf{p}\boldsymbol{\ell^{\prime}}=1\) (\(\mathbf{p}\) is isometric, but \(\mathbf{P}\) is not).

#### 3.1.1 Mean Time to Leave \(S\)

We are now in a position to find the mean time it takes for a customer to meander through \(S\) and finally leave. Frequently, we extend this to subsystems where a direct physical picture is false, so we are really dealing with a mathematical analogy rather than a true physical situation. This is no different than talking about electrical currents of the form \(\exp(i\,\omega\,t)\), rather than \(\sin(\omega\,t)\).

Define \(\boldsymbol{\tau^{\prime}}\) to be that column vector whose component \(\tau_{i}\) is the mean time it will take for a customer to leave \(S\), given that he started at \(i\). The path of the customer can be described by the following sequence. First the customer must be served by \(i\), which on the average takes a time of \(1/\mu_{\,i}=(\mathbf{M}^{-1}\boldsymbol{\ell^{\prime}})_{i}\). Then either he leaves (with probability \(q_{i}\), using no additional time) or he goes to phase \(j\) with probability \(P_{ij}\). At this point it will take the customer a time \(\tau_{j}\) to finally leave. Mathematically we have, in vector form,

\[\boldsymbol{\tau^{\prime}}=\mathbf{M}^{-1}\boldsymbol{\ell^{\prime}}+0 \mathbf{q^{\prime}}+\mathbf{P}\boldsymbol{\tau^{\prime}}=\mathbf{M}^{-1} \boldsymbol{\ell^{\prime}}+\mathbf{P}\boldsymbol{\tau^{\prime}}. \tag{3.1.2a}\]

<!-- Pages 99-99 -->

Note both the similarities and differences between this equation and (2.3.1a) and (2.3.5a). In Chapter 2 the population of \(S\) could either increase or decrease, whereas here it can either decrease (the customer leaves) or stay the same. In all cases \(\boldsymbol{\tau^{\prime}}\) appears on both sides of the equation, but here \(\boldsymbol{\tau^{\prime}}\) is a column vector rather than a scalar, so (3.1.2a) stands for \(m\) equations involving the set of \(\tau_{i}\)s (i.e., the \(m\) components of \(\boldsymbol{\tau^{\prime}}\)). As in Section 2.3.1, this is also a regenerative process, but with a difference. The subsystem need not return to the same state, but to any internal state while \(S\) is still active. All \(m\) unknowns can be found simultaneously by solving the matrix equation for \(\boldsymbol{\tau^{\prime}}\) [i.e., \(\boldsymbol{\tau^{\prime}}-\mathbf{P}\boldsymbol{\tau^{\prime}}=(\mathbf{I}- \mathbf{P})\boldsymbol{\tau^{\prime}}=\mathbf{M}^{-1}\boldsymbol{\epsilon^{ \prime}}\)]. Given that \((\mathbf{I}-\mathbf{P})\) has an inverse,

\[\boldsymbol{\tau^{\prime}}=(\mathbf{I}-\mathbf{P})^{-1}\mathbf{M}^{-1} \boldsymbol{\epsilon^{\prime}}=[\mathbf{M}(\mathbf{I}-\mathbf{P})]^{-1} \boldsymbol{\epsilon^{\prime}}.\]

We can now write in concise form,

\[\boldsymbol{\tau^{\prime}}=\mathbf{V}\boldsymbol{\epsilon^{\prime}}, \tag{3.1.2b}\]

where, because they appear so often throughout this treatise, we define

\[\mathbf{B}:=\mathbf{M}(\mathbf{I}-\mathbf{P})\quad\text{ and }\quad\mathbf{V}:= \mathbf{B}^{-1}. \tag{3.1.3}\]

This important relation leads us to give \(\mathbf{V}\) the name _service time matrix_. Its individual components \(V_{ij}\) are interpretable as the mean time a customer spends at \(j\) (counting all visits to it) from the time he first visits \(i\) until he leaves \(S\). \(\mathbf{B}\), the inverse of \(\mathbf{V}\) is of equal importance. \(\mathbf{B}\) looks very similar to the transition rate matrix \(\boldsymbol{Q}\), defined in Section 1.3.1, with the important major difference that \(\boldsymbol{Q}\) describes an entire closed system, and \(\boldsymbol{Q}\boldsymbol{\epsilon^{\prime}}=\mathbf{o^{\prime}}\), whereas \(\mathbf{B}\) refers only to a subsystem, and \(\mathbf{B}\boldsymbol{\epsilon^{\prime}}\) definitely does not equal \(\mathbf{o^{\prime}}\). As shown below, \(\mathbf{B}\) is the generator of the service time distribution, so we give it the name _service rate matrix_. We also express the distributions of other processes in terms of matrices. Therefore, \(\mathbf{B}\) is a _process rate matrix_, and \(\mathbf{V}\) is a _process time matrix_.

As mentioned above, when a customer first enters \(S\) he goes to \(i\) with probability \(p_{i}\), and then spends a total time \(\tau_{i}\) in \(S\) before leaving. Let \(T\) be the random variable denoting the time a customer spends in \(S\) from the moment he enters to the moment he leaves. Then \(\operatorname{\text{\text{\text{\text{\text{\text{\text{\text{\text{\text{\

<!-- Pages 100-100 -->

where \(\mathbf{X}\) is any square matrix. Then (3.1.4a) can be written as

\[\mathbf{E}[T]=\Psi\left[\mathbf{V}\right]. \tag{3.1.4b}\]

\(\Psi\left[\,\cdot\,\right]\) is a _linear operator_, in that it transforms square matrices into complex numbers (i.e., scalars) and has the following properties. Let \(\alpha\) and \(\beta\) be any scalars, and let \(\mathbf{X}\) and \(\mathbf{Y}\) be any square matrices of the same size; then

\[\Psi\left[\alpha\mathbf{X}+\beta\mathbf{Y}\right]=\alpha\Psi\left[\mathbf{X} \right]+\beta\Psi\left[\mathbf{Y}\right].\]

It is also true that \(\Psi\left[\,\cdot\,\right]\) commutes with integration; that is, for any matrix function of \(t\),

\[\int\,\Psi\left[\mathbf{F}(t)\right]dt=\Psi\left[\,\int\mathbf{F}(t)\,dt\right].\]

**Exercise 3.1.1:** Consider \(S\) with two equal phases with completion rate \(\mu\). Assume that a customer always goes to phase 1 upon entering. After finishing at 1, he goes to 2, and after that, leaves. This produces what is called an _Erlangian-2_\((E_{2})\)_distribution_. What are \(\mathbf{p}\), \(\mathbf{P}\), \(\mathbf{q}^{\prime}\), \(\mathbf{M}\), \(\mathbf{B}\), \(\mathbf{V}\), \(\boldsymbol{\tau^{\prime}}\), and \(\mathbf{E}[T]\)?

**Exercise 3.1.2:** Again there are two phases in \(S\), but with different completion rates, \(\mu_{1}\) and \(\mu_{2}\). Suppose that a customer, upon entering, goes to 1 with probability \(p_{1}\), or to 2 (with probability \(p_{2}=1-p_{1}\)), and then leaves when finished. This is known as a _2-phase hyperexponential distribution_, with PDF \(H_{2}(x)\) and pdf \(h_{2}(x)\). In this case, what are: \(\mathbf{p}\), \(\mathbf{P}\), \(\mathbf{q}^{\prime}\), \(\mathbf{M}\), \(\mathbf{B}\), \(\mathbf{V}\), \(\boldsymbol{\tau^{\prime}}\), and \(\mathbf{E}[T]\)?

The importance of \(\mathbf{B}\) is displayed in the next sections.

#### 3.1.2 Service Time Distribution of \(S\)

Once a customer enters a subsystem, his interaction with the outside world is suspended until he exits. An outside observer only sees a beginning and an end to service. One would expect that some density function exists that describes the time spent in \(S\). This is in fact the case. First define the _reliability matrix function_.

_Definition 3.1.1_.: \([\mathbf{R}(t)]_{ij}:=\) _probability that the customer is at phase \(j\) in \(S\) at time \(t\), given that he was at phase \(i\) at time \(0\). The associated vector function, \(\mathbf{R}(t)\boldsymbol{\epsilon^{\prime}}\), is a column vector whose \(i\)-th component is the probability that the customer will still be somewhere in \(S\) at time \(t\), given that he started at phase \(i\) at time \(0\)._

<!-- Pages 103-103 -->

The mean service time of \(S\), as given in (3.1.4b) is a special case of (3.1.9) for \(k=1\).

The _Laplace transform_ of \(b(t)\) can be found in a similar fashion. By definition,

\[B^{*}(s)=\int_{\mathrm{o}}^{\infty}e^{-st}b(t)\,dt,\]

so [using (3.1.7d)],

\[B^{*}(s) =\Psi\left[\int_{\mathrm{o}}^{\infty}\mathbf{B}e^{-st}\exp(-t \mathbf{B})dt\right]=\Psi\left[\int_{\mathrm{o}}^{\infty}\mathbf{B}\exp[-t(s \mathbf{I}+\mathbf{B})]dt\right]\] \[=\Psi\left[\mathbf{B}(s\mathbf{I}+\mathbf{B})^{-1}\left(\int_{ \mathrm{o}}^{\infty}\exp[-t(s\mathbf{I}+\mathbf{B})]d[t(s\mathbf{I}+\mathbf{ B})]\right)\right].\]

Again, the expression inside the large round brackets is \(\mathbf{I}\), so

\[B^{*}(s)=\Psi\left[\mathbf{B}(s\mathbf{I}+\mathbf{B})^{-1}\right]=\Psi\left[ \left(\mathbf{I}+s\mathbf{V}\right)^{-1}\right]. \tag{3.1.10}\]

Equations (3.1.7d), (3.1.8b), (3.1.9), and (3.1.10) are all equivalent in that each can be derived from the others, assuming that \(b(t)\) is not too badly behaved. These results are important enough to summarize in a theorem.

**Theorem 3.1.1:** If a vector-matrix pair \(\boldsymbol{\left\{\mathbf{p}\,,\,\mathbf{B}\right\}}\) (or equivalently, \(\boldsymbol{\left\{\mathbf{p}\,,\,\mathbf{V}\right\}}\) with \(\mathbf{V}=\mathbf{B}^{-1}\)) satisfies any one of the following properties of a probability distribution [(3.1.7b), (3.1.7d), (3.1.8b), (3.1.9), and (3.1.10) respectively]:

\[R(t)=1-B(t)=\Psi\left[\exp(-t\mathbf{B})\right], \tag{3.1.7b}\]

\[b(t)=\frac{dB(t)}{dt}=\Psi\left[\mathbf{B}\exp(-t\mathbf{B})\right], \tag{3.1.7d}\]

\[b^{(k)}(0)=-R^{(k+1)}(0)=(-1)^{k}\Psi\left[\mathbf{B}^{k+1}\right], \tag{3.1.8b}\]

\[\mathbf{E}\left[T^{k}\right]=k!\Psi\left[\mathbf{V}^{k}\right], \tag{3.1.9}\]

\[B^{*}(s)=\int_{\mathrm{o}}^{\infty}e^{-st}b(t)dt\]

\[=\Psi\left[\mathbf{B}(s\mathbf{I}+\mathbf{B})^{-1}\right]=\Psi\left[(\mathbf{ I}+s\mathbf{V})^{-1}\right], \tag{3.1.10}\]

then the other four relations must also be true (i.e., each equation can be used to prove the other four). The pair \(\boldsymbol{\left\{\mathbf{p}\,,\,\mathbf{V}\right\}}\) (or \(\boldsymbol{\left\{\mathbf{p}\,,\,\mathbf{B}\right\}}\)), is said to be a _generator_, or _representation_, of the process whose probability distribution is \(B(t)\) [and therefore of \(b(t)\) and \(R(t)\)]. The matrix, \((\mathbf{I}+s\mathbf{V})^{-1}\), appears often, and is sometimes called the _resolvent matrix_. \(\blacksquare\)

The Laplace transform has an interesting interpretation. Suppose that new customers are arriving at \(S\) with exponential interarrival times with parameter \(s\). Then \(B^{*}(s)\) is the probability that the customer in service will finish before the next customer arrives, given that service has just begun. [See (2.1.1b).]

We have occasion to describe processes other than the time a customer spends in \(S\). Therefore we provide the following generic definition.

<!-- Pages 104-104 -->

**Definition 3.1.3**.: Let \(X\) be the random variable for some process (e.g., _system time_, or _interdeparture time_) whose pdf is \(b_{X}(t)\). Then is a generator of process \(X\) if the equations of Theorem 3.1.1 are satisfied. is the _startup vector_ or _initial vector_ for the process (or _startup process vector_), and is the _process rate matrix_, or the _rate matrix_ for the process \(X\). Only when we are dealing with the service time distribution of \(S\) do we use the terms _entrance vector_ and _service rate matrix_. 

**What If Phases are Nonexponential?**

In deriving Theorem 3.1.1 we have assumed that each of the phases in \(S\) is exponential. One might ask what happens if this constraint is relaxed. Given that the customer wanders sequentially from phase to phase until he leaves, it would be expected that would depend only on the mean time for each of the phases. (Recall that for sequential processes, the sum of the means is equal to the mean of the sum.) In Section 9.3 we prove that this is so. But the higher moments and the overall distribution are different. In particular, the variance for a network of nonexponential servers is given by:

\[\sigma^{2}=\sigma_{e}^{2}+\Psi\left[\mathbf{V}\,\mathbf{T}\,\mathbf{\Gamma} \right], \tag{3.1.11}\]

where and is a diagonal matrix with. For exponential distributions, \(C_{i}^{2}=1\), so and thus the second term on the right is \(0\), as it should be. If all the distributions are deterministic, then \(C_{i}^{2}=0\), and

For more information the reader is referred to Section 9.3.

#### Numerical Algorithm for Evaluating _b(x)_ and _R(x)_

The formulas given in Theorem 3.1.1 are not merely formal connections between functions and matrices. They can actually be used to calculate, efficiently and accurately, the values of \(b(x)\), \(R(x)\), and therefore \(B(x)\), over a set of equally spaced values of \(x\). First note that because of Theorem 1.3.2, and Equation (3.1.6b),

for any \(x\) and \(y\). This is often called the _semigroup property_, and is part of all Markov processes. This equation reduces to (1.2.6c) for 1-dimensional matrices. However, in general the semigroup property does not hold for the reliability functions themselves. That is,

but

\[R(x)R(y)=\mathbf{p}\exp(-x\mathbf{B})\,\boldsymbol{\epsilon^{\prime}}\mathbf{p }\exp(-y\mathbf{B})\boldsymbol{\epsilon^{\prime}}=\mathbf{p}\mathbf{R}(x) \mathbf{Q}\,\mathbf{R}(y)\boldsymbol{\epsilon^{\prime}}.\]

<!-- Pages 105-105 -->

The \(\boldsymbol{\epsilon^{\prime}}\mathbf{p}=\mathbf{Q}\) in the middle prevents \(R(x)R(y)\) from being equal to \(R(x+y)\) unless \(\mathbf{Q}=1\), which can only occur if \(m=1\), that is, only if \(R(x)\) is an exponential function.

Now pick some small, positive \(\delta\) and some positive integer \(k\) (bigger than \(1\), but not too big - more about this later), and evaluate

\[\mathbf{R}(\delta)\approx\mathbf{I}-\delta\mathbf{B}+\frac{1}{2}\delta^{2} \mathbf{B}^{2}-\frac{1}{6}\delta^{3}\mathbf{B}^{3}+\cdots+\frac{1}{k!}(- \delta)^{k}\mathbf{B}^{k}. \tag{3.1.12}\]

If this expression is sufficiently accurate (it certainly can be if \(\delta\) and \(k\) have been chosen wisely), then we have for \(x=n\delta\):

\[\mathbf{R}(x+\delta)=[\mathbf{R}(\delta)]^{n+1}=\mathbf{R}(x)\mathbf{R}( \delta),\]

where \(n\) can be as large as one needs to get sufficiently large \(x=n\delta\).

If it is desired that \(\mathbf{R}(x)\) be evaluated on \(N\) equally spaced points then, using _Horner's rule_[10] (a nested multiplication algorithm), to evaluate (3.1.12), \(N+k\) matrix-matrix multiplications and \(k\) matrix additions are required. The computational complexity is linear in the number of points (one multiplication for each successive point) and of order \(m^{3}\) in the dimension of the matrix. That is, the computational complexity is of order

\[\mathrm{O}\left((N+k)m^{3}\right).\]

We can do much better if we are interested only in the vector \(\mathbf{r}(x)\) and the scalars \(b(x)\), \(R(x)\), and \(B(x)\). We can compute them in the following way. Given a matrix representation, \(\left\{\mathbf{p}\,,\,\mathbf{B}\right\}\):

1. Calculate \(\mathbf{b^{\prime}}:=\mathbf{B}\boldsymbol{\epsilon^{\prime}}\); \(b(0)=\mathbf{p}\mathbf{b^{\prime}}\); \(R(0)=1\).
2. Calculate \(\mathbf{R}(\delta)\) from (3.1.12) using Horner's rule.
3. Set \(\mathbf{r}(0)=\mathbf{p}\).
4. Then (where \(x_{n}=n\delta\)), BEGIN FOR \(n=1\) to \(n=N\), calculate \[\mathbf{r}(x_{n})=\mathbf{r}(x_{n-1})\mathbf{R}(\delta)\] \[R(x_{n})=\mathbf{r}(x_{n})\boldsymbol{\epsilon^{\prime}}\] \[b(x_{n})=\mathbf{r}(x_{n})\mathbf{b^{\prime}}.\] END FOR

This involves only \(k\) matrix multiplications and additions, \(N\) matrix on vector multiplications, and \(2N\) vector on vector multiplications (dot products). This means, then, that the computational complexity is of order

\[\mathrm{O}\left(Nm^{2}\right)+\mathrm{O}\left(km^{3}\right).\]

The term with \(N\) is sure to be the larger by far, therefore we see that this algorithm saves a factor of \(m\) in computational time over the brute-force procedure with which we started. Throughout this book, judicious selection of

<!-- Pages 106-106 -->

procedures can make many computations feasible that were previously impossible by other methods.

We point out from numerical analysis that the problem of selecting appropriate \(\delta\) and \(k\) is the same as the problem one has in trying to solve (3.1.6a) as \(m\) coupled differential equations, using \(k\)-th order _Ordinary Differential Equation_ (ODE) methods. In fact, the method we gave above is related to a method gaining favor in some quarters for more general ODEs, namely the _Taylor series expansion method_. We can even claim that our method is very stable, because all the eigenvalues of \(\mathbf{B}\) have positive real parts (so there is no exponential blowup, the primary cause of instability). There may be a _stiffness_ problem if the smallest eigenvalue is very small compared to the desired distance between points; we must make \(\delta\) small enough to accommodate this.

Our last point has to do with accuracy. From Taylor's remainder theorem, we know that the error in \(\mathbf{R}(\delta)\) is of order

\[\operatorname{O}\left(\delta^{k+1}\right).\]

Because the method is stable, the roundoff error accumulates linearly with \(n\); therefore, the roundoff error at \(x\) is

\[\operatorname{Err}(x)=n\operatorname{O}\left(\delta^{k+1}\right)=x \operatorname{O}\left(\delta^{k}\right).\]

This expression can actually be used to estimate the error by evaluating for two different \(\delta\)'s, and performing an _extrapolation_ procedure. See, for example, [10], or any standard text on numerical analysis for more insight.

**Exercise 3.1.3:** Evaluate \(R(x)\), \(B(x)\), \(b(x)\), \(b^{(\ell)}(0)\), \(\operatorname{\mathbb{E}}[T^{\ell}]\), and \(B^{*}(s)\) for an Erlangian-2 distribution, using the formulas of this section. Let \(0\leq x\leq 10\operatorname{\mathbb{E}}[T]\), \(\delta=0.1\operatorname{\mathbb{E}}[T]\), and \(k=6\) in evaluating \(R(x)\), \(B(x)\), and \(b(x)\). Compare with the exact answers.

**Exercise 3.1.4:** Repeat Exercise 3.1.3 for a 2-phase hyperexponential distribution.

### 3.2 Matrix Exponential Distributions

Up to now we have been vague about the constraints for \(\mathbf{p}\) and \(\mathbf{P}\), and so on. As long as \(M_{ii}>0\), \(\mathbf{P}_{ij}\geq 0\), \((\mathbf{P}\boldsymbol{\epsilon}^{\prime})_{i}\leq 1\) for all \(i,j\), and \((\mathbf{I}-\mathbf{P})^{-1}\) exists, proofs abound that guarantee good behavior. Such distributions are called _PHase (PH) distributions_1 by Marcel F. Neuts [11], [11],

<!-- Pages 107-107 -->

who has studied them extensively. On the other hand, there is a larger class of pdfs for which the conditions may not hold, yet still have a matrix representation. In fact, any pdf that has a rational Laplace transform (RLT) also has a matrix representation [15]. Such functions are sometimes called _Kendall distributions_[11], with symbol, \(K_{m}\) (\(m\) is the number of phases), and their representations are often referred as _Coxian servers_[14], [15], with symbol \(C_{m}\). We will not use those notations further.

An interesting and mathematically important point of view is to start with a representation and see if it corresponds to a true pdf. This and related questions are discussed in great detail in the literature, so we only summarize here. By a _matrix representation_ of some distribution function, we mean a vector-matrix pair \(\{\textbf{p}\,,\,\textbf{B}\}\) (or equivalently, \(\{\textbf{p}\,,\,\textbf{V}\}\), because \(\textbf{B}=\textbf{V}^{-1}\)) which can be used in (3.1.7) to (3.1.10), and thus generates that function. This much we know. As long as **B** is finite-dimensional (as is always the case here unless we say otherwise), \(B^{*}(s)\) as defined in (3.1.10) will always be a ratio of two polynomials, and \(b(t)\), from(3.1.7d), will always be a sum of terms of the form \([f_{n}(x)e^{-\mu x}]\), where \(f_{n}\) is a polynomial of degree \(n\), and \(\Re(\mu)>0\). Furthermore, if all the eigenvalues of **B** have positive real parts, then \(b(t)\) is integrable and integrates to 1. The critical question remains as to whether \(b(t)\) is a pdf [i.e., is it true that \(b(t)\geq 0\) for all real \(t>0\)?]. At present, there is no way one can look at \(\textbf{p}\,,\,\textbf{B}\), or \(B^{*}(s)\) to answer this. The only sure way that it can be done is to examine \(b(t)\) for all relevant \(t\).

We first describe the simple and well-known Erlangian [1] and hyperexponential distributions. We then introduce several useful and interesting distributions, including one with phases having complex service rates. We then introduce a _canonical_ form for representations, namely Erlangians in parallel, sometimes with complex parameters. It turns out (see Section 3.4) that every representation is equivalent to one of these. Furthermore, the canonical representation is of minimal dimension.

#### 3.2.1 Commonly Used Distributions

Before we look at the general classes of ME distributions, we discuss the two most commonly used, overused, and abused types. The reader was already introduced to their simplest nontrivial representatives in the exercises, but it pays to discuss them in some depth.

##### 3.2.1.1 Erlangian Distributions

The Erlangian-\(m\) distribution [for which we use the symbol \(E_{m}(t;\mu)\)] describes the time it takes for a customer to be served by \(m\) identical exponential servers, one at a time (or one server exactly \(m\) times). Formally, let \(X_{i}\) be the random variable representing the time it takes for a customer to be served by the \(i\)-th server, with pdf, \(\mu e^{-\mu t}\) (same \(\mu\) for each server). Let \(Y_{i}\) be the total time it takes for the customer to be served by \(i\) servers (i.e., \(Y_{i}=X_{1}+X_{2}+\cdots+X_{i}\)). Obviously \(Y_{1}=X_{1}\), so its pdf is also \(E_{1}(t;\mu):=\mu e^{-\mu t}\). The pdf for \(Y_{2}\) is the

<!-- Pages 110-110 -->

From our own description, Erlangian distributions should be generated by the subsystem that looks like Figure 3.2.1. Since this is merely a representation of a distribution, we change our terminology for each component from _server_ to _phase_. Remember, a phase is always has an exponential distribution, with a completion rate that may be a complex number, but its real part is always positive. For Erlangian-\(m\) distributions, all the phases have the same \(\mu\), so the completion rate matrix is the \(m\)-dimensional matrix satisfying \(\mathbf{M}=\mu\mathbf{I}\). The transition matrix is given by the following.

\[\mathbf{P}=\left[\begin{array}{cccccc}0&1&0&\cdots&0&0\\ 0&0&1&\cdots&0&0\\ \vdots&\vdots&\vdots&\cdots&\vdots&\vdots\\ 0&0&0&\cdots&0&1\\ 0&0&0&\cdots&0&0\end{array}\right]\right\}\quad m\text{ rows and columns.}\] (3.2.3a) Note that, as in the figure, the matrix elements are in reverse order from the formulas. That is, the \[1\] in the second column of the first row corresponds to the customer going from phase \[m\] to \[m-1\]. This convention is adhered to whenever we deal with Erlangians.

Next define the auxiliary matrix

\[\mathbf{L}:=\mathbf{I}-\mathbf{P}=\left[\begin{array}{cccccc}1&-1&0&\cdots&0 &0\\ 0&1&-1&\cdots&0&0\\ \vdots&\vdots&\vdots&\cdots&\vdots&\vdots\\ 0&0&0&\cdots&1&-1\\ 0&0&0&\cdots&0&1\end{array}\right]. \tag{3.2.3b}\]

The completion rate matrix for the process is

\[\mathbf{B}=\mathbf{M}(\mathbf{I}-\mathbf{P})=\mu\mathbf{I}\,\mathbf{L}=\mu \mathbf{L},\]

with service time matrix

\[\mathbf{V}=\mathbf{B}^{-1}=\frac{1}{\mu}\mathbf{L}^{-1}\]

and \(m\)-dimensional entrance vector

\[\mathbf{p}=[1\ 0\ 0\ \cdots\ 0].\]

One can verify directly that the inverse of \(\mathbf{L}\) is given by

\[\mathbf{L}^{-1}=\left[\begin{array}{cccccc}1&1&1&\cdots&1&1\\ 0&1&1&\cdots&1&1\\ \vdots&\vdots&\vdots&\cdots&\vdots&\vdots\\ 0&0&0&\cdots&1&1\\ 0&0&0&\cdots&0&1\end{array}\right]. \tag{3.2.3c}\]

From the well-known summation rule of binomial coefficients,

\[\left(\begin{array}{c}n+m+1\\ m\end{array}\right)=\sum_{j=0}^{m}\left(\begin{array}{c}n+j\\ j\end{array}\right), \tag{3.2.4a}\]

<!-- Pages 111-111 -->

it follows that

\[\left[\mathbf{L}^{-n}\right]_{ij}=\left(\begin{array}{c}n+j-i-1\\ j-i\end{array}\right)\quad\text{for}\quad i\leq j. \tag{3.2.4b}\]

For instance (if you are concerned, just try a few matrix multiplications),

\[\mathbf{L}^{-3}=\left[\begin{array}{cccccc}1&3&6&10&15&\cdots\\ 0&1&3&6&10&\cdots\\ 0&0&1&3&6&\cdots\\ 0&0&0&1&3&\cdots\\ 0&0&0&0&1&\cdots\\ \vdots&\vdots&\vdots&\vdots&\vdots\end{array}\right].\]

Note that all these matrices are triangular, in that every element below the diagonal is 0 (e.g., \(L_{ij}=0\) if \(i>j\)). If \(\mathbf{P}\) (or \(\mathbf{B}\) or \(\mathbf{V}\)) is of this form, this is referred to as a _feedforward network_. In any case, it can be shown that these matrices reproduce Equations (3.2.1) by purely algebraic manipulation of the equations in Theorem 3.1.1. Indeed, \(\left\{\mathbf{p}\,,\,\mathbf{B}\right\}\) as given here is a faithful representation of the Erlangian-\(m\) pdf.

**Example 3.2.1:** The values of Erlangians for several values of \(m\) have been calculated and plotted in Figure 3.2.2.

These all have a mean of 1 (we

Figure 3.2.2: The pdfs for the Erlangian distributions \(\boldsymbol{E_{m}(x;m)}\) [see (3.2.1a)], with parameter \(\boldsymbol{m=1}\), 2, 3, 4, 5, 10, and 20. All have a mean of 1. They all peak at a value less than their means, namely \(1-1/m\), and get narrower with increasing \(m\), agreeing with the fact that \(C_{v}^{2}=1/m\) also gets smaller.

<!-- Pages 112-112 -->

set \(\mu=m\)) and, except for the exponential, are \(0\) at \(t=0\). Consistent with their values for \(C_{v}^{2}\), these functions get narrower and narrower with increasing \(m\) (\(\sigma_{m}=1/\sqrt{m}\)). In fact, the _Dirac delta function_\(\delta(x)\) [see (5.1.12a) and following] can be defined by the limit

\[\delta(t-T):=\lim_{m\to\infty}E_{m}(t;m/T)\] (3.2.5a) and is a representation of the _deterministic distribution_, the one that always gives a service time of T. In fact one can use the same matrices to represent the _Uniform distribution_ (with r.v. \(U\) ) with pdf \[b_{U}(x)=\left\{\begin{array}{cl}1/2&\mbox{ for }0<x<2T\\ 0&\mbox{ otherwise}\end{array}\right.,\] (3.2.5b) having \[\mbox{\sf E}[U]=T\]. This is done by replacing \[\mathbf{p}=[1\;\;0\;\;0\;\;\cdots\;\;0]\] with \[\mathbf{p}=[1\;\;1\;\;1\;\;\cdots\;\;1]/m\]. This is discussed further below, and in Exercise 3.5.8. \[\blacktriangle\]

The representation as given in Figure 3.2.1 always has the customer starting at phase \(m\). Suppose instead, that he starts at phase \(j\) with probability \(p_{j}\), where \(\sum_{j=i}^{m}p_{j}=1\). In other words, the entrance vector is \(\mathbf{p}=[p_{m},\,p_{m-1},\,\ldots,\,p_{1}]\), where \(\mathbf{p}\boldsymbol{\epsilon}^{\prime}=1\). Then the pdf for such a process is:

\[b(t)=\sum_{j=1}^{m}p_{j}\,E_{j}(t;\,\mu)=\mu\,e^{-\mu t}\left[\sum_{j=1}^{m}p_ {j}\frac{(\mu\,t)^{j}}{(j-1)!}\right]=f(t)\,e^{-\mu t}.\] (3.2.6a) This then, tells us that any polynomial multiplying an exponential function \[e^{-\mu t}\] can be written as a sum of \[E_{j}\] pdfs with parameter \[\mu\]. The constraint that \[\mathbf{p}\boldsymbol{\epsilon}^{\prime}=1\] is equivalent to \[\int_{\mathrm{o}}^{\infty}b(t)\,dt=1.\] The condition that \[p_{i}\geq 0\] guarantees that \[b(t)\geq 0\quad\forall\quad t\geq 0.\] It easily follows from (3.2.1d) that the Laplace transform is \[B^{*}(s)=\int_{\mathrm{o}}^{\infty}b(t)\,e^{-st}\,dt=\sum_{j=1}^{m}\,p_{j} \left(\frac{\mu}{s+\mu}\right)^{j}=\frac{q_{1}(s)}{(s+\mu)^{m}}.\] (3.2.6b) The rightmost term comes from combining fractions, and \[q_{1}(s)\] is a polynomial of degree less than \[m\].

We know from Equations (3.2.1) that \(E_{m}(t;\,\mu)\) gives \(C_{m}^{2}=1/m\). But we can get other values of \(C_{v}^{2}\) between \(1/m\) and \(1\) by varying the \(p_{j}\)s in (3.2.6a). In particular, the reliability function,

\[R(t)=(1+p\mu t)e^{-\mu t}\]

can give any value for \(C_{v}^{2}\) between \(1/2\) and \(1\) by varying \(0\leq p\leq 1\). Obviously, for \(p=1\), \(C_{v}^{2}=1/2\), whereas for \(p=0\), \(C_{v}^{2}=1\). This is considered further in the following exercise.

<!-- Pages 113-113 -->

**Exercise 3.2.1:** Give algebraic expressions for \(\Psi\left[\mathbf{V}\right]\) and \(\Psi\left[\mathbf{V}^{2}\right]\) in terms of \(p\) and \(\mu\), where

\[\mathbf{p}=[p\ \ (1-p)],\qquad\mathbf{M}=\mu\mathbf{I},\]

and \(\mathbf{P}\) is given in (3.2.3a) for \(m=2\). Show that this produces the reliability function given by the equation just before this exercise. Express \(p\) and \(\mu\) in terms of \(\mathbf{E}[X]\) and \(C_{v}^{2}\). In particular, show that

\[p=\frac{1-C_{v}^{2}+\sqrt{2(1-C_{v}^{2})}}{1+C_{v}^{2}}.\]

Show by direct substitution that this gives the correct values for \(p\) when \(C_{v}^{2}=1/2\) and \(1\).

We have one last comment concerning Erlangians. The matrix \(\mathbf{L}\) from (3.2.3b) as well as all its powers, including its inverse, is tridiagonal, with all its diagonal elements being equal (\(L_{ii}=1\)). Therefore, all \(m\) of its eigenvalues are equal to \(1\), but interestingly enough, it only has one left- and one right-eigenvector. Thus, \(\mathbf{L}\) is called a _defective matrix_. In general, if the number of pairs of eigenvectors is less than the dimension of a matrix, then the matrix is defective. This can only happen if at least one eigenvalue is multiple valued (as is the case here), because every eigenvalue must have at least one pair of eigenvectors.

3.2.1.2 Hyperexponential DistributionsThe other widely used class of functions is the family of hyperexponential distributions with density functions of the form

\[h_{m}(t):=p_{1}[\mu_{1}e^{-\mu_{1}t}]+p_{2}[\mu_{2}e^{-\mu_{2}t}]+\cdots+p_{m} [\mu_{m}e^{-\mu_{m}t}]\]

\[=\sum_{j=1}^{m}p_{j}[\mu_{j}\,e^{-\mu_{j}t}],\] (3.2.7a) and reliability function, \[R_{m}(t):=\sum_{j=1}^{m}p_{j}\,e^{-\mu_{j}t}, \tag{3.2.7b}\]

where \(\mu_{j}\)

<!-- Pages 114-114 -->

distribution. Let \(Z_{m}\) be the random variable described by the distribution \(h_{m}(t)\); then its moments are

\[\mbox{\rm\kern 1.29pt\vrule width 0.43pt depth 0.0pt\kern-3.0pt{\rm E}}[\,Z_{m}^{n}\,]=n! \sum_{j=1}^{m}\frac{p_{j}}{\mu_{j}^{n}}, \tag{3.2.7c}\]

and its Laplace transform is

\[B_{Z_{m}}^{*}(s)=\sum_{j=1}^{m}p_{j}\frac{\mu\,_{j}}{\mu\,_{j}+s}=\frac{q_{1}( s)}{q_{2}(s)}, \tag{3.2.7d}\]

where

\[q_{2}(s)=(\mu_{1}+s)(\mu_{2}+s)\cdots(\mu\,_{j}+s)\cdots(\mu_{m}+s)\]

is a polynomial of degree \(m\), and \(q_{1}(s)\) is a polynomial of degree \(m-1\). When a function has a Laplace transform that is a ratio of polynomials we say it has a _Rational Laplace Transform_ (RLT). Note that (3.2.6b) is of the same form. In fact, all ME distributions are RLT, and all RLT functions have an ME representation.

The \(H_{m}\) distributions have an obvious representation. A customer enters a subsystem, and with probability \(p_{j}\) goes to phase \(j\), which has a completion rate of \(\mu\,_{j}\). When finished, he leaves. Then \(M_{jj}=\mu_{j}\), \({\bf P}={\bf O}\), and \({\bf p}\) is the entrance vector whose \(j\)-th component is \(p_{j}\). From this it follows that \({\bf B}={\bf M}\) (pretty simple). It is trivial to show that this is a faithful representation of the \(h_{m}\)s. Also, \(q_{2}(-s)\) is the characteristic function for \({\bf B}\). That is,

\[q_{2}(s)=\mbox{Det}[{\bf B}+s{\bf I}].\]

We show later that this is true for the minimal representation of all ME distributions.

##### Hyperexponential Distributions with Two States

The family of hyperexponentials is so rich in parameters that one is usually left in a quandary as to what values to give them. Even the \(h_{2}\) function has three free parameters (e.g., \(p_{1}\), \(\mu_{1}\), and \(\mu_{2}\)), with the following representation:

\[{\bf p}=[p_{1}\;p_{2}\,],\quad{\bf B}=\left[\begin{array}{cc}\mu_{1}&0\\ 0&\mu_{2}\end{array}\right],\quad\mbox{and}\quad{\bf V}=\left[\begin{array}{ cc}T_{1}&0\\ 0&T_{2}\end{array}\right]\] (3.2.8a) where \[T_{i}:=1/\mu\,_{i}\]. After a specific \[\mbox{\rm\kern 1.29pt\vrule width 0.43pt depth 0.0pt\kern-3.0pt{\rm E}}[Z_{2}]\] and \[\sigma_{2}^{2}\] have been chosen, one more condition is still needed. One should try to fix the third parameter based on the physical system being examined. One possibility is to use the third moment. Assuming that the first three moments are known, one can find \[T_{1},\ T_{2}\], and \[p_{1}\] by solving the simultaneous equations: \[\bar{x}=\mbox{\rm\kern 1.29pt\vrule width 0.43pt depth 0.0pt\kern-3.0pt{\rm E}}[Z_{2}] = p_{1}\,T_{1}+p_{2}\,T_{2}\] \[\mbox{\rm\kern 1.29pt\vrule width 0.43pt depth 0.0pt\kern-3.0pt{\rm E}}[Z_{2}^{2}] = 2(p_{1}\,T_{1}^{2}+p_{2}\,T_{2}^{2})\] (3.2.8b) \[\mbox{\rm\kern 1.29pt\vrule width 0.43pt depth 0.

<!-- Pages 118-118 -->

Therefore, \(R(0_{+})=p_{1}<1\). In other words, there is a finite probability that the event will take \(0\) time. That is, the pdf is more appropriately written as

\[b(x)=p_{2}\,\delta(x)+\frac{p_{1}}{T_{1}}e^{-x/T_{1}},\]

where \(\delta(x)\) is the Dirac \(\delta\) function introduced in Example 3.2.1. From (3.2.8a), the service rate matrix \(\mathbf{B}\), no longer exists (because \(\mu_{2}\to\infty\)). Even so, matrix methods can still be used as long as all measurable quantities can be expressed in terms of the service time matrix,

\[\mathbf{V}=\left[\begin{array}{cc}T_{1}&0\\ &\\ 0&0\end{array}\right].\]

Clearly, \(\mathbf{V}\) no longer has an inverse, but (3.1.9) and the rightmost term in (3.1.10) are still valid. This generalizes to any distribution. That is, if \(\mathbf{V}\) is not invertible, it must have a \(0\) eigenvalue with corresponding state with \(0\) service time (multiple \(0\) eigenvalues can be collapsed to \(1\) state). The probability of going to this state is the size of the initial impulse.

We have seen that \(\mathbf{V}\) has a meaning even when it has no inverse. The case where \(\mathbf{B}\) has no inverse also has a meaning. In this case we have what Feller [11] calls a _defective distribution_, in that

\[\lim_{x\to\infty}R(x)=\lim_{x\to\infty}\mathbf{Pr}(X>x)>0.\]

That is, there is a finite probability that the process will never end, so it has a _defective probability measure_. (Note that defective distributions and _defective matrices_ are unrelated concepts. Defective distributions may have nondefective representations, and nondefective distributions may have defective representations.) In this case,

\[R(x)=p+(1-p)R_{d}(x),\]

where \(R_{d}(x)\) has all the properties of a reliability function; that is, it is monotonic, nonincreasing, \(R_{d}(0)=1\) and \(R_{d}(\infty)=0\). In this case, (3.1.7d), (3.1.8b), and (3.1.10) (the expression with \(\mathbf{B}\) in it) are still valid. Only the moments are meaningless.

**Exercise 3.2.2:** Show by direct integration and use of (3.1.9) and (3.1.10) that \(b(x)\) and \(\mathbf{V}\) produce the same moments and Laplace transform.

Distribution functions with impulse at \(x=0\) are used in Section 4.5.4, and fully discussed in Section 5.1.3. Researchers who use this function as a simple way to get a large variance are introducing a highly singular behavior that may not be reflected in the actual system being investigated.

Often, abuse comes in when the functional form is picked for mathematical convenience, which may badly distort physical reality. We may be guilty of that in the various examples given in this chapter, but we are not looking at any particular system at present, so there should be no harm.

<!-- Pages 123-123 -->

and (if the moments exist)

\[\mathbf{E}\left[T^{n}\right]=n!\Psi\left[\mathbf{V}^{n}\right] \tag{3.2.14d}\]

are purely matrix identities, having no dependence on probability laws. We define the vector-matrix pair \(\boldsymbol{\langle}\mathbf{p},\,\mathbf{B}\boldsymbol{\rangle}\) (or \(\boldsymbol{\langle}\mathbf{p},\,\mathbf{V}\boldsymbol{\rangle}\)) to be a _faithful representation_ of \(b(t)\) if these equations hold.

So, in summary, every distribution of the form in Figure 3.2.5 has a faithful matrix exponential representation as given by Equations (3.2.11). Later we show that this is true for all \(\boldsymbol{\langle}\mathbf{p},\,\mathbf{B}\boldsymbol{\rangle}\).

#### 3.2.3 Other Examples of ME Functions

The class of ME functions described in the previous section are as general as one can get, even if complex probabilities and service rates are allowed. But before proving this assertion we discuss several specific representations. These will be used in succeeding chapters to examine the dependence of performance on variation of distributions. First we provide a definition for describing functions that "look alike".

_Definition 3.2.1_

Two random variables \(T_{1}\) and \(T_{2}\) have distributions with the _same shape_, or of the _same type_ if \(T_{1}=cT_{2}\), or equivalently, if their PDFs satisfy:

\[F_{1}(t)=F_{2}(ct),\quad\text{where}\;\;c>0.\] (3.2.15a) We also say that "\[F_{1}(t)\] and \[F_{2}(t)\] are _similar distributions_ if they have the same shape." It follows that \[f_{1}(t)=c\,f_{2}(ct)\], and \[\mathbf{E}[T_{2}^{\ell}]=c^{\ell}\mathbf{E}[T_{1}^{\ell}]\quad\forall\;\ell \geq 0.\] (3.2.15b) In Definition 3.4.1 of Section 3.4.2 we introduce the idea of _equivalent representations_. Anticipating that, we can say the following. Let \(F_{i}(t)\), \(i=1\), \(2\) be ME distributions that have the same shape; that is, they satisfy (3.2.15a). Then their representations satisfy:

\[\boldsymbol{\langle}\mathbf{p_{1}},\,\mathbf{B_{1}}\boldsymbol{\rangle} \equiv\boldsymbol{\langle}\mathbf{p_{2}},\,c\mathbf{B_{2}}\boldsymbol{\rangle}. \tag{3.2.15c}\]

In other words, \(\boldsymbol{\langle}\mathbf{p_{2}},\,c\mathbf{B_{2}}\boldsymbol{\rangle}\) is a faithful representation of \(F_{1}(t)\), and \(\boldsymbol{\langle}\mathbf{p_{1}},\,c^{-1}\mathbf{B_{1}}\boldsymbol{\rangle}\) is a faithful representation of \(F_{2}(t)\).

If \(T_{1}\) and \(T_{2}\) are ME, then (3.2.15a), (3.2.15b), and (3.2.15c) are equivalent in that each can be used to prove the others. Even in cases where moments and representations do not exist (we show a few in what follows), (3.2.15a) still is meaningful.

Functions that have the _same shape_ form an equivalence class. We can write

\[F_{1}(\cdot)\sim F_{2}(\cdot)\]

if \(F_{1}\) and \(F_{2}\) have the same shape, and '\(\sim\)' is an equivalence relation in that it is symmetric, transitive, and reflexive.

<!-- Pages 124-124 -->

[Note: Feller [Feller71] says that "two distributions \(F_{1}\) and \(F_{2}\), are of the _same type_ if

\[F_{1}(x)=F_{2}(ax+b),\]

or equivalently, if their random variables satisfy

\[X_{1}=aX_{2}+b.\]

He was concerned with distributions that could be greater than \(0\) for all values of \(-\infty<x<\infty\). In such cases, \(b\) allows the two functions to align their origins, often to let \(\mathbb{E}[X_{1}]=0\). We, however, are only concerned with distributions over the range \(0\leq x<\infty\); that is, \(F_{i}(x)=0\) for \(x<0\). In other words, we are willing to _scale_ the means, but not shift them. For example, we would not consider the uniform distribution for \(x\in[0,\,1]\) to be similar to the uniform distribution for \(x\in[1,\,2]\), whereas Feller, by setting \(b=1\) would say they are the same type. In any case, the two ideas are the same as long as \(b=0\). 

From this definition then, all exponential distributions have the same shape. Also, all Erlangians of the same degree have the same shape. But not all hyperexponential distributions have the same shape, even if they have the same degree.

#### 3.2.3.1 A 4-State Hyper-Erlangian

In various modeling applications, the class of Erlangian distributions is used when studying systems where it is expected that \(C_{v}^{2}<1\), whereas hyperexponentials are used when it is expected that \(C_{v}^{2}>1\). But both classes have properties that may be unrealistic in certain applications. For instance, we show in Chapter 5 that the behavior of a G/M/1 queue depends heavily on the behavior of \(b(x)\) near \(x=0\). But all Erlangians have the property that \(E_{m}(0)=0\) for all \(m\geq 2\). On the other hand, all true hyperexponentials have the property that \(h_{m}(0)>0\). What does one do if the true \(b(x)\) has high variance but is still \(0\) at \(x=0\)? What if the reverse is true? We show how to get large variance and still have \(b(0)=0\) in examining a 4-state representation made up of two Erlangian-2 distributions in parallel.

Consider the following representation (where as before, \(T_{i}=1/\mu_{\,i}\)),

\[\mathbf{p}=[p_{1}\ \ 0\ \ p_{2}\ \ 0],\] (3.2.16a) and \[\mathbf{B}=\left[\begin{array}{cccc}\mu_{1}&-\mu_{1}&0&0\\ 0&\mu_{1}&0&0\\ 0&0&\mu_{2}&-\mu_{2}\\ 0&0&0&\mu_{2}\end{array}\right],\quad\mathbf{V}=\left[\begin{array}{cccc}T_{ 1}&T_{1}&0&0\\ 0&T_{1}&0&0\\ 0&0&T_{2}&T_{2}\\ 0&0&0&T_{2}\end{array}\right].\] (3.2.16b) This represents two Erlangian-2 functions in parallel (as in Figure 3.2.5), namely, \[b(x)=p_{1}\left[\mu_{1}(\mu_{1}\,x)e^{-\mu_{1}\,x}\right]+p_{2}\left[\mu_{2}( \mu_{2}\,x)e^{-\mu_{2}\,x}\right], \tag{3.2.16c}\]

<!-- Pages 125-125 -->

with the properties, \(b(0)=0\), and, as we now show, \(0.5\leq C_{v}^{2}<\infty\). In direct analogy with Equations (3.2.8b) we can write:

\[\begin{array}{rcl}\bar{x}=\mbox{\sf E}[Z_{2}]&=&2(p_{1}\,T_{1}+p_{2}\,T_{2}) \\ \mbox{\sf E}[Z_{2}^{2}]&=&6(p_{1}\,T_{1}^{2}+p_{2}\,T_{2}^{2})\\ \mbox{\sf E}[Z_{2}^{3}]&=&24(p_{1}\,T_{1}^{3}+p_{2}\,T_{2}^{3}),\end{array} \tag{3.2.16d}\]

which we manipulate to get:

\[C_{v}^{2}=\frac{\sigma^{2}}{\bar{x}^{2}}=\frac{1}{2}+6\,p_{1}\,p_{2}\left( \frac{T_{1}-T_{2}}{\bar{x}}\right)^{2}. \tag{3.2.16e}\]

Clearly, when \(T_{1}=T_{2}\), \(C_{v}^{2}=1/2\). Also, the difference between \(T_{1}\) and \(T_{2}\) can be made as large as desired, so \(C_{v}^{2}\) is unbounded from above.

Next, we express \(T_{i}\) in terms of the parameters \(\bar{x}\), \(C_{v}^{2}\), and \(p_{1}\). First let

\[\gamma=\frac{2C_{v}^{2}-1}{3}.\]

Then

\[\left.\begin{array}{rcl}\mbox{for}\;\;T_{2}<T_{1}&\left\{\begin{array}{rcl} 2\,T_{1}&=&\bar{x}\left[1+\sqrt{p_{2}\,\gamma\,/\,p_{1}}\right]\\ \\ 2\,T_{2}&=&\bar{x}\left[1-\sqrt{p_{1}\,\gamma\,/\,p_{2}}\right]\end{array} \right\}\end{array}\right\} \tag{3.2.16f}\]

but only if \(p_{1}\,\gamma<p_{2}\); that is, \(p_{1}<3/2(C_{v}^{2}+1)\). Alternatively,

\[\left.\begin{array}{rcl}\mbox{for}\;\;T_{1}<T_{2}&\left\{\begin{array}{rcl} 2\,T_{1}&=&\bar{x}\left[1-\sqrt{p_{2}\,\gamma\,/\,p_{1}}\right]\\ \\ 2\,T_{2}&=&\bar{x}\left[1+\sqrt{p_{1}\,\gamma\,/\,p_{2}}\right]\end{array} \right\}\end{array}\right\} \tag{3.2.16g}\]

but only if \(p_{2}\,\gamma<p_{1}\); that is, \(p_{1}>(2C_{v}^{2}-1)/[2(C_{v}^{2}+1)]\). Only for \(1/2<C_{v}^{2}<2\) (or equivalently, \(0<\gamma<1\)) do both sets of equations apply.

As with the hyperexponential distribution, \(p_{1}\) can be chosen so that the two Erlangians contribute the same to the mean. That is,

\[p_{1}\,T_{1}=p_{2}\,T_{2}=\bar{x}/4\]

\[p_{1|2}=\frac{1}{2}\left(1\pm\sqrt{\frac{\gamma}{1+\gamma}}\,\right),\]

\[T_{1|2}=\frac{\bar{x}}{2}\left[1+\gamma\mp\sqrt{\gamma(1+\gamma)}\,\right],\]

\[\mbox{\sf E}[Z_{2}^{2}]=\bar{x}^{2}(1+C_{v}^{2}),\]

and

\[\mbox{\sf E}[Z_{2}^{3}]=\frac{2}{3}\bar{x}^{3}(C_{v}^{2}+1)(4\,C_{v}^{2}+1).\]

<!-- Pages 126-126 -->

Note that these formulas are valid for all \(1/2\leq C_{v}^{2}<\infty\), but the third moments are somewhat different from those of the hyperexponential distributions.

**Example 3.2.3:** The density function in (3.2.16c) with \(\bar{x}=1\) has been plotted in Figure 3.2.6 for the same values of \(C_{v}^{2}\) and \(\operatorname{\mathbb{E}\kern-1.0pt\mathbb{E}}[X^{3}]\) as for the hyperexponential in Figure 3.2.3. There are several differences between the two sets of curves despite the fact that they have the same first three moments. In addition to having \(b(0)=0\) (except for the exponential curve, which is included here for comparison), most of these curves are bimodal. That is, they have two relative maxima. This cannot be seen on the regular graphs, but are clear in Figure 3.2.7 in the region \(T_{2}\gg T_{1}\).

Clearly, looks can be deceiving. Although these curves look very much like the Erlangian-2 (but with \(\operatorname{\mathbb{E}\kern-1.0pt\mathbb{E}}[X]\approx 0.5\) in Figure 3.2.2), these all have \(C_{v}^{2}>1\), whereas the Erlangian-2 has \(C_{v}^{2}=1/2\). These functions do not even have tails similar to the corresponding ones for the \(h_{2}(x)\) functions. They don't look alike for small \(x\), and they don't look alike for large \(x\) (different slopes on the semilog plots), even though they have the same first three moments. \(\blacktriangle\)

In studying various queues in Chapters 4 and 5, we use this class of functions together with the hyperexponentials in order to study how different pdfs with the same first three moments can affect performance.

Figure 3.2.6: Density functions for a family of hyper-Erlangian-2 distributions with four phases, as defined by Equations (3.2.16). All have a mean value of 1, with \(C_{v}^{2}=1\), 2, 5, 10, and 100, respectively. The curve corresponding to \(C_{v}^{2}=1\) is the exponential distribution. The third condition was chosen to have the same \(\operatorname{\mathbb{E}\kern-1.0pt\mathbb{E}}[X^{3}]\) as the hyperexponentials in Figure 3.2.3.

<!-- Pages 127-127 -->

#### A Non PHase Distribution

We now present an interesting function, first presented by O'Cinneide [17], whose usefulness in queueing theory has not as yet been demonstrated, but it nonetheless shows that non-PHase distributions exist.

Consider the function:

\[b(x)=c\left[1+a\,\cos(\omega\,x+\delta)\right]\,e^{-\mu\,x}.\] (3.2.17a) Assume that all the constants \[(c,\,a,\,\omega,\,\delta,\,\text{and}\,\,\mu)\] are real. Then, as long as \[\mu>0\], the function is integrable over the interval \[[\,0,\,\infty\,)\]. Furthermore, if \[|\,a\,|\leq 1\] it follows that \[b(x)\geq 0\] for all \[x\geq 0\]. Under these conditions, \[b(x)\] is a perfect candidate to be a pdf. Subject to the constraints mentioned above, the parameters \[\omega,\,\delta,\,\text{and}\,\,\mu\] are arbitrary, but \[c\] must be picked to satisfy: \[\int_{\text{o}}^{\infty}b(x)\,dx=1.\] Note that if \[a=\pm 1\] then \[b(x)=0\] for an infinite number of values of \[x\]. Neuts [19] has shown that if a function has \[n\] roots, it must have a PH (all states are real) representation of dimension of at least \[n\]. Therefore there exists no (finite) PHase representation of this \[b(x)\]. But we now find an ME (complex) representation with only three states.

If one recalls the calculus, and has a table of integrals available, it is straightforward, but rather tedious, to perform the integration needed to determine \(c\). However, with the aid of complex analysis, it is possible to rewrite

Figure 3.2.7: **The same curves as in Figure 3.2.6 except that the dependent variable is \(\log[\text{{H}}\!E_{2}(x|C_{v}^{2})]\). In this form it is seen that for functions with large \(C_{v}^{2}\), the curves reach a relative minimum and then rise again before finally going to 0 as \(x\to\infty\). In other words, these functions are bimodal.**

<!-- Pages 128-128 -->

(3.2.17a) so it has the simple form of a hyperexponential distribution with three terms. First let \(i=\sqrt{-1}\), and recall that:

\[e^{\pm i\,t}=\cos(t)\pm i\,\sin(t),\]

or equivalently,

\[\cos(t)=\frac{e^{i\,t}+e^{-i\,t}}{2},\quad\text{and}\quad\sin(t)=\frac{e^{i\,t} -e^{-i\,t}}{2\,i}.\]

Then let \(t=\omega\,x+\delta\) and insert the expression for \(\cos(t)\) into (3.2.17a) to get

\[b(x)=c\left[1+\frac{a}{2}\left(e^{i(\omega\,x+\delta)}+e^{-i(\omega\,x+\delta )}\right)\right]e^{-\mu\,x}.\]

Multiplying out and regrouping, we get a sum of three terms:

\[b(x)=p_{1}\left[\mu\,e^{-\mu\,x}\right]+p_{2}\left[(\mu-i\omega)e^{-(\mu-i \omega)x}\right]+p_{3}\left[(\mu+i\omega)e^{-(\mu+i\omega)x}\right],\]

where

\[\mathbf{p}:=\left[\,p_{1}\,\,\,p_{2}\,\,\,p_{3}\,\right]=c\left[\frac{1}{\mu }\quad\frac{a\,e^{i\delta}}{2(\mu-i\omega)}\quad\frac{a\,e^{-i\delta}}{2(\mu+ i\omega)}\right]. \tag{3.2.17b}\]

This is exactly in the form of (3.2.7a), with the faithful ME representation, \(\boldsymbol{\langle}\,\mathbf{p},\,\mathbf{B}\boldsymbol{\rangle}\), where

\[\mathbf{B}=\left[\begin{array}{ccc}\mu&0&0\\ 0&\mu-i\omega&0\\ 0&0&\mu+i\omega\end{array}\right]. \tag{3.2.17c}\]

We still must find \(c\), but that is simple enough, because \(\mathbf{p}\,\boldsymbol{\epsilon^{\prime}}=1\). Evaluating this expression yields:

\[\frac{1}{c}=\frac{1}{\mu}+a\,\frac{\mu\,\cos(\delta)-\omega\,\sin(\delta)}{ \mu^{2}+\omega^{2}}=\frac{1}{\mu}+\frac{a\cos(\delta+\theta)}{\sqrt{\mu^{2}+ \omega^{2}}}, \tag{3.2.17d}\]

where \(\cos\theta=\mu/\sqrt{\mu^{2}+\omega^{2}}\). Because \(\mathbf{B}\) is diagonal, it follows that

\[\mathbf{R}(x):=\exp(-x\mathbf{B})=e^{-\mu\,x

<!-- Pages 130-130 -->

### 3.3 Distributions With Heavy Tails

As might be presumed, and is shown in Section 3.4.2.2, all ME distributions have _exponential tails_. The _tail_ refers to the behavior of \(R(x)\) when \(x\) is very large. That is, for ME distributions, when \(x\) is very large,

\[R(x)\to c\,x^{n}\,e^{-ax}.\]

In recent years there has been an increasing interest in distributions that are "not well behaved". That is, they go to 0 more slowly than ME functions. Some common terms used are _subexponential, heavy-, fat-, or long-tailed_ distributions. Loosely they have the property

\[\lim_{x\to\infty}\frac{x^{n}\,e^{-\alpha\,x}}{R(x)}=0,\qquad;\forall\ \ \alpha>0,\quad\text{and}\ \ \forall\ \ n.\] (3.3.1a) Equivalently, such functions satisfy the property: \[\int_{\mathrm{o}}^{\infty}e^{ax}\,R(x)\,dx=\infty\qquad\forall\ \ \ a>0.\] (3.3.1b) Hence the term _subexponential_.

#### 3.3.1 Subexponential Distributions

The expressions above are good enough for most applications, but some researchers (see e.g. [1]) have need for a tighter definition. Consider

Figure 3.2.8: **Density and reliability functions \(b_{\pm}(x)\) and \(R_{\pm}(x)\) of Equations (3.2.17), where \(a=\pm 1\), \(\delta=0\), and \(\mu=\omega=1\). Although \(b_{\pm}(x)\) increase and decrease an infinite number of times (not visible on this scale), the \(R_{\pm}(x)\) are monotonically nonincreasing functions of \(x\), as they must be. The exponential function, \(e^{-x}\), is included for comparison.**

<!-- Pages 132-132 -->

are also in use. See, for instance, Trivedi [14] and the discussion following Definition 3.3.3 below.

_Definition 3.3.1_

Let \(L_{1}\) be the set of functions that satisfy (3.3.1a) or (3.3.1b). That is,

\[L_{1}:=\{R(x)\,|\,\eqref{eq:L1}\text{ is satisfied}\}.\]

Then \(L_{1}\) is the set of _heavy-tailed distributions_. Next let

\[L_{2}:=\{R(x)\,|\,\eqref{eq:L1}\text{ is satisfied}\}.\]

Then \(L_{2}\) is the set of _long-tailed distributions_. Finally, let

\[L_{3}:=\{R(x)\,|\,\eqref{eq:L1}\text{ is satisfied}\}\]

Members of \(L_{3}\) are called _subexponential distributions_. It can be shown [13] that

\[L_{3}\subset L_{2}\subset L_{1}.\]

We use all the terms interchangably here, since we will never have a need to make a distinction. We also say that such functions are _ill-behaved functions_, or _not well behaved_. All other functions are _well behaved_.

Subexponential distributions can be divided into two classes: those for which \(\mathbb{E}[X^{\ell}]<\infty\) for all \(\ell\), and those that have infinite moments for \(\ell>\alpha>0\). An example of the former is given here.

**Example 3.3.1:** An example of a function that can be heavy-tailed and has all finite moments is the _Weibull distribution_ (see, e.g., [14]). Its reliability function is given by

\[R(x)=e^{-\lambda x^{a}},\quad\text{for}\quad\lambda,\;a>0,\] (3.3.2a) with pdf \[f(x)=-\frac{d}{dx}R(x)=\lambda\,a\,x^{a-1}\,e^{-\lambda x^{a}}. \tag{3.3.2b}\]

We use (3.3.1c) to get

\[\phi(t;x):=\frac{R(x+t)}{R(x)}=e^{-\lambda[(x+t)^{a}-x^{a}]}=e^{-\lambda

<!-- Pages 134-134 -->

is more useful (see Figure 3.3.10 below). However, a definition that reflects the property of interest is best. By integrating by parts we can show that for \(\ell>0\),

\[\operatorname{\mathbb{E}}[X^{\ell}]=\int_{\mathrm{o}}^{\infty}x^{\ell}\,f(x)\,dx =\ell\int_{\mathrm{o}}^{\infty}x^{\ell-1}\,R(x)\,dx.\]

_Definition 3.3.2_: A random variable \(X\) is _power-tailed with parameter_, \(\alpha\), if its reliability function \(R(x)\) satisfies the following:

\[\operatorname{\mathbb{E}}[X^{\ell}] =\ell\int_{\mathrm{o}}^{\infty}x^{\ell-1}\,R(x)\,dx=\infty\quad \text{for}\;\;\ell>\alpha, \tag{3.3.3d}\] \[\operatorname{\mathbb{E}}[X^{\ell}] =\ell\int_{\mathrm{o}}^{\infty}x^{\ell-1}\,R(x)\,dx<\infty\quad \text{for}\;\;\ell<\alpha,\]

These functions are often called _Pareto distributions_ after the 19th-century economist, Vilfredo Pareto, who used densities of the form \(cx^{\mu-1}/(1+x)^{\alpha+\mu}\) to describe the distribution of wealth in the industrialized world. They are also known as _Levy distributions_, or _Levy-Pareto distributions_, because P. Levy defined and found the class of _stable distributions_ that have these power-tails (but only \(0<\alpha<2\) give non-Gaussian results). 

Feller defines a _slowly varying function_ as one which satisfies

\[\lim_{t\to\infty}\frac{L(tx)}{L(t)}=1.\]

He then says that \(R(x)\) is _regularly varying_ with exponent \(-\alpha\) if

\[R(x)=\frac{L(x)}{x^{\alpha}}\]

and \(L(x)\) is slowly varying. Although this is an interesting property in its own right, it is too restrictive and doesn't explain the vast number of phenomena that have PT behavior. Therefore we do not rely on this property in our presentation. See for example, [11] for a general discussion, [12] for details about stable distributions, and [13] and [14] for full details of material covered here.

The conclusion that a process can have infinite moments requires some discussion. If \(\alpha<2\) then \(X\) has an infinite variance, and if \(\alpha<1\) then \(X\) has an infinite mean! What does an infinite moment indicate? Or, it might be asked, why should we consider them at all? Such questions would normally be outside the scope of this book, but in recent years processes that are important in areas where queueing theory is applied seem to show this kind of behavior. Therefore we must provide some insight to PT behavior so that we can make sense of the solutions to various queues we solve in the next chapters. The rest of this section can be skipped over on first reading.

<!-- Pages 135-135 -->

This subject has been of interest to statisticians for many years, and in recent years it has shown up in many places. It appears that the size of earthquakes, avalanches (see [1]), solar flares, and white noise are power-tailed. Health insurance claims also are PT ([15]). Although it is considered controversial, it appears that the distribution of wealth is also power-tailed. After all, it is a fact that 1% of the population owns 40% of everything in this country, just as it did in the 19th century when Pareto did his studies. (This percentage was at its lowest in the mid 1970's when it dipped to 28% [14].) In subjects closer to queueing applications, in particular computer science and telecommunications, Leland and Ott [13] found that the distribution of CPU times at BELLORE satisfied the PT properties we discuss in this section. (The longest job took over 1,200,000 seconds, 2 weeks, whereas the mean time for the 6 million jobs measured was about 1 second.) Garg et al. [15], Hatem [1], Crovella and Bestavros [16], and others have found that file sizes stored on disks, and even Web page sizes are PT for many orders of magnitude beyond the mean. In a related phenonemon, Leland et al., [13], followed by many others, found that Ethernet, and telecommunications traffic generally, are _self-similar_. If these observations are correct, then system performance prediction must be able to include power-tail behavior, or some truncated version of it.

#### 3.3.3 What Do PT Distributions Look Like?

How can we tell that a process is PT, and why is it only recently being observed? The first question is easy enough to show, but part of the second is answered in Chapter 4. The most characteristic feature of PT distributions is masked when one looks at a plot of \(R(x)\) or \(B(x)\) versus \(x\), since they are both monotonic, approaching a horizontal limit. But if one plots \(\log(R(x))\) versus \(\log(x)\) then one gets a straight line with slope \(-\alpha\), because, from (3.3.3a),

\[\log(R(x))\Longrightarrow\log(c)-\alpha\log(x)\]

This characteristic is unmistakable, as we now show with a simple example.

**Example 3.3.2:** Consider the r.v., \(X_{a}\), with reliability function

\[R_{a}(x)=a\cdot e^{-x}+\frac{1-a}{(1+x)^{2}}\quad\text{for}\;\;0\leq a\leq 1. \tag{3.3.5}\]

It is easy to show that \(\operatorname{\mathbb{E}}(X_{a}]=1\) for all \(a\). But for \(a<1\), it has a power tail with \(\alpha=2\), and thus has infinite variance. Figure 3.3.1 shows this function for \(a\in\{0.0,\,0.5,\,0.8,\,1.0\}\). For \(a=1\) we have the pure exponential function, but on a normal scale (left-hand figure) the other three curves look very similar to the first, so one would expect no surprises, even though they actually have infinite variance. However, in the log-log plot (right-hand figure) the different behavior of the tails becomes visible: all three PT functions show the straight-line behavior described above, with negative slope \(\alpha=2\).

<!-- Pages 137-137 -->

First we discuss residual time behavior, that is, time remaining after some time has already elapsed. Trivedi [17] calls this the _conditional mean exceedance_ (\(\mathbf{CME_{x}}\)).

_Definition 3.3.3_

Let \(X_{>}(x)\) be the r.v. denoting the time for a task, given that it is greater than \(x\). It is not hard to show that the mean remaining time is

\[CME_{x}:=\mathop{\hbox{\rm\hbox{\rm I\kern-2.0pt\hbox{\rm E}}}}[X_{>}(x)]-x= \frac{\int_{x}^{\infty}yf(y)\,dy}{R(x)}=\frac{\int_{x}^{\infty}R(y)\,dy}{R(x)},\] (3.3.6a) where the last expression comes from the previous one by integrating by parts. 

Obviously, \(\mathop{\hbox{\rm\hbox{\rm I\kern-2.0pt\hbox{\rm E}}}}[X_{>}(x)]>x\), but how much greater? If \(R(x)=0\) for \(x>C\), as is the case for the uniform distribution, then \(\mathop{\hbox{\rm\hbox{\rm I\kern-2.0pt\hbox{\rm E}}}}[X_{>}(x)]\) can never exceed \(C\), so

\[\lim_{x\to C}\left\{\mathop{\hbox{\rm\hbox{\rm I\kern-2.0pt\hbox{\rm E}}}}[X_ {>}(x)]-x\right\}=\lim_{x\to C}CME_{x}=0. \tag{3.3.6b}\]

Figure 3.3.2: Comparison of \(R_{\alpha}(x)=1/(1+x)^{2}\) and two sets of 1,000,000 randomly generated samples taken from that distribution, and presented as \(R_{\epsilon}(x)\). On a standard (linear) plot, we would see no difference whatsoever, but even on a log-log plot the three curves are virtually indistinguishable except for the last dozen or so points. The largest 12 samples for each set are shown with \(+\)s and \(\circ\)s. There are not enough data at the end of the curve to give a smooth fit, but those last points still track the straight line. If we had sampled 10,000,000 points instead, the fit would have extended out farther.

<!-- Pages 141-141 -->

If the mean and variance of \(F(\cdot)\) exist, call them \(\bar{x}=\mbox{\sf E}\!\left[X\right]\) and \(\sigma^{2}\), respectively, and define the random variable

\[Z_{n}:=n^{1/2}(A_{n}-\bar{x}). \tag{3.3.9b}\]

Next define the r.v.,

\[Z:=\lim_{n\to\infty}Z_{n}.\]

The _central limit theorem_ states that \(Z\) is _normally distributed_ with mean of \(0\) and variance \(\sigma^{2}\). Let \(\phi(w)=\exp(-w^{2}/2)/\sqrt{2\pi}\) be the pdf of the standard normal distribution (\(\bar{x}=0\) and \(\sigma=1\)), and \(\Phi(w)\) be its PDF. Then for \(n\) "large enough", \(A_{n}\) is normally distributed with mean \(\bar{x}\) and variance \(\sigma^{2}/n\). From a measurement viewpoint, we can state that the probability that \(A_{n}\) will be within \(w\) standard deviations of its mean is given by

\[\mbox{\sf Pr}\left(\bar{x}-w\frac{\sigma}{\sqrt{n}}<A_{n}<\bar{x}+w\frac{ \sigma}{\sqrt{n}}\right)=\Phi(w)-\Phi(-w)=2\Phi(w)-1. \tag{3.3.10a}\]

[We have used the fact that \(\phi\) is symmetric, so \(\Phi(w)=1-\Phi(-w)\).] Equivalently,

\[\mbox{\sf Pr}\left(\left|\frac{A_{n}-\bar{x}}{\bar{x}}\right|>\epsilon\right) =2[1-\Phi(w)]=2\Phi(-w), \tag{3.3.10b}\]

where \(\epsilon=w\sigma/(\bar{x}\sqrt{n})\) is the relative error. In other words, for a fixed probability (or fixed \(w\)), the range of \(A_{n}-\bar{x}\) contracts as \(1/\sqrt{n}\). Thus one can be 95% sure \([2\Phi(2)-1=.9545]\) that the average of 10,000 samples taken from a normal distribution with \(\sigma=1\) [or any other well-behaved distribution] will agree with its expectation value to within two parts in 100, (I.e., \(w\sigma/\bar{x}\sqrt{n}=2/\sqrt{10,000}=0.02\)).

Loosely speaking, we can say that

\[|A_{n}-\bar{x}|=\mbox{O}\left(\frac{1}{\sqrt{n}}\right). \tag{3.3.10c}\]

This tells us that if one wants to double the accuracy (reduce \(\epsilon\) to \(\epsilon/2\)), one must sample four times as many points.

**Example 3.3.4:** For demonstrative purposes, we have simulated 100,000 realizations of \(A_{n}\) for each of \(n=10,\,100,\,1000\), and 10,000. Each random number was taken from the exponential distribution with \(\bar{x}=1\). That is, \(F(x)=1-e^{-x}\). In Figure 3.3.3, we have plotted the number of realizations of \(A_{n}\) that fall in each 0.1 interval. It is seen how the distribution for \(A_{n}\) narrows as \(n\) increases, according to (3.3.10a). The number of realizations of \(Z_{n}\) from (3.3.9b) (where \(\mbox{\sf E}\!\left[Z_{n}\right]=0\)) in each 0.1 interval, is plotted in Figure 3.3.4, where it is seen that the distributions approach \(\phi(x)\) (the normal distribution with 0 mean and unit variance) as \(n\) increases. The different curves visually have approximately the same width and shape, verifying that the original distributions do narrow according to \(1/\sqrt{n}\). Note that even though the exponential distribution is highly unsymmetric, \(Z_{n}\) looks

<!-- Pages 143-143 -->

#### 3.3.5.2 Distributions with Infinite Variance

The problem becomes much more complex if \(F(\cdot)\) has infinite variance. Various researchers have shown (see Feller [15] or Samorodnitsky and Taqqu [16] for details) that if \(X\) is power-tailed with \(1<\alpha\leq 2\), \(Z_{n}\) must be modified to

\[Z_{n}:=n^{\kappa}(A_{n}-\bar{x}),\quad\text{where}\;\;\kappa=1-1/\alpha. \tag{3.3.11}\]

As \(n\) grows larger, \(Z_{n}\) approaches \(Z\), a random variable from a 4-parameter family of distributions, the _\(\boldsymbol{\alpha}\)-stable distributions_ described in [16]. They label them as \(S_{\alpha}(\sigma,\beta,\mu)\), where for \(1<\alpha<2\), \(\sigma\) is a _generalized width_ (or _scale parameter_), \(\mu\) is the mean, and \(\beta\) is a generalized _skewness parameter_. From its definition, \(Z\) has zero mean, and because we are here dealing only with one-sided distributions [\(F(x)=0\) for \(x<0\)], it turns out that \(\beta=1\). Thus, for distributions of interest in this chapter, \(Z_{n}\) approaches the \(\alpha\)-stable random variable \(S_{\alpha}(\sigma,1,0)\), and thus Z has the same distribution as \(S_{\alpha}(\sigma,1,0)\). That is,

\[Z=\lim_{n\to\infty}Z_{n}\stackrel{{ d}}{{=}}S_{\alpha}(\sigma,1,0).\]

Let \(\phi_{\alpha}(x|\,\sigma,1,0)\) be the pdf for \(S_{\alpha}(\sigma,1,0)\), and \(\Phi_{\alpha}(x|\,\sigma,1,0)\) be its PDF, satisfying

\[\Phi_{\alpha}(x|\,\sigma,1,0):=\int_{-\infty}^{x}\phi_{\alpha}(x^{\prime}|\, \sigma,1,0)\,dx^{\prime}.\]

Figure 3.3.4: **This figure shows curves for 100,000 samples of \(Z_{n}\), matching those for \(A_{n}\) in Figure 3.3.3. \(Z_{n}\) is defined in (3.3.9b). The shapes tend toward the normal distribution with 0 mean and unit variance as \(n\) increases (see [15])**

<!-- Pages 145-145 -->

There are several interesting features displayed in Figure 3.3.5. First observe how broad the distributions are, even for \(n=10,000\). Next note that the peaks occur well below the mean, indicating that most measurements (realizations of \(A_{n}\)) will underestimate the mean. Third, observe that the distributions do not tend to become symmetric, a consequence of the one-sidedness of \(R_{Y}(x)\) [\(R_{Y}(x)=0\) for \(x<0\)]. Next, it can be seen from Figure 3.3.6 that the \(Z_{n}\) for different \(n\) have more or less the same width, with peaks at about the same position, albeit of different heights. They clearly are approaching the \(\alpha\)-stable distribution for \(S_{\alpha}(\sigma,1,0)\), but more slowly than well-behaved functions approach the normal distribution. This also demonstrates that the distributions become narrower as \(n\) increases, according to \(1/n^{\kappa}\). Last, it appears that convergence to the \(\alpha\)-stable distribution starts at the tail (very large \(x\)) and gradually converges below the mean [\(\mathbb{E}[Z_{n}]=0\)].

There is further discussion of convergence in the next section. But before going on, observe that if \((X-\bar{x})\stackrel{{ d}}{{=}}S_{\alpha}(\sigma,1,0)\) [i.e., if \(X\) is itself an \(\alpha\)-stable variable, which strictly speaking, can't be if \(F(\cdot)\) is one-sided, see below], then \(Z_{n}\stackrel{{ d}}{{=}}S_{\alpha}(\sigma,1,0)\) for all \(n\), or

\[(A_{n}-\bar{x})\stackrel{{ d}}{{=}}S_{\alpha}(\sigma/n^{\kappa},1,0). \tag{3.3.13b}\]

Therefore the random variables, \(A_{1},A_{2},A_{3},\ldots,A_{n},\ldots\) have distributions that are similar in that they have the same shape, differing only by the scale

Figure 3.3.5: 100,000 samples of the average of \(n\) power-tail samples of \(A_{n}\), for \(n=10,\ 100,\ 1000\), and \(10,000\). The PT distribution function is taken from Section 3.3.6.2, with \(\bar{x}=1\), \(\alpha=1.4\), and \(\theta=0.5\). The scale parameter \(\sigma\) was measured to be \(\approx 0.58126\) (this is not the standard deviation, which is infinite because \(\alpha<2\); see text and [Klingeretal97]). Note how broad the curves are, even for the average of 10,000 samples.

<!-- Pages 146-146 -->

(see Definition 3.2.1). In this sense, \(A_{n}-\bar{x}\) is _self-similar_ (S-S). But because \(Z=\lim Z_{n}\) for any distribution \(F(\cdot)\), one can say that every distribution is _asymptotically self-similar_. This is again a generalization of the CLT which states that all sums of random variables with finite variance approach the normal distribution (Compare Figures 3.3.4 and 3.3.6). However, the term, _self-similar_, is reserved for distributions with infinite variance, the \(\alpha\)-stable distributions \(S_{\alpha}(\sigma,\beta,\mu)\).

Admittedly, this material may be difficult to absorb, and one should read [10] and [11] for greater insight to this subject. However, for our purposes, we can summarize all this by the generalization of (3.3.10c). Thus, the deviation of a measured average from its mean satisfies

\[|A_{n}-\bar{x}|=\mathrm{O}\left(\frac{1}{n^{\kappa}}\right), \tag{3.3.13c}\]

where \(\kappa\) is given in Definition 3.3.4. Equation (3.3.10c) told us that if a distribution is well behaved (and \(\kappa=1/2\)), then a factor of two increase in accuracy requires four times as many data points. But if \(\alpha<2\), the number of samples needed is much bigger. A typical value for \(\alpha\) as seen in data-file sizes or CPU times is \(\alpha\approx 1.4\). In this instance, \(\kappa=1-1/1.4=2/7=.2857\). In order for \(|A_{n_{2}}-\bar{x}|\) to be half as large as \(|A_{n_{1}}-\bar{x}|\), according to (3.3.13c) it is required that

\[\frac{n_{2}^{\kappa}}{n_{1}^{\kappa}}=2,\]

Figure 3.3.6: The sample sets of Figure 3.3.5 were modified by (3.3.11) to get samples of \(Z_{n}\), where \(\mathbb{E}[Z_{n}]=0\). The most salient features are: the curves do not approach a symmetric limit; the peaks occur at \(\approx-\alpha\); the power-tail behavior is still

<!-- Pages 147-147 -->

or for \(\kappa=1-1/\alpha=1-1/1.4=.4/1.4=2/7\),

\[\left(\frac{n_{2}}{n_{1}}\right)=2^{1/\kappa}=2^{3.5}=11.3137.\]

That is, one would need over 11 times as many samples to increase accuracy by a factor of 2. We pursue this further in the next section.

##### Stable Distributions and Measured Averages

From (3.3.13a) and Figure 3.3.5, it can be seen that as with _normal_ distributions, for fixed \(w\), as \(n\) is increased the range of \((A_{n}-\bar{x})\) contracts for PT distributions, but now as \(1/n^{\kappa}\). Because \(\kappa<1/2\) the contraction iwith increasing \(n\) is much slower than for distributions with finite variance. Furthermore, because \(R_{\alpha}(x|\,\sigma,1,0)\) drops off as \(1/x^{\alpha}\), there will always be a nonnegligible probability that the deviation will be large. In other words, no matter how large \(w\) is chosen to be, there will always be a non-negligible (i.e., power-tail law) probability that the error bound will be exceeded, but on the high side only. To give some practical meaning to this, consider the following hypothetical situation.

Suppose that responses to requests over the Internet are sent in some orderly fashion (e.g., a burst of packets with exponential interarrival times - Poisson arrivals), but that the amount of data (in packet units) in each burst-response is distributed according to a PT distribution \(F(\cdot)\), with mean \(\bar{x}\) and parameter \(\alpha\). A potential design criterion could be to create a host node that can handle a given traffic rate \(\lambda\) (in packets/sec), for some specified time interval, with the understanding that it will sometimes be exceeded by more than fraction \(\delta\). \(p\) is the probability that it will be exceeded. Let \(A_{n}\) be the r.v. denoting the average number of packets contained in each of \(n\) successive bursts (i.e., \(A_{n}\times n\) is the total number of packets). Then,

\[\operatorname{\textbf{Pr}}(A_{n}>\bar{x}+w\sigma/n^{\kappa})=R_{\alpha}(w|\,1,1,0),\]

where \(\sigma\) is the generalized width of \(F(\cdot)\). We have assumed that \(n\) is large enough so that the difference between the distributions for \(Z_{n}\) and \(Z\) is negligible, an assumption that must still be investigated. Based on their definitions, \(p\) and \(\delta\) must satisfy

\[p=R_{\alpha}(w|\,1,1,0),\quad\text{and}\quad\delta=w\sigma/(\bar{x}\,n^{ \kappa}

<!-- Pages 149-149 -->

does not guarantee that a future program will not run even longer. In fact we can be sure that ultimately many will. In other words, the size of execution times to come is unbounded. (That's also true of files to come, but we are usually interested in files that presently exist.)

##### Truncation and Range of a Distribution

What we are really interested in is finding a function that represents well the behavior of a given process that produces a large number of samples. If that process is well behaved, then it doesn't make any difference whether the domain of \(F(\cdot)\) is allowed to be finite or infinite. (See Section 3.3.4 for further discussion.) If for instance, \(F(x)=1-e^{-x}\), then the probability that we will ever get a sample more than 50 times greater than the mean is \(e^{-50}=1.93\times 10^{-22}\). If we selected a sample from this distribution every nanosecond, it would take over 160,000 years before even one such sample is likely to occur. Therefore, the debate between finite and infinite extent is meaningless. Thus the practical people let us theoreticians integrate from 0 to \(\infty\) without any worries.

The problem is quite different when we are dealing with PT functions, because, as shown in Section 3.3.4, very big samples occur often enough to affect system averages. For \(R(x)=1/(1+x)^{2}\), a sample greater than 50 times the mean would occur once every 2500 times, or 400 times in a million samples. In fact, a sample more than 1000 times the mean would very likely occur in a million samples, as occurred more than once in Figure 3.3.2. We are really dealing with two issues that are interrelated.

(1) Is the distribution limited in range (or at least does it have an exponentially decaying tail; i.e., is it well behaved)?

(2) Will the system of interest be measured long enough to produce a number of samples \(N\) sufficient to produce a stable average, as in (3.3.7b)?

If both are true, then we can say that the _system is in its steady state._ If (2) is false, then the system is still in its _transient region_. If (1) is not true, then (2) may never be true, no matter what \(N\) is.

The trouble is, unless there are good theoretical reasons, we can never really know if either of (1) and (2) is true. After all, it would take an infinite number of samples (and an infinite amount of time) to test the entire tail. The best that can be done is to collect data, and do some statistical analysis. One direct way is to plot the data according to (3.3.4a) on a log-log scale, as was done in Figure 3.3.2. If the process is well behaved, _and_ enough samples have been taken, then the curve will drop rapidly above some value of \(x=x_{r}\), which we might call the _Range of the distribution_. In Figure 3.3.1 we see that the exponential curve (\(a=1\)) drops rapidly for \(x>2\), whereas, the other curves never drop below a straight line. Figure 3.3.2 shows that the two \(R_{e}(x|10^{6})\) curves don't drop rapidly, they just stop at about \(x=1074.47\) and \(x=1624.53\), respectively. (Remember that \(\bar{x}=1\), we're seeing events that are over 1000 times the mean.) Does this mean that:

(1) 1624.53 is the largest value that will ever be seen (rigid cutoff); or

<!-- Pages 150-150 -->

(2) Only somewhat larger values will be seen (exponential drop in the curve); or

(3) Much larger values will occur as the number of samples increases (the curve continues in a straight line); or

(4) The curve will take some other unknown path?

Of course, without taking any further measurements, we can't tell which of the four will happen. But surely the third option is most likely, at least for one more unit to the right. Since this is a logarithmic scale, multiple samples bigger than 5000 would be expected in the course of selecting another 10,000,000 samples.

Suppose that there are about \(10^{6}\) events in the course of the busy part of any given day. Then the two sets of samples of Figure 3.3.2 could be considered typical days. But one day in ten (a total of \(10^{7}\) events) there will be one or more events that are over 5000 time units. So if we used either of these data sets as the model for a typical day, one day in ten would be very much _out of the ordinary_.

The example we have chosen has \(\alpha=2\), so although it (just barely) has an infinite variance, it has a finite mean that can be measured with the same accuracy as well-behaved functions. That is, given that \(\kappa=1-1/\alpha=1-1/2=1/2\), (3.3.10c) applies. For instance, the measured parameters for the two sample sets have averages of \(\bar{x}_{1}=0.998606\) and \(\bar{x}_{2}=0.996596\), respectively. Both are within a few parts per thousand of each other and of the true mean, satisfying O\((1/\sqrt{10^{6}})=1/1000\). However, the variances of the two sets are, respectively, Var\({}_{1}\) = 11.7748 and Var\({}_{2}\) = 16.3986. Clearly, these give no reasonable estimate of anything. If we had chosen a function that has \(\alpha<2\), then \(\bar{x}_{1}\) and \(\bar{x}_{2}\) would not be so close to each other or the theoretical mean, and Var\({}_{1}\) and Var\({}_{2}\) would both most likely be much bigger (depending on \(\alpha\)) and much further apart. In choosing \(\alpha=2\) we demonstrated the best of the worst.

Let us construct a truncated test function version of \(R(x)=1/(1+x)^{2}\), with random variable \(X_{T}(x_{r})\), that satisfies (2) above as follows.

\[R_{T}(x|x_{r})=\left\{\begin{array}{ccc}1/(1+x)^{2}&\mbox{for}&x<x_{r}\\ \\ e^{(1-x/x_{r})}/(1+x_{r})^{2}&\mbox{for}&x>x_{r}\end{array}\right., \tag{3.3.15}\]

where \(x_{r}\) is the range of \(R_{T}(x|x_{r})\). It can be shown that

\[\mbox{\rm\bf E}[X_{T}]=1-\frac{1}{(1+x_{r})^{2}}\]

and

\[\mbox{\rm\bf E}[X_{T}^{2}]=2\,\log(x_{r}+1)+\frac{2x_{r}(1+3x_{r})}{(1+x_{r}) ^{2}}.\]

If we let \(x_{r}=1624.53\), then this function very well represents the second set of data, but it may be a little too extended for the first set. Plugging into the above equations, we get:

\[\mbox{\rm\bf E}[X_{T}(1624.53)]=0.999,999,620,\ \ \ \mbox{\rm\bf E}[X_{T}(1074. 45)]=0.999,999,135,\]

<!-- Pages 151-151 -->

\[\sigma^{2}(1624.53)=19.781,\ \ \ \ \sigma^{2}(1074.45)=18.952.\]

Obviously, any value picked for \(x_{r}\) that's in this range or bigger will have a negligible affect on the measured mean, but the variance grows as \(\log(x_{r})\), and any performance parameters that depend on the variance will be affected strongly by what is selected for \(x_{r}\). If we had chosen a function with \(1<\alpha<2\) then even the mean, although it exists, would be unstable to numerical measurement, and the variance would grow linearly with \(x_{r}\). In the following chapters we give numerous examples of various performance parameters that depend heavily on the variance (and higher moments), and even other factors such as the value of the pdf near \(x=0\).

So the big question for this section is: "What value for \(x_{r}\) should be chosen for a given application?" This has not been studied significantly until now, but it is worthy of serious research. In any case, based on what has been discussed here, we summarize what can be said at present about TPT distributions with respect to \(x_{r}\).

First determine how many events \([N]\) are likely to occur during the time period of interest. If the distribution is truly truncated, and:

(1) the number of events is large enough for samples comparable to or bigger than \(x_{r}\) to occur \([N>1/R(x_{r})]\), then standard steady-state analytic techniques or simulations will give acceptable results for describing performance during a typical time period; or

(2) the number of events is too small for events as big as \(x_{r}\) to occur even once with significant probability, then for more accurate results, methods designed for transient systems should be used if possible. As a first approximation, reduce \(x_{r}\) to match the sample size and apply standard steady-state techniques. The results should be interpreted as good "most of the time," with the expectation that once in a while performance will be much worse. How often? About once in every \(1/(1-(F(\hat{x}_{r}))^{N})\) time periods, where \(\hat{x}_{r}\) is the range that matches the sample size. How bad the extreme periods are likely to be depends upon \(x_{r}\). The bigger \(x_{r}\) is, the worse the extreme periods are likely to be.

Note that if \(x_{r}\gg\hat{x}_{r}\), then it is not possible to tell the difference between a truncated tail and an infinite one. The extreme periods will occur equally often, and will be very different from the "usual" periods. To put this into everyday perspective, consider the occurence of earthquakes (the size of earthquakes have been measured to be PT over at least 10 orders of magnitude of energy released). On most days the subterranean earth moves very little, and no quakes, or quakes that measure less than 3.0 on the Richter scale occur. Thus no public action is needed. But every few years an earthquake of \(>\) 7.0 occurs, causing serious damage. In terms of planning, it is of no interest to be told that quakes of size \(>\) 12.0 can never occur.

<!-- Pages 152-152 -->

#### 3.3.6.2 An ME Representation of a TPT Distribution

In the previous section we examined reasons why we should look at truncated versions of PT distributions, and showed in (3.3.15) that truncation was easy enough to implement if an appropriate choice could be made for the range \([x_{r}]\) of the process. However, when one takes integrals involving such functional forms (i.e., functions that explicitly have terms such as \(1/x^{\alpha}\)), numerical techniques often must be used. Furthermore, they are ill-suited for use in Markov-type modeling. In particular, they are not ME distributions.

In this section we present a model that mimics in a simple way what could be causing PT behavior. It thus gives some insight as to why power-tails occur. At the same time it provides us with a functional form (first introduced in [11]) that has a power-tail, can be truncated, and, depending on the base function used, can be matrix-exponential, and thus can be used for analytic Markov modeling. The contents of this section are taken from [10].

First consider the following scenario, a variant of which was known in the eighteenth century as Bernoulli's _St. Petersburg paradox_[12]. Suppose a typical computer user chooses to run a program whose CPU time is best described by a distribution function \(F_{\mathrm{o}}(x)\), with a mean of 1.0 seconds. After receiving the result, he decides, with probability 1/2, to run the program again, but with modifications that increase its CPU time by a factor of 2. After receiving the second result, he decides (again with probability 1/2) whether to run the program yet again, with more modifications which increase its CPU time by another factor of 2. Even if this looping continued indefinitely, only 1/2 the users would run their programs more than once, only 1 in 4 users would run their programs more than twice, and less than 1 in a thousand (\(1/2^{10}\)) would run their programs more than 10 times. Call each run a _job_. On average, each user will only run two jobs. So, the frequent user is not common, yet the _mean CPU time_ per job grows unboundedly. If all the jobs executed are taken collectively, then 1/2 of them will be first runs, 1/4 will be second runs, and so on. The mean time per job is given by:

\[\bar{x}=\frac{1}{2}\cdot 1+\frac{1}{4}\cdot 2+\frac{1}{8}\cdot 4+\frac{1}{16} \cdot 8+\cdots+=\frac{1}{2}+\frac{1}{2}+\frac{1}{2}+\cdots=\infty.\]

Of course, it would take an infinite amount of time and an infinite number of users for this sum to be complete. But what would be seen over time is a user behavior that seems to stabilize (an average of two runs per user), but with the infrequent arrival of very big jobs, that get bigger, and cause the mean CPU time per use to grow ever bigger as well. This is a reasonable qualitative description of power-tail behavior generally, where "\(\ell\)-th moment" (\(\ell\geq\alpha\)) replaces "mean CPU time."

A formal mathematical description of the above process is as follows. Let \(X_{\mathrm{o}}\), \(X_{1}\),...\(X_{n}\),... be random variables representing the time for the \(n\)-th rerun of a program, given that it will run at least that many times (\(X_{\mathrm{o}}\) is the initial run, \(X_{1}\) is the first rerun, etc.). Let \(F_{n}(x)\) be the distribution function for \(X_{n}\), with reliability function \(R_{n}(x)\), and density function \(f_{n}(x)\). Next, let

<!-- Pages 157-157 -->

extension of the straight line (\(T=\infty\)). The right-hand graph shows \(R_{Y_{20}}(x)\) and the contributions of the terms for \(n+1=1,\ 5,\ 10,\ 15,\) and \(20\). For instance, the curve labeled "Phase 1" is \(0.5e^{-\mu(20)x}\), where \(\mu(20)=2.729958\) from (3.3.23a). Here we see how the tail "fills in" for increasing \(T\). In some sense, this mimics the way data points accumulate for real systems. For a given set of data, there is a largest member, and very few other elements of comparable size. As more samples are added, a few will be much larger than all previous ones, and the tail fills in. Thus we can map, at least qualitatively, the increase in number of samples (\(N\)) with increase in \(T\).

We explore the structure of (3.3.23b) further by evaluating \(R_{Y}(x)\) (\(T=\infty\)) for various values of \(\alpha\), with \(\operatorname{\boldsymbol{\mathbb{E}}}[X_{\alpha}]=1\). The results are plotted in Figure 3.3.9, both on linear scale and log-log scale. The unlabeled curve is the exponential (\(\alpha=\infty\)). All start at \(R_{\alpha}(0)=1\). The smaller \(\alpha\) is, the faster the curve drops initially, but eventually the curves cross, with smaller \(\alpha\) ending up on top. This is a manifestation of the property described earlier for PT distributions, namely that an individual event is likely to be well below average, but when an above average event occurs, it will likely be well above the mean. This statement becomes more extreme with decreasing \(\alpha\) [see (3.3.12d) and surrounding discussion]. The log-log graph shows the crossings and the straight-line behavior.

The class of functions given by (3.3.23b) is clearly of the hyperexponential type, as in (3.2.7b). But, as seen in Figure 3.3.7, depending on the size of \(T\), \(R_{Y_{T}}(x)\) looks very much like a PT distribution for several orders of magnitude. The concept of _range_ was discussed in the previous section, and can be taken here to be (see [13] for a detailed discussion):

\[x_{r}(T)=\frac{\gamma^{\,T}}{\mu(T)}.\]

From this formula we see that an increase of \(T\) by \(1\) increases the range of

<!-- Pages 160-160 -->

exponential terms with say, Erlangian distributions, as was done in Section 3.2.3.1. However this would double the dimension of the representation from to. Another way to achieve the same effect is to convolute (3.3.24) with a single exponential function, that is, have an exponential of the form follow the TPT function. Then the new PDF, call it with pdf, has a representation of the form:

and

(3.3.25)

This only increases the dimension by one, from to. An alternate representation that is equivalent to puts the extra exponential in front of the TPT function. This is left as an exercise.

**Exercise 3.3.1:** Find from (3.3.25) for arbitrary,, and evaluate the first three moments of using Theorem 3.1.1. Show, using (3.1.8b), that. Why must this be true?

**Exercise 3.3.2:** Construct a representation of where the exponential with parameter is in front of the TPT distribution. Find, and evaluate the first three moments. These should be identical to those in the previous example. Why do the two representations yield the same?

As a final comment, TPT distributions are clearly characterized by their very large. A common belief about distributions with very large coefficient of variation is that most tasks are small to reasonable in magnitude, but every once in a while a big one comes along. This allows for the interpretation that the big ones are exceptional and can be ignored as outliers (lightning struck again). For TPT's this is clearly untrue, for there is no clear boundary between _big_ and _small_. Consider, for instance, the -th moment over scaled intervals. We can say that any TPT density function has asymptotic form up until approaches its range, when it then drops off more rapidly. Let be any number greater than, and consider all such that. Then the partial integrals given by

(3.3.26)

<!-- Pages 162-162 -->

for some \(j\). We discuss the reason why this can happen in the next section, but for now observe that \((\mathbf{I}+s\mathbf{V})^{-1}\) must be proportional to \(1/\phi(s)\), where \(\phi(s)=(\mathrm{Det}[\mathbf{I}+s\mathbf{V}])\). Then \(\Psi\left[(\mathbf{I}+s\mathbf{V})^{-1}\right]\) must yield a ratio of polynomials, say \(q_{2}(s)/q_{1}(s)\), where common factors between \(q_{1}(s)\) and \(q_{2}(s)\) have been removed. Let the degree of \(q_{1}\) be \(m_{1}\) (the dimension of \(\mathbf{V}\) is \(m\)). Then \(m_{1}\leq m\). All the roots of \(q_{1}\) must be elements of the set \(\{-\mu_{j}\}\), but if \(m_{1}<m\) then not all members of that set are roots of \(q_{1}\).

We are now ready to state and prove the theorem for the unique minimal representations.

**Theorem 3.4.1:** Every vector-matrix pair, \(\mathbf{\langle}\mathbf{p},\mathbf{B}\mathbf{\rangle}\) (or \(\mathbf{\langle}\mathbf{p},\mathbf{V}\mathbf{\rangle}\)) with dimension \(m\), and its generated distribution as given in Theorem 3.1.1, is equivalent to a vector-matrix pair (call it \(\mathbf{\langle}\mathbf{p_{c}},\mathbf{B_{c}}\mathbf{\rangle}\), with dimension \(m_{c}\)) of the form surrounding Figure 3.2.5. That is, \(\mathbf{\langle}\mathbf{p_{c}},\mathbf{B_{c}}\mathbf{\rangle}\) generates the same moments and \(b(x)\) as \(\mathbf{\langle}\mathbf{p},\mathbf{B}\mathbf{\rangle}\), and \(m_{c}\leq m\). Furthermore there are no other representations whose dimensions are smaller than \(m_{c}\). This representation is unique to within a reordering of the \(\mu_{j}\)s. Therefore, we call it the _canonical representation_ of \(b(x)\). \(\blacksquare\)

**Proof:** First recall that \(\mathbf{\langle}\mathbf{p},\mathbf{B}\mathbf{\rangle}\) generates a Laplace transform by (3.2.14b) that is RLT. Next note that every ratio of polynomials can be written as partial fractions [sums of terms whose denominators are of the form \((s-\mu_{i})^{m_{i}}\)], which can then be manipulated into the form given in (3.2.13a). The parameters in (3.2.13a) then map directly into Figure 3.2.5 and the minimal representation \(\mathbf{\langle}\mathbf{p_{c}},\mathbf{B_{c}}\mathbf{\rangle}\). The Laplace transform of every well-behaved function is unique (to within a set of measure 0), and because \(\mathbf{\langle}\mathbf{p_{c}},\mathbf{B_{c}}\mathbf{\rangle}\) and \(\mathbf{\langle}\mathbf{p},\mathbf{B}\mathbf{\rangle}\) have the same Laplace transform, they must represent the same \(b(x)\). **QED**

#### 3.4.2 Isometric Transformations

We now present a purely linear algebraic approach that yields Theorem 3.4.1. It is also more general because it does not rely on a specific entrance vector \(\mathbf{p}\). This can be useful in analyzing compound processes and semi-Markov processes. First consider the following definition.

_Definition 3.4.1_

_Let \(\mathbf{\langle}\mathbf{p_{1}}\mathbf{,\,B_{1}}\mathbf{\rangle}\) and \(\mathbf{\langle}\mathbf{p_{2}}\mathbf{,\,B_{2}}\mathbf{\rangle}\) be two vector-matrix pairs. Then they are **equivalent** if and only if they have the same moments according to (3.2.14c), or have the same Laplace transform according to (3.2.14a), Any one of the three can prove the other two if the \(\mathbf{B}\) matrices are invertible. If they are equivalent, we write_

\[\mathbf{\langle}\mathbf{p_{1}}\mathbf{,\,B_{1}}\mathbf{\rangle}\equiv\mathbf{ \langle}\mathbf{p_{2}}\mathbf{,\,B_{2}}\mathbf{\rangle}.\]

They do not have to be of the same dimension to be equivalent. \(\blacksquare\)

<!-- Pages 164-164 -->

This theorem is true even if one of the eigenvalues of \(\mathbf{B}\), call it \(\mu\), satisfies \(\Re(\mu)<0\) [i.e., \(b(t)\) is not a density function]. Then,

1. \(\lim_{t\to\infty}b(t)=\infty\)
2. The integral definition of \(B^{*}(s)\) only exists for \(\Re(s)>-\Re(\mu)\)
3. The moments, \(\mathbf{E}[X^{\ell}]\), do not exist.

The term _isometric transformation_ was chosen for the following reason. If we consider the sum of the components of a vector \(\mathbf{r}\) to be its (pseudo)"_length_," then an isometric transformation preserves the length of every row vector; that is, \(\mathbf{r}\,\boldsymbol{\epsilon^{\prime}}\) is invariant. However, we must be careful, because the sum can be negative and thus cannot be used as a "metric" in the mathematical metric space sense. In any case, a transformation which does not change that length is _iso-metric_ (_iso_ means "same", and _metric_ means "length").

We now show that any matrix that preserves length in this sense must be isometric. Let \(\mathbf{r}\) be any row vector, and \(\mathbf{S}\) be an invertible matrix. Then \(\mathbf{\tilde{r}}=\mathbf{r}\,\mathbf{S}^{-1}\) is the transformed vector, and

\[\left[\mathbf{\tilde{r}}\,\boldsymbol{\epsilon^{\prime}}=\mathbf{r}\,\mathbf{S }^{-1}\boldsymbol{\epsilon^{\prime}}=\mathbf{r}\,\boldsymbol{\epsilon^{\prime} }\quad\forall\quad\mathbf{r}\right]\ \Longleftrightarrow\ \left[\mathbf{S}^{-1}\,\boldsymbol{\epsilon^{\prime}}= \boldsymbol{\epsilon^{\prime}}\right].\]

The proof follows from the fact that the only column vector which is orthogonal (\(\mathbf{u}\,\mathbf{v}^{\prime}=0\)) to every row vector is the one with all zeros, therefore, \(\mathbf{v}^{\prime}:=\mathbf{S}^{-1}\boldsymbol{\epsilon^{\prime}}- \boldsymbol{\epsilon^{\prime}}=\mathbf{o}^{\prime}\), because \(\mathbf{rv}^{\prime}=0\) for all \(\mathbf{r}\). See [13] for details.

**Example 3.4.1:** A straightforward example of the invariance of isometric transformations is permuting the labels of the phases of any \(\left\{\,\mathbf{p},\,\mathbf{B}\,\right\}\). Changing the labels requires interchanging the components of \(\mathbf{p}\) and interchanging the rows and columns of \(\mathbf{B}\). It is well known that this can be done formally with the use of _permutation matrices_. These are \(0-1\) matrices with exactly one '1' in each row and column. In all cases, then, their row-sums are 1, so they are automatically isometric. For instance, for a two-dimensional representation, in order to interchange phases 1 and 2, one uses the matrix:

\[\mathbf{S}=\left[\begin{array}{cc}0&1\\ 1&0\end{array}\right].\]

In this case, \(\mathbf{S}^{-1}=\mathbf{S}\), so

\[\mathbf{\tilde{p}}=\mathbf{p}\mathbf{S}^{-1}=[p_{1},\,p_{2}]\left[\begin{array} []{cc}0&1\\ 1&0\end{array}\right]=[p_{2},\,p_{1}],\]

and

\[\mathbf{\tilde{B}}=\left[\begin{array}{cc}0&1\\ 1&0\end{array}\right]\left[\begin{array}{cc}B_{11}&B_{12}\\ B_{21}&B_{22}\end{array}\right]\left[\begin{array}{cc}0&1\\ 1&0\end{array}\right]=\left[\begin{array}{cc}B_{22}&B_{21}\\ B_{12}&B_{11}\end{array}\right].\]

Thus by Theorem 3.4.2, we have proven what most people would consider obvious, namely that changing the numbering on the phases leaves all

<!-- Pages 166-166 -->

1. \(m_{k}=1\) and \(n_{k}=0\); then \(\mathbf{u}_{\mathbf{k}}\,\boldsymbol{\epsilon^{\prime}}=0\),
2. \(m_{k}>1\) but there is only one left eigenvector; then either \(n_{k}=m_{k}\) or \(n_{k}=0\). In the latter case, \(\mathbf{u}_{\mathbf{k}}\,\boldsymbol{\epsilon^{\prime}}=0\),
3. \(m_{k}>1\) and there are several left eigenvectors; then \(n_{k}\leq m_{k}\). If \(n_{k}=0\), then all the eigenvectors are orthogonal to \(\boldsymbol{\epsilon^{\prime}}\). If \(n_{k}>0\) then a linear combination of the eigenvectors can be found such that all but one (at most) are orthogonal to \(\boldsymbol{\epsilon^{\prime}}\).

In other words, every eigenvalue that appears in \(f_{n}(y)\) has exactly one left eigenvector that is not orthogonal to \(\boldsymbol{\epsilon^{\prime}}\). The number of such eigenvectors is \(\kappa\). We next show how the others can be thrown away.

Consider the _Jordan canonical form_ (see, e.g., [10]) for matrices, For each finite-dimensional square matrix), call it \(\mathbf{B}\), there always exists a nonsingular matrix \(\mathbf{R}\) such that

\[\mathbf{R}\mathbf{B}\mathbf{R}^{-1}=\left[\begin{array}{ccccc}\mu_{1} \mathbf{X}_{1}&\mathbf{0}&\mathbf{0}&\cdots&\mathbf{0}\\ \mathbf{0}&\mu_{2}\mathbf{X}_{2}&\mathbf{0}&\cdots&\mathbf{0}\\ \vdots&\vdots&\vdots&\cdots&\vdots\\ \mathbf{0}&\mathbf{0}&\mathbf{0}&\cdots&\mu_{K_{B}}\mathbf{X}_{\mathbf{K_{B} }}\end{array}\right],\] (3.4.3a) where \[K_{B}\] is the number of (independent) left eigenvectors and the \[\mu\]'s are the eigenvalues of \[\mathbf{B}\]. The \[\mu\]'s are not necessarily distinct (i.e., there may be two or more eigenvectors with the same eigenvalue). The reader should compare this with (3.2.11b) before going on. Each matrix \[\mathbf{X}_{\mathbf{k}}\] is of the form \[\mathbf{X}_{\mathbf{k}}=\left[\begin{array}{ccccc}\mu_{k}&\alpha_{k}&0& \cdots&0&0\\ 0&\mu_{k}&\alpha_{k}&\cdots&0&0\\ \vdots&\vdots&\vdots&\cdots&\vdots&\vdots\\ 0&0&0&\cdots&\mu_{k}&\alpha_{k}\\ 0&0&0&\cdots&0&\mu_{k}\end{array}\right],\] (3.4.3b) where \[\alpha_{k}\neq 0\], and is otherwise not specified. The usual Jordan normal form sets \[\alpha_{k}=\pm 1\], but we ultimately set it to \[\alpha_{k}=-\mu_{k}\] so that \[\mathbf{X}_{\mathbf{k}}=\mu_{k}\,\mathbf{L}_{\mathbf{k}}\], where \[\mathbf{L}_{\mathbf{k}}\] is given by (3.2.3b). As an example, consider the 2-dimensional similarity transformation equation showing that \[\alpha\] can be given any value, and furthermore, there are enough free constants available to do more.

\[\mathbf{R}\,\mathbf{L}\,\mathbf{R}^{-1}:=\left[\begin{array}{cc}\alpha/a& \alpha b/a^{2}\\ 0&-1/a\end{array}\right]\,\left[\begin{array}{cc}1&-1\\ 0&1\end{array}\right]\left[\begin{array}{cc}a/\alpha&b\\ 0&-a\end{array}\right]=\left[\begin{array}{cc}1&\alpha\\ 0&1\end{array}\right]=\mathbf{X},\]

where \(a,\ b,\ \alpha\neq 0\) but are otherwise anything. This can easily be made into an isometric transformation by making \(b=1+1/\alpha\) and \(a=-1\), for then

\[\mathbf{R}\Longrightarrow\mathbf{S}=\left[\begin{array}{cc}-\alpha&1+\alpha \\ 0&1\end{array}\right],\ \ \ \ \mathbf{S}^{-1}=\left[\begin{array}{cc}-1/\alpha&1+1/\alpha\\ 0&1\end{array}\right],\]

and \(\mathbf{S}\,\boldsymbol{\epsilon^{\prime}}=\mathbf{S}^{-1}\,\boldsymbol{ \epsilon^{\prime}}=\boldsymbol{\epsilon^{\prime}}\). After picking \(\alpha\), there were still two free parameters (\(a\) and \(b\)) available to make the transformation an isometric one. The reader should check out these equations.

<!-- Pages 168-168 -->

rows and columns and end up with a new vector-matrix pair, which we also call \(\boldsymbol{\langle\;\tilde{p},\;\tilde{B}\;\rangle}\).

Hereafter we include the dimension reduction, if appropriate, whenever we make an isometric transformation. \(\tilde{\mathbf{B}}\) is the smallest matrix that is equivalent to \(\mathbf{B}\) for all possible \(\mathbf{p}\). However, it can be reduced further, depending on the specific \(\mathbf{p}\) chosen. The pair \(\boldsymbol{\langle\;\tilde{p},\;\tilde{B}\;\rangle}\) is in the form given by Equations (3.2.11), but they are not necessarily equal. It may happen that some \(n_{k}\) are actually larger than those found by the Laplace transform. Note that in (3.2.11) it was required that \(p_{m_{k}}^{(k)}\neq 0\), but here, it is possible that \(p_{n_{k}}^{(k)}=0\). If so, we throw it away, together with the corresponding row and column of \(\tilde{\mathbf{B}}\). When all this trimming is done, we _do_ end up with the same vector-matrix pair as in Theorem 3.4.1.

Yes, it was a long way to get there, and you might have preferred to stick with the Laplace transform view, but here we found a minimal representation of \(\mathbf{B}\) that is good for all entrance vectors, and we did it with only matrix arguments. The only step remaining, if appropriate, is to examine the particular \(\tilde{\mathbf{p}}=\mathbf{p}\,\mathbf{S}^{-1}\), and do the final trimming then.

##### 3.4.2.1 Summary

We have now seen that all functions of exponential type [i.e., of the form given in Equations (3.2.8)] have rational Laplace transforms (RLTs) and can be represented by a vector-matrix pair \(\boldsymbol{\langle\;\mathbf{p},\;\mathbf{B}\rangle}\) of the form (3.2.11a) and (3.2.11b). Conversely, for every \(\boldsymbol{\langle\;\mathbf{p},\;\mathbf{B}\rangle}\) there exists an equivalent vector-matrix pair \(\boldsymbol{\langle\;\tilde{p},\;\tilde{B}\boldsymbol{\rangle}}\) of equal or lesser dimension that is of the form (3.2.11b) and represents the same function as given by Equations (3.2.14). There is no representation that has a smaller dimension. In general, one can say that if \(\boldsymbol{\langle\;\mathbf{p},\;\mathbf{B}\boldsymbol{\rangle}}\) is a representation of \(b(t)\), so is \(\boldsymbol{\langle\;\mathbf{p}\mathbf{S}^{-1}\;\rangle}\), where \(\mathbf{S}\) is any nonsingular isometric matrix of appropriate dimension. Clearly, there are an infinite number of equivalent representations of every pdf (including, interestingly enough, the exponential distribution, which has an infinite number of equivalent representations, but of dimension \(>1\)). Thus it would seem useless to try to give real physical meaning to the individual components of \(\mathbf{p}\) or \(\mathbf{B}\).

It is important to note that if the \(a_{i}\)s, \(p_{i}^{(k)}\)s, and \(\mu_{i}\)s are real and positive, we are dealing with a _PHase distribution_[15], but they do not have to be for \(b(t)\) to be a proper pdf. Neuts has defined a PHase distribution to be a distribution for which there exists a representation where \(\mathbf{p}\), \(\mathbf{P}\), and \(\mathbf{M}\) have only real, non-negative components. Such a representation said to be of _PHase type_. (See the footnote at the beginning of Section 3.2.) We give several examples where the original representation is of PHase type, but the canonical one is not (e.g., Erlangian distributions with feedback). A detailed classification of matrix exponential functions is given in [16].

Now we state the _representation theorem_.

**Theorem 3.4.3:** Consider any finite vector-matrix pair \(\boldsymbol{\langle\;\mathbf{p},\;\mathbf{B}\boldsymbol{\rangle}}\) with the following properties. \(\mathbf{p}\) is isometric; \(\mathbf{B}\) is invertible and has no eigenvalues with nonpositive real part. Then:

<!-- Pages 169-169 -->

1. The three equations in Theorem 3.1.1 [or (3.2.14)] are algebraically correct.
2. Let \(\mathbf{S}\) be any isometric invertible matrix. Then \[\boldsymbol{\big{(}\,\mathbf{p}\,,\,\mathbf{B}\big{)}}\ \equiv\ \boldsymbol{\big{(}\, \mathbf{pS}^{-1}\,,\,\mathbf{SBS}^{-1}\,\big{)}}.\]
3. There exists a special \(\mathbf{S}\) such that \(\mathbf{SBS}^{-1}\) is of the form (3.4.3), with \(K_{B}\) blocks. If the last \(m_{e}\) rows and columns are discarded, the resulting matrix has \(\kappa\leq K_{B}\) blocks. This is the smallest \(\mathbf{B}\) matrix that is valid for all \(\mathbf{p}\).
4. For a specific \(\mathbf{p}\), if for each \(k\), those rows and columns corresponding to \(p_{m_{k}}^{(k)}=0\) are discarded, then the reduced vector-matrix pair \(\boldsymbol{\big{(}\,\tilde{\mathbf{p}}\,,\,\mathbf{B}\big{)}}\) is the _canonical representation_ with the following properties. 1. It is unique to within an exchange of blocks. 2. It is equivalent to \(\boldsymbol{\big{(}\,\mathbf{p}\,,\,\mathbf{B}\big{)}}\). 3. It has \(K\leq\kappa\leq K_{B}\) blocks. 4. No other representation is of smaller dimension. 5. The characteristic equation for \(\tilde{\mathbf{B}}\) satisfies (3.2.13b).

The various components may not be physically realizable even if the components of the original representation are, but diagrammatically it looks like Figure 3.2.5. If the reduced \(m_{k}\) is greater than \(1\) for any \(k\), then the canonical representation is _defective_. It follows then, that if the canonical representation is defective (\(\mathbf{B}\) is a defective matrix), no diagonal representation of \(b(x)\) exists. \(\blacksquare\)

Remember, even if individual components of \(\mathbf{p}\) or \(\mathbf{B}\) are complex, \(b(x)\) is unchanged by an isometric transformation, so the physical consequences are unchanged. D. R. Cox was the first one to consider complex probabilities [13] in this context, but made little use of it. In the next chapters we derive numerous equations, all of which are invariant to this class of isometric transformations.

#### 3.4.2.2 Hierarchy of ME Functions

In the following set of definitions, when we talk about \(R(x)\) we will, by implication, include \(B(x)=1-R(x)\) and \(b(x)=(d/dx)B(x)\).

We wish to define and classify five sets of ME functions that are mutually inclusive (nested subsets).

_Definition 3.4.2_

Let \(\boldsymbol{\big{(}\,\mathbf{p},\,\mathbf{B}\big{)}}\) be any finite-dimensional vector-matrix pair with possibly complex components, and \(\mathbf{p}\boldsymbol{\epsilon}^{\prime}=1\). Then:

\[R(x)=\Psi[\exp(-x\mathbf{B})],\quad\text{with}\ \ R(0)=1\]

<!-- Pages 171-171 -->

If \(\sigma>0\), then all the moments of \(b(x)\) exist, and satisfy [class (3)]:

\[\mbox{\bf E}[X^{\ell}]=\int_{\rm o}^{\infty}x^{\ell}\,b(x)\,dx=\ell\Psi[{\bf V}^ {\ell}].\]

Furthermore, if \(\sigma\) is an eigenvalue of \({\bf B}\) (i.e., it has no imaginary component) then \(R(x)\) has an exponential tail. That is,

\[R(x)\to c\,x^{m}\,e^{-\sigma x}\]

for \(x\) large enough. \(m\) is the multiplicity of \(\sigma\).

But \(B(x)\) may not be a PDF. For this to be true, we must have [class (4)]

\[b(x)\geq 0\quad\forall\;\;x\geq 0,\]

or equivalently, \(R(x)\) must be a monotonically nonincreasing function of \(x\). After 40 years of research we still don't know how (or if) this can be shown directly from the matrix or LT domains, but if the above inequality is true, **(**p**, **B****)** represents a _matrix exponential distribution_. This is the class of functions of interest to us here.

An important subclass of ME distributions in great use today, and first defined by [10] is the class of PHase distributions. This class is defined in the matrix domain as given in the table above [class (5)]. The inequalities are equivalent to having a representation that is truly physical. That is, \({\bf B=M(I-P)}\) with \(M_{ii}>0\), \(1\geq P_{ij}\geq 0\), \(({\bf P\epsilon^{\prime}})_{i}\leq 1\), and \(({\bf I-P})\) has an inverse. As is shown by, for instance, Example 3.4.3 below, a given PHase distribution may have representations that are not PHase (in fact, it will have an infinite number of them). So we say that:

A distribution is a _PHase distribution_ if it has at least one _PHase represention_.

#### Examples of Equivalent Representations

Despite the powerful theorem we stated in the preceding section about minimal and unique representations, a feeling persists that somehow one can construct a set of phases that can do better (sort of like looking for a perpetual motion machine). A common example, which some people have called a _generalized Erlangian_, has the historically older name of _hypoexponential distribution_. The simplest example is given by the following.

**Example 3.4.3:** Consider a server with two phases in tandem that do not have equal completion rates. The straightforward representation of this is

\[{\bf p}=[1\;\;0\,];\quad{\bf M}=\left[\begin{array}{cc}\mu_{1}&0\\ 0&\mu_{2}\end{array}\right];\quad{\bf P}=\left[\begin{array}{cc}0&1\\ 0&0\end{array}\right],\]

and thus,

\[{\bf B}=\left[\begin{array}{cc}\mu_{1}&-\mu_{1}\\ 0&\mu_{2}\end{array}\right].\]

<!-- Pages 172-172 -->

This is a triangular matrix, therefore the eigenvalues of \(\mathbf{B}\) are equal to \(\mu_{1}\) and \(\mu_{2}\). If the \(\mu\)'s are not equal, \(\mathbf{B}\) can be diagonalized by the matrix made up of its eigenvectors. Look at

\[\mathbf{S}^{-1}=\frac{1}{\mu_{2}-\mu_{1}}\left[\begin{array}{cc}\mu_{2}&-\mu_ {1}\\ 0&\mu_{2}-\mu_{1}\end{array}\right],\quad\mathbf{S}=\frac{1}{\mu_{2}}\left[ \begin{array}{cc}\mu_{2}-\mu_{1}&\mu_{1}\\ 0&\mu_{2}\end{array}\right].\]

First note that \(\mathbf{S}\,\boldsymbol{\epsilon^{\prime}}=\boldsymbol{\epsilon^{\prime}}\). Then

\[\tilde{\mathbf{p}}=\mathbf{p}\mathbf{S}^{-1}=\left[\frac{\mu_{2}}{\mu_{2}-\mu _{1}}\ \ \frac{\mu_{1}}{\mu_{1}-\mu_{2}}\right],\quad\tilde{\mathbf{B}}=\mathbf{S} \mathbf{B}\mathbf{S}^{-1}=\left[\begin{array}{cc}\mu_{1}&0\\ 0&\mu_{2}\end{array}\right],\]

and \(\boldsymbol{\langle}\,\mathbf{p}\,,\,\mathbf{B}\boldsymbol{\rangle}\equiv \boldsymbol{\langle}\,\mathbf{\tilde{p}}\,,\,\mathbf{\tilde{B}}\boldsymbol{\rangle}\). So a hypoexponential distribution is just another hyperexponential distribution, but with a difference. Suppose that \(\mu_{2}>\mu_{1}\). Then \((\tilde{\mathbf{p}})_{2}<0\) and \((\tilde{\mathbf{p}})_{1}>1\). This is not very physical, but it gives the right pdf, namely,

\[b(t)=\frac{\mu_{2}}{\mu_{2}\!-\!\mu_{1}}\left(\mu_{1}e^{-\mu_{1}t}\right)+ \frac{\mu_{1}}{\mu_{1}\!-\!\mu_{2}}\left(\mu_{2}e^{-\mu_{2}t}\right)=\frac{ \mu_{1}\mu_{2}}{\mu_{1}\!-\!\mu_{2}}\left(e^{-\mu_{2}t}-e^{-\mu_{1}t}\right),\]

and

\[R(t)=\frac{\mu_{2}}{\

<!-- Pages 173-173 -->

rates are the same). In this case we can throw away one of the phases and permit our customer to go to the other phase with the sum of the probabilities,+ again yielding the exponential distribution.

Footnote †: This property is quite different from the apparently similar situation in control theory. There, if a degenerate eigenvalue has two eigenvectors, that implies a feedback loop, which can cause instability.

Confusing enough? Well, let us try another example, a specific case of Example 3.4.2.

**Example 3.4.4:** Consider once again two phases in tandem, but now the customer can leave after finishing phase \(1\) with probability \(\theta\). Then the \(\mathbf{P}\) matrix and entrance vector are

\[\mathbf{P}=\left[\begin{array}{cc}0&1-\theta\\ 0&0\end{array}\right]\quad\text{and}\quad\mathbf{p}=[\begin{array}{cc}p&q \end{array}],\]

where \(p+q=1\). This leads to a completion rate matrix of the form

\[\mathbf{B}=\left[\begin{array}{cc}\mu_{1}&-\mu_{1}(1-\theta)\\ 0&\mu_{2}\end{array}\right].\]

This too can be made to look like an \(h_{2}\) function, but if \(\mu_{2}=\theta\mu_{1}\), then suddenly, \(\boldsymbol{\epsilon^{\prime}}\) is a right eigenvector of \(\mathbf{B}\), with eigenvalue \(\mu_{2}\). This means that this subsystem is only an exponential server, even though nothing special seems to have happened. From Example 3.4.2 this leads to \(\Psi\left[\exp(-t\mathbf{B})\right]=\exp(-t\mu_{2})\) for any entrance vector. Observe what has happened here. When \(\mu_{2}=\theta\mu_{1}\), one of the two left eigenvectors becomes orthogonal to \(\boldsymbol{\epsilon^{\prime}}\) and thus is discarded, together with the reduction of dimension. Here is the isometric transformation:

\[\mathbf{S}^{-1}=\frac{1}{\mu_{2}-\mu_{1}}\left[\begin{array}{cc}\mu_{2}-\mu _{1}\theta&-\mu_{1}(1-\theta)\\ 0&\mu_{2}-\mu_{1}\end{array}\right],\]

and

\[\mathbf{S}=\frac{1}{\mu_{2}-\mu_{1}\theta}\left[\begin{array}{cc}\mu_{2}- \mu_{1}&\mu_{1}(1-\theta)\\ 0&\mu_{2}-\mu_{1}\theta\end{array}\right].\]

Again note that \(\mathbf{S}\,\boldsymbol{\epsilon^{\prime}}=\boldsymbol{\epsilon^{\prime}}\), and

\[\tilde{\mathbf{p}}=\mathbf{p}\mathbf{S}^{-1}=\left[\frac{p(\mu_{2}-\mu_{1} \theta}{\mu_{2}-\mu_{1}}\ \ \frac{p\mu_{1}\theta+q\mu_{2}-\mu_{1}}{\mu_{2}-\mu_{1}}\right],\quad \tilde{\mathbf{B}}=\mathbf{S}\mathbf{B}\mathbf{S}^{-1}=\left[\begin{array}[] {cc}\mu_{1}&0\\ 0&\mu_{2}\end{array}\right],\]

But when \(\mu_{2}=\theta\mu_{1}\) the equations fall apart. For this specific case,

\[\mathbf{S}^{-1}=\left[\begin{array}{cc}1/a&1\\ 0&1\end{array}\right],\quad\mathbf{S}=\left[\begin{array}{cc}a&-a\\ 0&1\end{array}\right].\]

Any \(a\) will yield the same \(\mathbf{\tilde{B}}\), but note that the first row of \(\mathbf{S}\) sums to \(0\), and no value for \(a\) can change that. Also note that

\[\mathbf{S}\,\boldsymbol{\epsilon^{\prime}}=\left[\begin{array}{cc}0\\ 1\end{array}\right]\quad\text{and}\quad\mathbf{S}^{-1}\left[\begin{array}{ cc}0\\ 1\end{array}\right]=\boldsymbol{\epsilon^{\prime}}.\]

<!-- Pages 175-175 -->

and \(\mathbf{\tilde{p}}=\mathbf{p}\,\mathbf{S}^{-1}=[\,p\,\,\,-q\,\,\,\,2q\,]\). The diagram of the canonical representation is shown on the right diagram of Figure 3.4.1. Here we have an \(E_{2}\) component and a hypoexponential part with a negative probability of going to phase 2. The density function can be written down directly as

\[b(x)=(2p\,x-q)\left(2\,e^{-2x}\right)+2q\,e^{-x}. \tag{3.4.4}\]

Note that, as with all distributions where the customer must go through at least two phases before exiting, \(b(0)=0\).

It is easy to check that rows 2 and 3 of \(\mathbf{S}\) are left eigenvectors of \(\mathbf{B}\), and columns 1 and 3 of \(\mathbf{S}^{-1}\) are right eigenvectors, but the other row and column are not. 

Perhaps we have tried to say too much in too little space. Rest assured that there are an infinity of examples that can force us into confusing interpretations of the various components. Therefore, we reiterate that it is the matrix as a whole that describes any subsystem, or nonexponential server, not its components.

#### 3.4.4 On the Completeness of ME Distributions

Despite the richness of possibilities we have just seen, not every pdf has an exact representation. On the other hand, it is well known that the set of polynomials times exponentials forms a complete set in that (almost?) every integrable function can be approximated arbitrarily closely by a sum of members of that set. This approximation concept is discussed in detail elsewhere and is becoming an increasingly important area of research, with few clear answers at present.

By _completeness_ we mean that for every pdf of interest there exists a sequence of finite-dimensional vector-matrix pairs (perhaps of ever-increasing dimension) whose properties converge to those of that pdf. Suppose that \(\{\{\mathbf{p_{m}}\,,\,\mathbf{B_{m}}\}\mid m=1,2,\ldots\}\) is such a sequence; then in some meaningful sense,

\[\lim_{m\to\infty}\Psi_{m}\left[\exp(-t\mathbf{B_{m}})\right]=R(t)\] (3.4.5a) and \[\lim_{m\to\infty}\Psi_{m}\left[\mathbf{V}_{\mathbf{m}}^{\ell}\right]=\int_{ \mathrm{o}}^{\infty}t^{\ell}b(t)dt,\,\,\,\,\,\,\,\,\,\ell\geq 0, \tag{3.4.5b}\]

with equivalent limits for other properties of \(b(t)\). We have discussed three such sequences up to now; the TPT distributions of Section 3.3.6.2, the deterministic distribution of (3.2.5a), and the uniform distribution (to be discussed further in Exercise 3.5.8). All three involve an ever-increasing sequence of representations whose properties approach ever closely those of the function they approximate, so Equations (3.4.5) are satisfied. But what about

\[\lim_{m\to\infty}\,\mathbf{\langle}\,\mathbf{p_{m}}\,,\,\mathbf{B_{m}}\mathbf{ \rangle}?\]

The TPT representation in (3.3.24) does indeed have a limit, but the representation of (3.2.5a) does not. Recall that the Erlangian-\(m\) functions have a

<!-- Pages 176-176 -->

mean of \(m/\mu\), so to maintain a mean of 1, we let \(\mu=m\). Then, in the limit as \(m\to\infty\) we also have \(\mu\to\infty\), so \(\lim_{m\to\infty}\mathbf{B_{m}}\) does not exist. The uniform distribution is even worse. The sequence of approximate representations has the same \(\mathbf{B_{m}}\)s, whereas the entrance vectors are

\[\mathbf{p_{m}}=\frac{1}{m}[1\ \ 1\ \cdots\ \ 1\ 1],\]

so \(\lim\ \mathbf{p_{m}=o}\). These examples tell us we must be careful when we let the dimensions of a representation become unboundedly large, and we cannot necessarily deal directly with infinite-dimensional matrices and vectors. But we can (in principle) deal with matrices of whatever size is needed to yield accurate enough approximations to any desired PDF.

Before moving on, we discuss the meaning of a representation for which \(\mathbf{B}\) or \(\mathbf{V}\) is singular (i.e., either matrix has no inverse). First we consider finite representations. If \(\mathbf{B}\) is singular, exactly one of the parallel paths of its minimal representation (Figure 3.2.5) has a single phase with a 0 completion rate, or equivalently, an infinite completion time (multiple phases in tandem with infinite completion times would be redundant). This corresponds to one of two possibilities. Either (at least) one of the phases in the original representation is broken, or there is a possibility that a customer can be trapped in an infinite loop. In either case, there is a greater than zero probability that a customer can take an infinite time to complete service. In other words, the mean service time for this distribution is infinite. This is consistent with (3.2.14c) because \(\mathbf{V}\) does not exist if \(\mathbf{B}\) is singular. Next, suppose that \(\mathbf{V}\) exists and is singular. Then it has at least one 0 eigenvalue, and exactly one parallel path of its minimal representation has a single phase with zero completion time. This is physically equivalent to the possibility that a customer may bypass service altogether. In other words, there is a probability greater than 0 that a customer will have 0 service time, or the PDF, \(B(t)\) at \(t=0\), is greater than 0. Because

\[B(t)=\int_{o}^{t}b(x)dx,\]

\(b(x)\) must be singular at \(x=0\). This is consistent with (3.1.8b) and the fact that \(\mathbf{B}\) does not exist. We get around this without much difficulty later.

Infinite matrices have a much greater variety of singularities, thus making them more difficult to analyze mathematically (aside from the technical problem of dealing with an infinite set of numbers). A detailed discussion of this must wait for further research. It is sufficient for our purposes to deal only with finite matrices, and to represent distribution functions that have special properties (e.g., functions with nonexponential tails and have infinite moments) by a sequence of finite representations of ever-increasing dimension, as described above in our definition of ME functions.

#### 3.4.5 Setting Up Matrix Representations

It is one thing to talk abstractly about a pdf that describes the behavior of a server or process. It is another thing to say explicitly what the pdf is,

<!-- Pages 177-177 -->

based on real-world examination. "What is the pdf?" is definitely not a trivial question to answer nor is, "What is its matrix representation?" We discuss the two questions briefly here. There are various ways in which the behavior of subsystems shows up in the course of examining queueing systems. Several of them, together with how they can be represented in LAQT, follow.

1. If a Markov chain, or transition graph description is given, \(\mathbf{p},\ \mathbf{P}\), and \(\mathbf{M}\) are included as part of the description. In effect, this gives us Figure 3.1.1.
2. If a density function is given, and one of the following is true; 1. \(b(t)\) only has terms that are exponentials times powers of \(t\), then it can be rewritten in the form of (3.2.1), from which the appropriate parameters corresponding to Figure 3.2.1 can be found, 2. \(b(t)\) is not as in part (a), then an approximation must be found that obeys (a).
3. If the Laplace transform for the pdf of the subsystem is given, and 1. \(B^{*}(s)\) is RLT, then expand it in terms of its partial fractions. This entails finding the roots of its denominator polynomial. Each term will be of the form \([a_{i}p_{j}^{(i)}]/(1+s\mu_{\,i})^{j}\), from which Figure 3.2.1 can be drawn, or 2. \(B^{*}(s)\) is not RLT, then an approximation must be found that is RLT.
4. Only a finite set of data is available that reflects the performance of the subsystem. Then a suitable function must be constructed that reflects this performance (i.e., another approximation).

It is not at all clear what a 'good' approximation might mean in a queueing theory context. Its goodness depends very much on what use will be made of the function and in what context. Even if two functions seem to look alike, they may yield radically different results in any given application. The commonly accepted procedure of picking approximate functions that have the correct first two (or more) moments (i.e., \(\operatorname{\mathbb{E}}[T]\) and \(\sigma^{2}\), etc.) has been shown to be inadequate and even very misleading in solving various problems. The value of \(b(t)\) and its derivatives at \(0\) may be more important at times. This is discussed in Chapter 5. Until then, we assume in all topics we cover here that a representation, or a series of approximate representations converging to \(b(t)\), has already been selected.

### 3.5 Renewal Processes and Residual Times

Consider a sequence of positive random variables (e.g., service times), \(\{X_{1},X_{2},\ldots X_{k},\ldots\}\) where all the \(X_{k}\)s are independent and, except perhaps \(X_{1}\), are identically distributed. Its relationship with the material in this chapter is straightforward. Let our subsystem \(S\) start with an infinite number of

<!-- Pages 178-178 -->

customers waiting to enter while \(C_{1}\) is being served. Call them \(C_{2},C_{3},C_{4},\ldots\). When \(C_{1}\) is finished, he leaves, and \(C_{2}\) immediately enters, and so on (see Figure 3.5.1). The time \(C_{k}\) spends in \(S\) is \(X_{k}\). It is clear that the \(X_{k}\)s have the same pdf. There is one possible exception, namely if \(C_{1}\) had entered \(S\) at some indeterminate time before our observer started her clock.

Then \(X_{1}\) would come from the PDF [see (3.1.7c)]

\[\operatorname{\mathbbm{Pr}}(X_{1}<x):=B_{1}(x)=1-\operatorname{\boldsymbol{ \pi}}\left[\exp(-x\mathbf{B})\right]\boldsymbol{\ell^{\prime}},\]

where \(\pi_{i}\) is the probability that \(C_{1}\) was at phase \(i\) when she started looking, and \(x\) is the time elapsed thereafter. This subtle change of \(\operatorname{\boldsymbol{\pi}}\) for \(\mathbf{p}\) in (3.1.7a) is quite a powerful technique in analyzing a sequence of events. In general, one can take the vector that describes what happened up to the present [\(\operatorname{\boldsymbol{\pi}}\)] and premultiply it to the vector of probabilities of future events (recall from Definition 3.1.1 that \([\exp(-x\mathbf{B})\boldsymbol{\ell^{\prime}}]_{i}\) is the probability that \(C_{1}\) will still be in \(S\) at time \(x\), given that it was in state \(i\) at time \(0\)) to get the total probability for any given event to occur. If observation began at the moment \(C_{1}\) entered \(S\), then \(\operatorname{\boldsymbol{\pi}}=\mathbf{p}\), and \(X_{1}\) has the same distribution as the other \(X_{k}\)s.

An interesting event to examine is the time for the \(n\)-th customer to complete service. That time is the random variable \(Y_{n}\), called a _renewal epoch_, and defined by the obvious relation

\[Y_{n}:=\sum_{k=1}^{n}X_{k}=Y_{n-1}+X_{n},\quad n>1,\] (3.5.1a) where \[Y_{1}=X_{1}\]. In our picture, the \[Y_{n}\]s are the _departure times_, and the \[X_{n}\]'s are the _interdeparture times_. If one thinks of these customers as having already departed from \[S\] and then arrive at some point downstream then the \[X_{n}\]s become the _interarrival times_ and the \[Y_{n}\]s become the _arrival times_. We remind the reader that in this book we use _epoch_ to mean not only the time \[Y_{n}\], but the entire interval from \[Y_{n-1}\] up to and including \[Y_{n}\].

A formal definition of a _renewal process_ as given by Feller [Feller71] follows.

Figure 3.5.1: Renewal process viewed as a sequence of departures from a single subsystem \(\boldsymbol{S}\), able to serve one customer at a time. There is an infinite queue of customers waiting to enter \(S\), and at time = 0, \(C_{1}\) is already being served. He leaves at time \(Y_{1}\) (\(=X_{1}\)), after which \(C_{2}\) immediately enters. At time \(Y_{2}\) (\(=Y_{1}+X_{2}\)) he leaves and \(C_{3}\) enters. This goes on indefinitely, generating the renewal epochs, \(Y_{1}\), \(Y_{2}\), \(Y_{3}\), \(Y_{4}\),..., \(Y_{k}\)....

<!-- Pages 181-181 -->

The expression in brackets, as defined in [15], is the _beta function_, and is equal to

\[\beta(k+1,j+1):=\int_{\mathrm{o}}^{x}s^{k}(x-s)^{j}ds=\frac{k!j!}{(k+j+1)!}x^{k+ j+1}.\]

Therefore,

\[b_{2}(x)=x\,\mathbf{\pi}\,\mathbf{\Pi}\left[\sum_{k=0}^{ \infty}\sum_{j=0}^{\infty}\frac{(-x\mathbf{B})^{k}\mathbf{Q$ }(-x\mbox{\boldmath$B})^{j}}{(k+j+1)!}\right]\mathbf{B}\mathbf{\epsilon}^{\prime}.\] (3.5.2a) As far as we know, there is no closed-form expression for this. However, see Exercises 3.5.5 and 3.5.6 for a meaning of these terms.

**Exercise 3.5.1:** If \(S\) is one-dimensional (i.e., exponential), then \(\mathbf{Q}=1,\mathbf{\pi}=1\), and \(\mathbf{B}=\mu\). Show directly from the expression above that \(b_{2}(x)=\mu^{2}xe^{-\mu x}\).

Alternatively, we can write

\[b_{2}(x) =\mathbf{\pi}\,\mathbf{B}\left[\int_{\mathrm{o} }^{x}\exp(-s\mathbf{B})\mathbf{Q}\exp(+s\mathbf{B$ })ds\right]\!\exp(-x\mbox{\boldmath$B})\mathbf{B}\mathbf{ \epsilon}^{\prime}\] \[=\mathbf{\pi}\,\mathbf{B}\sum_{k=0}^{\infty} \sum_{j=0}^{\infty}\frac{(-\mathbf{B})^{k}\mathbf{Q}(\mathbf{B})^{j}}{k!j!}\left[\int_{\mathrm{o}}^{x}s^{k+j}ds\right]\!\exp(-x \mathbf{B})\mathbf{B}\mathbf{\epsilon}^{\prime},\]

and finally,

\[b_{2}(x)=x\mathbf{\pi}\,\mathbf{B}\left[\sum_{k=0}^{\infty} \sum_{j=0}^{\infty}\frac{(-x\mathbf{B})^{k}\mathbf{Q}(x \mathbf{B})^{j}}{k!j!(k+j+1)}\right]\!\exp(-x\mathbf{B}) \mathbf{B}\mathbf{\epsilon}^{\prime}. \tag{3.5.2b}\]

This does not seem to be much better, if at all, and we can expect \(b_{3}(x)\) to yield even messier expressions for either form. Our purpose in going through this at all was to warn the reader that matrix functions are not always as easy to manipulate as their scalar counterparts. We must look elsewhere for useful expressions.

**Exercise 3.5.2:** Show that (3.5.2b) also reduces to \(b_{2}(x)=\mu^{2}xe^{-\mu x}\) when \(S\) is one-dimensional.

Rather than trying to convert a convolution into a matrix expression, let us instead look at \(Y_{k}\) as a single process. Consider Figure 3.5.2 where we have \(k\) identical subsystems in tandem, each described by the same pair \(\{\,\mathbf{p}\,,\,\mathbf{V}\}\), except for \(S_{1}\), which has \(\pi\) instead of \(p\). A customer starts at the \(i\)-th phase

<!-- Pages 182-182 -->

of \(S_{1}\) with probability \(\pi_{i}\). After meandering for a while \([\mathbf{P}]\), he leaves \([\mathbf{q}^{\prime}]\), and immediately goes to \(S_{2}\), entering there and going to phase \(i\) with probability \(p_{i}\). Instead of having a convolution of \(k\)\(m\)-dimensional objects, our process is described by the \((k\times m)\)-dimensional arrays \(\{\mathbf{p_{k}},\,\boldsymbol{\epsilon^{\prime}_{k}},\,\mathbf{P_{k}},\, \mathbf{M_{k}},\,\text{etc.}\}\). \(\boldsymbol{\epsilon^{\prime}_{k}}\) is a \(k\times m\) vector of all 1's. The process must start in one of the first \(m\) states, so

\[\mathbf{p_{k}}=[\boldsymbol{\pi},\,\mathbf{o},\,\mathbf{o},\,\ldots,\,\mathbf{o}]\] (3.5.3a) (each \[\mathbf{o}\] is an \[m\] -vector of all 0's ) and will go from \[i\] to \[j\] in \[S_{1}\] with probability \[P_{ij}\], or go to the phase \[j\] in \[S_{2}\] with probability \[q_{i}p_{j}=(\mathbf{q}^{\prime}\mathbf{p})_{ij}\]. For \[k=3\], for instance, \[\mathbf{P_{3}}=\left[\begin{array}{ccc}\mathbf{P}&\mathbf{q}^{\prime}\mathbf{ p}&\mathbf{O}\\ \mathbf{O}&\mathbf{P}&\mathbf{q}^{\prime}\mathbf{p}\\ \mathbf{O}&\mathbf{O}&\mathbf{P}\end{array}\right]\quad\text{and}\quad \mathbf{M_{3}}=\left[\begin{array}{ccc}\mathbf{M}&\mathbf{O}&\mathbf{O}\\ \mathbf{O}&\mathbf{M}&\mathbf{O}\\ \mathbf{O}&\mathbf{O}&\mathbf{M}\end{array}\right].\] (3.5.3b) The rate matrix for the process is (remember that \[\mathbf{Bq}^{\prime}\mathbf{p}=\mathbf{BQ}\] ) \[\mathbf{B_{3}}=\mathbf{M_{3}}(\mathbf{I_{3}}-\mathbf{P_{3}})=\left[\begin{array} []{ccc}\mathbf{B}&-\mathbf{BQ}&\mathbf{O}\\ \mathbf{O}&\mathbf{B}&-\mathbf{BQ}\\ \mathbf{O}&\mathbf{O}&\mathbf{B}\end{array}\right]\] \[=\mathbf{B}\left[\begin{array}{ccc}\mathbf{I}&-\mathbf{Q}&\mathbf{O}\\ \mathbf{O}&\mathbf{I}&-\mathbf{Q}\\ \mathbf{O}&\mathbf{O}&\mathbf{I}\end{array}\right]\] (3.5.3c) with process time matrix \[\mathbf{V_{3}}=\mathbf{B_{3}}^{-1}=\left[\begin{array}{ccc}\mathbf{I}& \mathbf{Q}&\mathbf{Q}\\ \mathbf{O}&\mathbf{I}&\mathbf{Q}\\ \mathbf{O}&\mathbf{O}&\mathbf{I}\end{array}\right]\mathbf{V}.\] (3.5.3d) The generalization to any \[k\] should be clear. We can now write down the pdf for this process: \[b_{k}(x)=\mathbf{p_{k}}\left[\mathbf{B_{k}}\exp(-x\mathbf{B_{k}})\right] \boldsymbol{\epsilon^{\prime}_{k}}\quad\text{and}\quad\mathbf{E}[Y_{k}^{\ell}] =\frac{1}{\ell^{\dagger}}\mathbf{p_{k}}\left[\mathbf{V_{k}}^{\ell}\right] \boldsymbol{\epsilon^{\prime}_{k}}. \tag{3.5.3e}\]

Figure 3.5.2: Representation of the distribution of \(\mathbf{Y_{k}}\), the \(k\)-th convolution of \(\mathbf{S}\) with itself. All the \(S\)'s are identical, except that the starting vector for \(S_{1}\) may be different.

<!-- Pages 188-188 -->

This expression clearly is not the same as \(-3\mathbf{B}(\mathbf{BQ})^{2}\), and in fact is typical of the terms appearing in Equations (3.5.2).

**Exercise 3.5.5:** Show in general that

\[\left(\frac{d\mathbf{B_{r}}^{n}}{d\alpha}\right)_{\alpha=0}=-\mathbf{B}\left( \sum_{k=0}^{n-1}\mathbf{B}^{k}\mathbf{Q}\mathbf{B}^{n-k-1}\right).\]

**Exercise 3.5.6:** Use Exercise 3.5.5 to show that the expression for \(b_{2}(x)\) in (3.5.2a) is actually

\[-\left(\frac{\partial}{\partial\alpha}\Psi\left[\exp(-x\mathbf{B_{r}})\right] \right)_{\alpha=0},\]

which is the derivative of \(F_{r}(x;\,\alpha)\) for \(\mathbf{p}=\boldsymbol{\pi}\), and then evaluated at \(\alpha=0\).

Returning to (3.5.9e), we can take the limit as \(\alpha\) goes to \(1\) directly and get

\[m(x)=\boldsymbol{\pi}\exp[-x\mathbf{B}(\mathbf{I}-\mathbf{Q})]\mathbf{B}\, \boldsymbol{\epsilon^{\prime}}. \tag{3.5.9h}\]

It is not so easy to find \(M(x)\) from \(M(x;\alpha)\) in (3.5.9f) because both numerator and denominator approach \(0\) as \(\alpha\to 1\). For exponential distributions, \(\mathbf{B}\Rightarrow\mu\), \(\mathbf{Q}\Rightarrow 1\), and \(\boldsymbol{\pi}\Rightarrow 1\), so \(m(x)=\mu\). Clearly, for all other distributions \(m(x)\) varies with \(x\). However, we have the first of three versions of the _renewal theorem_:

**Theorem 3.5.3a:** Let \(S\) represent an ME distribution generating a renewal process; then

\[\lim_{x\rightarrow\infty}m(x)=\frac{1}{\bar{x}}\cdot \tag{3.5.10a}\]

**Proof:** First observe that because \(\mathbf{V}=\mathbf{B}^{-1}\), we can state that

\[\boldsymbol{\pi_{r}}:=\frac{\mathbf{p}\mathbf{V}}{\Psi\left[\mathbf{V}\right]} \tag{3.5.10b}\]

is the left eigenvector of \(\mathbf{B}(\mathbf{I}-\mathbf{Q})\) with eigenvalue \(0\), and corresponding right eigenvector \(\boldsymbol{\epsilon^{\prime}}\), with length \(\boldsymbol{\pi_{r}}\,\boldsymbol{\epsilon^{\prime}}=1\). (We take another look at the _mean residual vector_\(\boldsymbol{\pi_{r}}\), in the next section.) Then as we showed in Chapter 1 [Equations (1.3.3a) and (1.3.10a)], for large \(x\),

\[\exp[-x\mathbf{B}(\mathbf{I}-\mathbf{Q})]\rightarrow\boldsymbol{\epsilon^{ \prime}}\,\boldsymbol{\pi_{r}}.\]

<!-- Pages 189-189 -->

Recall from (3.1.4b) that \(\Psi\left[\mathbf{V}\right]=\bar{x}\) and that \(\boldsymbol{\pi}\,\boldsymbol{\epsilon}^{\prime}=1\), so we have

\[\lim_{x\to\infty}m(x)=(\boldsymbol{\pi}\,\boldsymbol{\epsilon}^{\prime}) \boldsymbol{\pi}_{\boldsymbol{\pi}}\,\mathbf{B}\,\boldsymbol{\epsilon}^{ \prime}=\frac{\mathbf{p}\mathbf{V}}{\bar{x}}\mathbf{B}\,\boldsymbol{\epsilon}^ {\prime}=\frac{\mathbf{p}\mathbf{V}\mathbf{B}\,\boldsymbol{\epsilon}^{\prime} }{\bar{x}}=\frac{1}{\bar{x}}\cdot\]

**QED**

This tells us that only if the interval is large enough will the mean number of customers departing approach \(\Delta/\bar{x}\). This is true because the initial state of the system has to be "forgotten" before the steady-state average can be achieved. We show this more clearly in the next section.

#### 3.5.3 Residual Times and Delayed Intervals

Numerous books have been written exclusively on renewal theory, so one should not expect to be able to cover too much in three sections. There are, however, two related points that we wish to discuss. First, how do we decide what the starting vector \(\boldsymbol{\pi}\), is? Even if we have a concise answer for that, we only have formulas describing the first interval of time \((0,\Delta]\). What about later intervals \((\Delta,2\Delta],(2\Delta,3\Delta],\ldots,(k\Delta,(k+1)\Delta]\), and even more generally \((x,x+\Delta]\), for any \(x>0\)?

##### 3.5.3.1 Residual Vector

Let us consider the simplest case where our time begins at the moment \(C_{1}\) enters \(S\), or equivalently, just after \(C_{\mathrm{o}}\) (if we had defined it) leaves. Then \(\boldsymbol{\pi}=\mathbf{p}\), and we have a renewal process describing the number of customers who complete service in the interval \((0,\Delta]\), which we can (at least in principle) calculate using Equations (3.5.4) together with (3.5.9) or (3.5.3) (see the next section for another way). But suppose that we wanted to do the equivalent for a later interval \((x,x+\Delta]\). What would the starting vector \(\boldsymbol{\pi}(x)\) be then? Well, if we knew that customer \(C_{1}\) was still in service at time \(x\), then \(\boldsymbol{\pi}(x)\) would be proportional to \(\mathbf{r}(x)=\mathbf{p}\exp(-x\mathbf{B})\), whose \(i\)-th component is the probability that \(C_{1}\) is still in service and is at phase \(i\) (recall the discussion in Section 3.1.2). The proportionality constant is \(\Psi\left[\exp(-x\mathbf{B})\right]\), which is \(R_{1}(x)\). What is to be done if \(C_{1}\) has already finished or we have not kept track of the number of completions until \(x\)? We consider the first alternative in the next section and consider the second one here.

Suppose that we do not know, or do not care, how many customers have been served in previous intervals. Can we say something about the probability state of the presently active customer? We can answer the question in a manner similar to that for the transient renewal process, as in Figure 3.5.3. The only difference is that the customer always returns to \(S\) (i.e., \(\alpha=1\)). We are now describing a closed system, just as was done in Chapter 1. Our customer after leaving phase \(i\) can get to \(j\) either by going directly there \([P_{ij}]\), or by leaving \([q_{i}]\), and immediately re-entering and going to \(j\), \([p_{j}]\). Thus we have an _isometric matrix_ satisfying (1.3.1b):

\[\mathbf{P}_{\mathbf{r}}:=\mathbf{P}+\mathbf{q}^{\prime}\mathbf{p}. \tag{3.5.11a}\]

<!-- Pages 190-190 -->

But this is identical to (3.5.9a) with \(\alpha=1\), with matching transition rate matrix (1.3.2c), \(\mathbf{B_{r}}:=\mathbf{B}(\mathbf{I}-\mathbf{Q})=\mathbf{B_{r}}(1)\), which is (3.5.9b) with \(\alpha=1\). We can now define the mean residual vector, or simply the _residual vector_

\[\boldsymbol{\pi_{r}}(x):=\mathbf{p}\exp(-x\mathbf{B_{r}}), \tag{3.5.11b}\]

whose \(i\)-th component is the probability that the trapped customer is at phase \(i\) at time \(x\) irrespective of how many times he has gone around the loop. From its definition in (3.5.11b) it follows that

\[\lim_{x\to\infty}\boldsymbol{\pi_{r}}(x)=\frac{1}{\Psi[\mathbf{V}]}\mathbf{p} \mathbf{V}=\boldsymbol{\pi_{r}},\] (3.5.12a) where \[\boldsymbol{\pi_{r}}\] is the mean residual vector defined by ( 3.5.10b ). Note that \[m(x)=\boldsymbol{\pi_{r}}(x)\mathbf{B}\boldsymbol{e^{\prime}}\], but more important, we can evaluate a delayed renewal process starting at any time, \[x\]. For instance, suppose that it is desirable to find the renewal density for some interval starting at time \[x\]. Then, replacing \[\boldsymbol{\pi}\] with \[\boldsymbol{\pi_{r}}(x)\] in ( 3.5.11b ) yields \[m_{r}(\Delta;x):=\boldsymbol{\pi_{r}}(x)\exp(-\Delta\mathbf{B_{r}})\mathbf{B} \boldsymbol{e^{\prime}}\] \[=\mathbf{p}\exp(-x\mathbf{B_{r}})\exp(-\Delta\mathbf{B_{r}}) \mathbf{B}\boldsymbol{e^{\prime}}=\Psi\left[\exp[-(x+\Delta)\mathbf{B_{r}}] \mathbf{B}\right

<!-- Pages 191-191 -->

Almost as an afterthought, we can derive the well-known expression for the _mean residual time_, which is the mean time that a customer will remain in service, given that it was not known when he began. Let \(X_{r}\) be the r.v. for that remaining time. Then consistent with our notation, we use the symbol \(\bar{x}_{r}:=\mbox{\bb E}[X_{r}]\).2 Recall that \(\mbox{\bbpi}_{\mbox{\bbpi}}\) is the left eigenvector of \(\mathbf{B}_{\mbox{\bbpi}}\), which in turn is the transition rate matrix for our trapped customer of Figure 3.5.3, with \(\alpha=1\). Therefore, the component \(i\) of \(\mbox{\bbpi}_{\mbox{\bbpi}}\) is the steady-state probability of finding him at phase \(i\). Lacking any knowledge of where or when the process began originally, the best we can say at any given moment is that \(\mbox{\bbpi}_{\mbox{\bbpi}}\) describes all we know about where our customer is. Let us imagine that as of now, we shall let him leave the system once he has finished his present trip through \(S\), then

Footnote 2: So the secret is out; the subscript \(r\) stands for _residual_, not renewal, or reliability, or whatever.

**Theorem 3.5.4:** Let \(X_{r}\) be the r.v. for the time remaining for a customer who has been in service for an indefinite period. Then

\[\bar{x}_{r}=\mbox{\bb E}[X_{r}]=\mbox{\bbpi}_{\mbox{\bb r}}\mathbf{V}\mbox{ \bbepsilon}^{\prime}=\frac{\mathbf{p}\,\mathbf{V}\mathbf{V}\mbox{\bbepsilon}^{ \prime}}{\Psi\,[\mathbf{V}]}=\frac{\Psi\,[\mathbf{V}^{2}]}{\Psi\,[\mathbf{V}] }=\frac{\mbox{\bb E}[X^{2}]}{2\bar{x}}\;. \tag{3.5.12b}\]

In fact, one gets the rather unusual relationship between the moments of the residual distribution and the original one:

\[\mbox{\bb E}[X_{r}^{n}]=n!\,\mbox{\bbpi}_{\mbox{\bbpi}}\,\mathbf{V}^{n}\mbox{ \bbepsilon}^{\prime}=\frac{n!}{\bar{x}}\mathbf{p}\mathbf{V}\mathbf{V}^{n} \mbox{\bbepsilon}^{\prime}\]

\[=\frac{n!}{\bar{x}}\Psi\,\big{[}\mathbf{V}^{n+1}\big{]}=\frac{\mbox{\bb E}[ X^{n+1}]}{(n+1)\bar{x}}\;. \tag{3.5.12c}\]

The proof comes directly from (3.1.9). \(\blacksquare\)

**Exercise 3.5.7:** Evaluate \(\bar{x_{r}}\) for an \(E_{2}\) and an \(h_{2}\) distribution (see Exercises 3.1.1 and 3.1.2). For the \(h_{2}\) distribution, let \(\alpha=0.1\), and \(\mu_{\mbox{\bb 2}}/\mu_{\mbox{\bb 1}}=10\). Note that for \(E_{2}\), \(\bar{x_{r}}\) is always less than \(\bar{x}\), whereas for \(h_{2}\), \(\bar{x_{r}}\) is always greater than \(\bar{x}\). In fact, show in general that \(\bar{x_{r}}\) can be written in either of the two following ways.

\[\bar{x_{r}}=\bar{x}\,\frac{C_{v}^{2}+1}{2}=\bar{x}+\bar{x}\,\frac{C_{v}^{2}-1} {2}, \tag{3.5.12d}\]

so the mean residual time is bigger (smaller) than the mean time whenever the squared coefficient of variation \(C_{v}^{2}\), is greater (less) than 1.

The concept of a mean residual vector is useful in succeeding chapters. Here we derive the known result that gives the pdf of \(X_{r}\), the time remaining for a customer who has been in service for an indefinite period. We do this simply by replacing \(\mathbf{p}\) with \(\mbox{\bbpi}_{\mbox{\bbpi}}\) in (3.1.7d). Then

\[b_{r}(x)=\mbox{\bbpi}_{\mbox{\bbpi}}\,\mathbf{B}\exp(-x\mathbf{B})\mbox{\bbepsilon }^{\prime}=\frac{\mathbf{p}\mathbf{V}}{\Psi\,[\mathbf{V}]}\mathbf{B}\exp(-x \mathbf{B})\mbox{\bbepsilon}^{\prime}=\frac{\Psi\,[\exp(-x\mathbf{B})]}{\bar{x }}.\]

<!-- Pages 192-192 -->

But the numerator is \(R(t)\), the reliability function of (3.1.7b), so

\[b_{r}(t)=\frac{R(t)}{\bar{x}}\:. \tag{3.5.13}\]

**Exercise 3.5.8:** You have to catch a train to Leipzig from the Haupt-bahnhof Station in Munich, which you know leaves every hour. Therefore, the time between departures is exactly one hour, and its density function is given by \(b(x)=\delta(x-1)\) from (3.2.5a). \(x\) is measured from the time of the previous departure, but you don't know what that time is when you arrive at the station. You could have just missed it, so you may have to wait a whole hour for the next train, or you could be just on time and get on board right away. Or, it could be anywhere in between, all with equal probability. In other words, the time remaining is uniformly distributed with a mean of \(1/2\) hour. Find a representation of the uniform distribution using the residual vector in (3.5.10b) and the representation of the Dirac delta function of (3.2.5a) to create \(b_{r}(x)\) as given by (3.5.13).

##### Renewal Processes

We now return to the question presented in the first paragraph of the preceding section. For definiteness, suppose that at time \(0\), \(C_{1}\) began service, and that at time \(x>0\), \(n\) customers had already been served (i.e., \(Y_{n}\leq x<Y_{n+1}\)). What can be said of the events occurring in the interval \((x,x+\Delta]\)? It turns out that the generalizations of (3.5.3) contain all the information needed. Define the vector \(\mathbf{r}(x,n)\) with \(m\times n\) components

\[\mathbf{r}(x,n):=\mathbf{p_{n}}\exp(-x\mathbf{B_{n}}), \tag{3.5.14}\]

where, from Exercise 3.5.3, we know that \(\mathbf{B_{n}}\) is an \(n\times n\) matrix whose components are \(m\times m\) matrices. The matrices on the diagonal are all \(\mathbf{B}\), and all the matrices on the super diagonal are \(-\mathbf{BQ}\) as, for instance, (3.5.3c). \(\mathbf{r}(x,n)\) is actually the reliability vector function already defined in (3.1.7a) for the process described by Figure 3.5.2. Component \((km+j)\) is the probability that our customer is at phase \(j\) in \(S_{k+1}\) at time \(x\), for \(0\leq k<n\) and \(1\leq j<m\). This in turn means that he has already visited \(S_{1}\) through \(S_{k}\) but is presently in \(S_{k+1}\). We have already argued that a single customer passing successively through \(k\) identical subsystems is equivalent to a renewal epoch of \(k\) customers going through \(S\) one at a time. Therefore, the sum of probabilities of being somewhere in \(S_{k+1}\) must be the same as the \(P_{k}(x)\) defined by (3.5.4a). That is,

\[P_{k}(x,n)=\sum_{j=km+1}^{(k+1)m}\left[\mathbf{r}(x,n)\right]_{j}\]

<!-- Pages 193-193 -->

is the probability that exactly \(k\) customers have been served in the interval (0, x]. Strictly speaking, this is true only for \(k\leq n\). The complete analysis should only apply for \(n=\infty\) or at least for \(n\) large enough so that \(P_{k}(x)\) is negligible for all \(k>n\). How large \(n\) must be to achieve this depends strongly on how large \(x\) is, because longer intervals of time permit more customers to be served.

The problem of choosing \(n\) for practical computation is not as serious as it would seem. \(\mathbf{B_{n}}\) describes a system with no feedback (all the matrices below the diagonal are \(\mathbf{0}\)) and consistent with its definition,

\[P_{k}(x,n_{1})=P_{k}(x,n_{2})=P_{k}(x),\quad\forall\;\;k\leq n_{1}\leq n_{2}.\]

This must be true, because whether a customer leaves after visiting \(n\) subsystems or moves on to \(S_{n+1}\) should have no effect on how much time was spent at each previous \(S\). This must hold true for the components of \(\mathbf{r}(x,n)\) as well. Therefore,

\[\left[\mathbf{r}(x,n)\right]_{i}=\left[\mathbf{r}(x,n+1)\right]_{i}\quad \forall\;\;i\leq n\times m.\]

There are no convergence difficulties in talking about an infinite-dimensional \(\mathbf{B}_{\infty}\), therefore we delete the argument, \(n\), in \(P_{k}(x,n)\) and \(\mathbf{r}(x,n)\), and define the set of \(m\)-dimensional vectors \(\boldsymbol{\pi}(x,k)\) as

\[\boldsymbol{\pi}(x,k):=\frac{1}{P_{k}(x)}\left[r_{km+1}(x),r_{km+2}(x),\ldots, r_{(k+1)m}(x)\right],\] (3.5.15a) where \[\boldsymbol{\pi}(x,k)\boldsymbol{\epsilon}^{\prime}=1.\]

Put differently,

\[\mathbf{r}(x,\infty)=[P_{\mathrm{o}}(x)\boldsymbol{\pi}(x,0),\;P_{1}(x) \boldsymbol{\pi}(x,1),\;P_{2}(x)\boldsymbol{\pi}(x,2),\,\ldots] \tag{3.5.15b}\]

[\(P_{k}\) is a scalar and \(\boldsymbol{\pi}(x,k)\) is an \(m\)-vector]. We are coming down the home stretch now.

It should be clear that \([\boldsymbol{\pi}(x,k)]_{i}\) is the conditional probability that \(C_{k+1}\) is at phase \(i\) at time \(x\), given that \(C_{k}\) has finished. Therefore it can be used in the same way that the initial vector \(\boldsymbol{\pi}\) is used, except that we now start measuring at time \(x\). For instance, the renewal density for the interval \((x,x+\Delta]\), given that exactly \(k\) customers were served from 0 to \(x\), is

\[m(\Delta;x,k):=\boldsymbol{\pi}(x,k)\exp(-\Delta\mathbf{B_{r}})\mathbf{B} \,\boldsymbol{\epsilon}^{\prime}. \tag{3.5.15c}\]

Let \(X_{n}(x)\) be the r.v. for the service time remaining for \(C_{n+1}\) given that it was in service at time \(x\) (a conditional residual time). Then

\[\bar{x}(x,n)\;=\,\boldsymbol{\mathbb{E}}[X_{n}(x)]=\boldsymbol{\pi}(x,n) \mathbf{V}\,\boldsymbol{\epsilon}^{\prime}. \tag{3.5.15d}\]

The number of sequences of events that can be analyzed in this way is unlimited. For instance, one can analyze the renewal process starting at some time \(x_{2}\), given that \(k_{1}\) customers were served in the interval before \(x_{1}\), and \(k_{2}\) customers were served in the interval \((x_{1},x_{2}]\), and so on. Of course, the longer the sequence of conditions, the less interesting the results, for they must ultimately converge to the results using \(\boldsymbol{\pi_{r}}\). Well, maybe.

<!-- Pages 194-194 -->

#### Two Illustrations of Renewal Processes

In discussing renewal theory, we have introduced three views, corresponding to Figures 3.5.1 to 3.5.3, none of which actually correspond to the standard description in terms of arrivals. There should be no problem of changing our view from arrivals to departures, but the formulas derived from the three distinct viewpoints given in the previous sections are bound to be at least somewhat confusing. In this subsection we illustrate the various formulas for two distributions. The first assumes that \(S\) has only one internal state, and thus represents an exponential server. This leads us to yet another derivation of the Poisson process. In the second example \(S\) represents the Erlangian-2 distribution.

##### The Poisson Process

As always, for exponential distributions, \(\mathbf{B}\Rightarrow\mu\), and \(\mathbf{p},\mathbf{Q}\), and \(\boldsymbol{\epsilon^{\prime}}\) all equal 1. Many formulas have already been reduced to their exponential results (or have been left to the exercises). We finish the job here. First consider (3.5.9d). The pdf \(f(x;\alpha)\) is the density function for a subsystem with external feedback, as shown in Figure 3.5.3. If \(S\) itself is exponential, so is \(S_{r}\), for, as we showed for \(m(x;\alpha)\) following (3.5.9g),

\[f(x;\,\alpha)=(1-\alpha)\mu\,e^{-(1-\alpha)\mu x}.\]

This is an exponential distribution with mean service rate \(\mu^{\prime}=(1-\alpha)\mu\). We discussed the underlying significance of this in Lemma 3.5.2. But this tells us something else as well, which we state as another lemma.

**Lemma 3.5.5:** If any diagonal element of a transition matrix is greater than 0, it can be replaced by 0, with a commensurate change in its service rate and the other elements of \(\mathbf{P}\) in that row. That is, suppose that \(P_{ii}>0\). Then let \(\alpha=P_{ii}\) and

\[\text{new }P_{ii} =0;\qquad\text{new }P_{ij}=\frac{P_{ij}}{1-\alpha}\quad\text{for }\ j\neq i;\] \[\text{new }M_{ii} =M_{ii}(1-\alpha).\]

The new \(\mathbf{P}\) and new \(\mathbf{M}\) will yield the same results as the original ones. Thus one can assume (if convenient) that the diagonal elements of a transition matrix are all 0, without loss of generality. \(\blacksquare\)

The discussion on residual and delayed times has no significance when applied to exponential servers, because \(\boldsymbol{\pi_{\mathbf{r}}}(x)\) as defined in (3.5.11b) is always 1 because \(\mathbf{B_{r}}=\mathbf{0}\). Everything is memoryless, and remains the same as it was at the beginning, until the customer leaves.

<!-- Pages 195-195 -->

We then go to (3.5.14), for \(n=\infty\). Here [compare with (3.5.3c) and (3.2.3b)]

\[{\bf B}_{\infty}=\mu\left[\begin{array}{cccccc}1&-1&0&0&0&\cdots\\ 0&1&-1&0&0&\cdots\\ 0&0&1&-1&0&\cdots\\ 0&0&0&1&-1&\cdots\\ :&:&:&:&:&\cdots\end{array}\right].\]

To evaluate \(\exp(-x{\bf B}_{\infty})\), one needs \(({\bf B}_{\infty})^{k}\) for all \(k\). It can be proven by induction that

\[({\bf B}_{\infty}{}^{k})_{ij}=\mu^{k}(-1)^{j-i}\left(\begin{array}{c}k\\ j-i\end{array}\right)\quad\mbox{for}\;\;j\geq i,\] (3.5.16a) and \[0\] otherwise. Therefore, without too much mathematical difficulty, we get the expression (using \[y=\mu x\] )

\[\exp(-x{\bf B}_{\infty})=e^{-y}\left[\begin{array}{cccccc}1&y&y^{2}/2!&y^{3 }/3!&y^{4}/4!&\cdots\\ 0&1&y&y^{2}/2!&y^{3}/3!&\cdots\\ 0&0&1&y&y^{2}/2!&\cdots\\ 0&0&0&1&y&\cdots\\ :&:&:&:&1&\cdots\\ :&:&:&:&:&\cdots\end{array}\right].\]

From its definition in (3.5.3a),

\[{\bf p}_{\infty}=[1,0,0,0,0,\cdots],\]

so \({\bf r}(x,\infty)\) is the top row of \(\exp(-x{\bf B}_{\infty})\), or

\[{\bf r}(x,\infty)=\left[e^{-y},ye^{-y},\frac{y^{2}e^{-y}}{2!},\frac{y^{3}e^{-y }}{3!},\cdots\right].\]

We know that \(m=1\) from Section 3.5.3, so we get (as no surprise to anyone)

\[P_{k}(x)=\frac{(\mu x)^{k}e^{-\mu x}}{k!}, \tag{3.5.16b}\]

the Poisson probabilities of finding \(k\) departures in time interval \(x\) [compare with (2.1.15) and (3.5.4c)].

##### 3.5.4.2 Renewal Process with \(E_{2}\) Interdeparture Times

One of the advantages of the methods in this book is that the expressions can easily be directly numerically evaluated automatically by computer. However, it is not easy to get physical insight unless one carries out many parametric studies, presenting the results graphically. As it happens, if \(m\) (the dimensionality of \(S\)) is small enough, we can find explicit expressions from the matrix formulas. The smallest nontrivial case is then \(m=2\). We now consider one such example.

<!-- Pages 196-196 -->

The Erlangian distribution was discussed in Section 3.2.1 and Equation (3.2.1a). Recall that \(E_{k}(x)\) corresponds to \(k\) identical exponential phases in tandem, each with service rate \(\mu\). Then for \(k=2\),

\[\mathbf{B}=\mu\left[\begin{array}{cc}1&-1\\ 0&1\end{array}\right]\quad\text{and}\quad\mathbf{Q}=\left[\begin{array}{cc}1 &0\\ 1&0\end{array}\right].\]

From (3.5.9b),

\[\mathbf{B}_{\mathbf{r}}(\alpha)=\mathbf{B}(\mathbf{I}-\alpha\mathbf{Q})=\mu \left[\begin{array}{cc}1&-1\\ -\alpha&1\end{array}\right].\]

To get explicit expressions for \(f(x;\alpha)\), \(m(x;\,\alpha)\), and whatever else might be interesting, we must first get an explicit form for \(\exp[-x\mathbf{B}_{\mathbf{r}}(\alpha)]\). It is not hard to show that the eigenvalues for \(\mathbf{B}_{\mathbf{r}}(\alpha)\) are \((1\pm\sqrt{\alpha})\), with eigenvectors (for convenience let \(\beta=\sqrt{\alpha}\)):

\[\mathbf{u}_{\pm}=[-1,\pm\beta]\quad\text{and}\quad\mathbf{v}_{\pm}^{\prime}= \frac{1}{2}\left(\begin{array}{c}-1\\ \pm 1/\beta\end{array}\right).\]

Because the eigenvalues are distinct, we can use (1.3.8c) to get (where \(y=\mu x\beta\))

\[\exp[-x\mathbf{B}_{\mathbf{r}}(\alpha)]=e^{-\mu\,x}\left[\begin{array}{cc} \cosh y&\sinh y/\beta\\ \beta\,\sinh y&\cosh y\end{array}\right]. \tag{3.5.17}\]

We use this to find \(f(x;\alpha)\) from (3.5.9d). Let \(\boldsymbol{\pi}\) have components \(\pi_{1}\) and \(\pi_{2}\), whose sum is \(1\); then

\[f(x;\alpha)=(1-\alpha)\mu e^{-\mu x}\left(\pi_{1}\frac{\sinh y}{\beta}+\pi_{2} \,\cosh y\right).\]

This certainly is not a simple expression even if \(\pi_{2}=0\), that is, when \(\boldsymbol{\pi}=\mathbf{p}\). In this case

\[f(x;\,\alpha)=\frac{1-\alpha}{2\beta}\mu\left(e^{-\mu\,x(1-\beta)}-e^{-\mu x( 1+\beta)}\right).\]

It is not clear what the generalization for Lemma 3.5.5 is when \(S\) is not exponential. We have already noted (Lemma 3.5.2) that a subsystem with external feedback, as in Figure 3.5.3, has the same dimensionality as the subsystem without feedback. The last equation shows that an Erlangian-2 with feedback is equivalent to a subsystem of two unequal phases in tandem, with \(no\) feedback. The service rates of the two phases are the eigenvalues of \(\mathbf{B}_{\mathbf{r}}(\alpha)\). But, of course, this should have been clear from Section 3.2.1. As might be expected, when \(\alpha=1\), \(f(x;1)\) is identically \(0\), corresponding to the fact that our looping customer is forever imprisoned in \(S_{r}\).

We know from (3.5.8a) that \(m(x;\alpha)=f(x;\alpha)/(1-\alpha)\), therefore

\[m(x;\alpha)=\frac{\mu}{2}e^{-\mu x}\left(\pi_{1}\beta(e^{\mu\beta x}-e^{-\mu \beta x})+\pi_{2}(e^{\mu\beta x}+e^{-\mu\beta x})\right).\]

Recall from (3.5.9g) that \(m(x;\alpha)\) is the generator of the convolutions of \(b(x)\). In this case

\[b(x)=b_{1}(x)=m(x;0)=\pi_{1}\,E_{2}(x;\mu)+\pi_{2}\,\mu\,e^{-\mu x}.\]

<!-- Pages 197-197 -->

This makes sense. If our customer starts at the second phase (\(\pi_{2}\)), he will leave in exponential time. But if he starts at the first phase (\(\pi_{1}\)), he must go through both phases, taking Erlangian-2 time to leave.

**Exercise 3.5.9:** From (3.5.9g), find the \(k\)-th convolutions of \(b(x)\). In particular, show that if \(\pi_{1}=1\), then the \(k\)-th convolution is the Erlangian-\(2k\), but if \(\pi_{2}=1\), then the \(k\)-th convolution is the Erlangian of order \(2k-1\).

From (3.5.8c) the renewal density for our example is (recall that \(\beta=\sqrt{\alpha}\))

\[m(x)=m(x;1)=\frac{\mu}{2}\left[1+(\pi_{2}-\pi_{1})e^{-2\mu x}\right].\] (3.5.18a) Observe that as \[x\] goes to infinity \[m(x)\] approaches \[\mu/2\], which is \[1/\bar{x}\], consistent with the first form of the renewal theorem (Theorem 3.5.3a). Also note that if \[\pi_{1}=\pi_{2}\], then \[m(x)\] is always \[1/\bar{x}\]. This is consistent with the third form of the renewal theorem (Theorem 3.5.3c), because the mean residual vector [from (3.5.10b)] is \[\boldsymbol{\pi_{\mathrm{F}}}=[0.5,\ 0.5]\]. In words, given that both phases have equal service times and we do not know where our customer started, it will be at either one with equal probability.

The renewal function can be found from \(m(x)\) by simple integration,

\[M(\Delta)=\int_{\mathrm{o}}^{\Delta}m(x)dx=\frac{\Delta}{\bar{x}}+\frac{\pi_{ 2}-\pi_{1}}{2\,\mu\,\bar{x}}\left(1-e^{-2\mu\Delta}\right). \tag{3.5.18b}\]

Given that\(M(\Delta)\) is the mean number of departures in interval \(\Delta\), \(M(\Delta)/\Delta\) is the mean number of departures per unit time in that interval. This has a finite limit as \(\Delta\) goes to infinity, and should be compared with \(m(\Delta)\), which is the departure rate at the end of the interval. Note that

\[\frac{M(\Delta)}{\Delta}=\frac{1}{\bar{x}}+\frac{\pi_{2}-\pi_{1}}{\bar{x}} \frac{1-e^{-2\mu\Delta}}{2\,\mu\,\Delta}\;. \tag{3.5.18c}\]

We see that \(M(\Delta)/\Delta\) approaches the same limit as \(m(\Delta)\), but much more slowly. Even when \(\exp(-\mu\Delta)\) is negligible, a term in \(1/\Delta\) persists (unless the system started in the mean residual state). This is analogous to the average system behavior described in Chapter 1 [see (1.3.12b) and the discussion following it], and in fact, the dependence on \(\Delta\) is identical. We next move on to the residual vector defined in (3.5.11b). Instead of starting with \(\mathbf{p}\), we start with the more general \(\boldsymbol{\pi}\), and get with the aid of (3.5.17) for \(\alpha=\beta=1\),

\[\boldsymbol{\pi_{\mathrm{F}}}(x) =\boldsymbol{\pi}\exp(-x\mathbf{B_{r}})\] \[=e^{-\mu x}[\pi_{1}\cosh(\mu\,x)+\pi_{2}\sinh(\mu\,x),\ \pi_{1}\sinh(\mu\,x)+\pi_{2}\cosh(\mu\,x)],\]

which in this case rearranges to

\[\boldsymbol{\pi_{\mathrm{F}}}(x)=[0.5,\ \ 0.5]+\frac{\pi_{2}-\pi_{1}}{2}e^{-2\mu \,x}[-1,\ \ 1]. \tag{3.5.19}\]

<!-- Pages 198-198 -->

This can be used, for instance, to calculate \(X_{r}(x)\), the time remaining for the trapped customer to complete his present service, given that he has been going in circles for time \(x\). That is,

\[\bar{x}_{r}(x):=\mathbb{E}[X_{r}(x)]=\boldsymbol{\pi_{\pi}}(x)\mathbf{V} \boldsymbol{\epsilon^{\prime}}=\frac{1}{2\,\mu}[3-(\pi_{2}-\pi_{1})e^{-2\mu x }].\]

As \(x\) goes to infinity, we get the mean residual time \(\bar{x}_{r}\), which is \(3/(2\mu)\), or \(3\bar{x}/4\), irrespective of the initial state.

**Exercise 3.5.10:** Prove the formula above. Show that \(\bar{x}_{r}(0)=\bar{x}\) for \(\boldsymbol{\pi}=[1,\ \ 0]\).

We next evaluate the delayed renewal density, either using the material preceding Theorem 3.5.3b or by taking (3.5.19) as the starting vector for \(m(x)\). In either case we get

\[m_{r}(\Delta;x)=\frac{\mu}{2}\left[1+(\pi_{2}-\pi_{1})e^{-2\mu\,(x+\Delta)} \right].\] (3.5.20a) For any finite \[\Delta\], as \[x\] grows large, \[m_{r}(\Delta;\,x)\] approaches \[1/\bar{x}\], as was described in the second form of Theorem 3.5.3.

The delayed renewal function also follows easily. As above,

\[M_{r}(\Delta;x):=\int_{\mathrm{o}}^{\Delta}m_{r}(s;\,x)\,ds\]

\[=\frac{\mu\,\Delta}{2}+\frac{\pi_{2}-\pi_{1}}{2}e^{-2\,\mu\,x}\left(1-e^{-2\, \mu\,\Delta}\right). \tag{3.5.20b}\]

As with (3.5.18c) the behavior as \(x\) goes to infinity can be examined best by looking at \(M/\Delta\). Then for any \(\Delta\),

\[\frac{M(\Delta;x)}{\Delta}=\frac{1}{\bar{x}}\left[1+(\pi_{2}-\pi_{1})e^{-2\, \mu\,x}\frac{1-e^{-2\,\mu\,\Delta}}{2\,\mu\,\Delta}\right]. \tag{3.5.20c}\]

Note that \(M(\Delta;\,x)\) approaches the expected limit \((1/\bar{x})\) much more rapidly than does \(M(\Delta)\) [which is really \(M(\Delta;\,0)\)]. Thus if one waits some time, \(x\), before beginning measurements, successive intervals of \(\Delta\) will yield the same average number of completions.

**Exercise 3.5.11:** Let \(2\,\mu=1\) and \(\boldsymbol{\pi}=[0\ \ 1]\); then compare Equations (3.5.18) and (3.5.20c) for \(\Delta=2\) and increasing \(x\).

In dealing with residual vectors, we have given the impression that all information about the internal state of the subsystem is gradually lost as time goes on. This is true only because observations concerning past behavior

<!-- Pages 199-199 -->

have not been included in estimating the future. In the discussion following (1.3.15b) it was pointed out that in a discrete Markov chain, time and the counting of events were synonymous, whereas a continuous chain soon loses track of the number of events. In the second part of Section 3.5.3 it was shown that knowledge of the number of past departures can be incorporated into estimations of future behavior. We will show presently that such information can affect appreciably what is likely to happen.

First we must determine \(\mathbf{r}(x,\infty)\) from (3.5.14) for our present example. To do this, in addition to the matrices already evaluated at the beginning of this section, we need \(\mathbf{BQ}\), which is easily shown to be

\[\mathbf{BQ}=\mu\left[\begin{array}{cc}1&-1\\ 0&1\end{array}\right]\left[\begin{array}{cc}1&0\\ 1&0\end{array}\right]=\mu\left[\begin{array}{cc}0&0\\ 1&0\end{array}\right].\]

We must also have \(\mathbf{p}_{\infty}\), which is the same as (3.5.3a), where each element is a two-vector, with \(\boldsymbol{\pi}=[\pi_{1},\ \ \pi_{2}]\).

We next set up \(\mathbf{B}_{\infty}\) and find that it is identical with the \(\mathbf{B}_{\infty}\) we had for the exponential distribution, except that all rows and columns are taken two at a time. Observe that each 2 by 2 block on the diagonal of \(\mathbf{B}_{\infty}\) in the first part of Section 3.5.3.1 is precisely \(\mathbf{B}\), and the 2 by 2 blocks above and to the right of the diagonal blocks are all \(-\mathbf{BQ}\). We are indeed fortunate, because \(\exp(-x\mathbf{B}_{\infty})\) is the same as that in the preceding section. Equations (3.5.15) imply that (again \(y=\mu\,x\))

\[\boldsymbol{\pi}(x,\,k)=\left[\pi_{1}\frac{y^{2k}}{(2k)!}+\pi_{2}\frac{\delta_ {k\alpha}y^{2k-1}}{(2k-1)!},\ \ \pi_{1}\frac{y^{2k+1}}{(2k+1)!}+\pi_{2}\frac{y^{2k}}{(2k)!}\right]\frac{e^{-y}} {P_{k}(x)}\]

and

\[P_{k}(x)=\frac{y^{2k-1}e^{-y}}{(2k+1)!}[(2k+1)y+\pi_{1}\,y^{2}+\pi_{2}\,(2k)\, (2k+1)].\] (3.5.21a) Therefore, \[\boldsymbol{\pi}(x,k)=\frac{\left[\pi_{1}\,(2k+1)\,y+\pi_{2}\,(2k)(2k+1),\ \ \pi_{1}\,y^{2}+\pi_{2}\,(2k+1)\,y\right]}{(2k+1)y+\pi_{1}\,y^{2}+\pi_{2}\,(2k)( 2k+1)}\,.\] (3.5.21b) Observe that \[\boldsymbol{\pi}(0_{+},\,0)=[\pi_{1},\ \ \pi_{2}]\], and for \[k>0\], \[\boldsymbol{\pi}(0_{+},\,k)=[1,\ \ 0]\].

Ordinarily, not too much credence should be placed in physical interpretations of the components of the internal states of a subsystem, because there may be many equivalent representations of \(S\). In this case, however, there is some insight to be gained. When \(x\) is very small, one should expect \(C_{1}\) to still be in \(S\), and in his starting state. This is exactly the case, because \(P_{k}(0_{+})\) is essentially 0 except for \(k=0\). Given the highly unlikely event that \(k-1\) customers have already left in \(0_{+}\) time, \(C_{k}\) would almost surely have not progressed much beyond just entering. This is indeed the case, because \(\boldsymbol{\pi}(0_{+},k)=\mathbf{p}\), the entrance vector.

As \(y\) increases, the second component of \(\boldsymbol{\pi}(x,k)\) also increases, and when \(y\) is approximately equal to \(2k\), the two components are comparable. As

<!-- Pages 200-200 -->

increases further, the second component becomes much larger than the first, and approaches 1. This has a direct physical interpretation. One would expect approximately \(k\) customers to be served in time \(2k/\mu\), so if \(x\) is much larger than that, \(C_{k}\) has surely been in service a long time and must be at the second phase by now. Again the reader is warned that such interpretations are risky, and is referred to the discussion in Section 3.4. The important point to note is that depending on \(k\) and \(x\), the internal state of \(S\) could be vastly different from \(\mathbf{p}\) or \(\boldsymbol{\pi_{\mathbf{r}}}\), the mean residual vector (which in this case is \([0.5,\ \ 0.5]\)).

There is a useful statement that can be said in general. If many more customers have actually been served than one would expect in the time interval under measurement, the internal state vector of \(S\) will be close to the entrance vector. If the number that have been served is comparable to the expected number, the internal state will be closer to \(\boldsymbol{\pi_{\mathbf{r}}}\). Finally, if far fewer customers have been served than might be expected, \(S\) will be described by a completely different state vector. In any case, the initial vector (in this case, \(\boldsymbol{\pi}=[\pi_{1},\ \ \pi_{2}]\)) will be washed out.

Whatever might or might not be said about the internal state of \(S\), many different predictions can be made. First, we can calculate the mean time to the next departure, given the number that have already departed, from Equations (3.5.21).

**Exercise 3.5.12:** Let \(\mu=2\) per minute, and suppose that measurement began at the moment a customer began service. In the interval \((0,2]\), \(0\leq k\leq 10\) customers have been served. What is the mean time for the next customer to depart \([\bar{x}(2,k)]\)? Make a table for \(k\) versus \(\bar{x}\). Suppose the interval is \((0,4]\). What are the \(\bar{x}\)s now?

**Exercise 3.5.13:** Do the same as in Exercise 3.5.12, except that now you have no idea when the first customer you counted began service. Compare and discuss the two pairs of results.

Another interesting number to look at is the renewal function conditioned on \(k\) departures in the previous interval of time. Equations (3.5.18) can be used for this purpose. But instead of using the initial vector \(\boldsymbol{\pi}\), we use \(\boldsymbol{\pi}(x,k)\), which is, after all, the initial vector starting at \(x\).

**Exercise 3.5.14:** Suppose that \(0\leq k\leq 10\) customers have finished in the first 2 minutes, as in Exercise 3.5.12. What is the expected number of departures in the next 2 minutes? In the next 4 minutes? Summarize your answers in a table. Also calculate the number you would have expected in the first 2 minutes.

<!-- Pages 201-201 -->

The marginal probabilities of having \(n\) departures in the interval \((x,x+\Delta]\), conditioned on having had \(k\) completions up to then can be calculated using (3.5.21a) (where \(n\) replaces \(k\) and \(\Delta\) replaces \(x\)), again using the appropriate components from (3.5.21b) instead of the initial vector \(\boldsymbol{\pi}\). The number of necessary parameters is growing steadily now; we have \(n\times k\times x\times\Delta\) possibilities. A formal presentation of even more complex formulas becomes increasingly difficult, because one loses track of everything that is going on. But still, let us have one more exercise.

**Exercise 3.5.15:** Compare the \(P_{n}(x)\) as defined in (3.5.4a) for a Poisson process, and a renewal process where the interdeparture times are distributed according to an Erlangian-2 distribution. Assume that measurement begins when \(C_{1}\) enters \(S\), and that the mean interdeparture time in all cases is 1 minute. Calculate the \(E_{2}\) process for four different conditions.

1. The interval for counting the number of arrivals is \((0,2]\) [Equation (3.5.21a)].
2. The interval for counting arrivals is \((2,4]\), and no customer completed service previously [(3.5.21a) conditioned by (3.5.21b)].
3. The same as condition 2 except that two customers had completed service in the interval \((0,2]\).
4. The same as condition 3, but for four customers.

Construct a single table of numbers that has the Poisson and all four Erlangian cases for \(0\leq n\leq 10\), and discuss their similarities and differences.

We have one more extension to discuss before giving up on this chapter. This is done by example, although it should be clear how one can generalize to any subsystem. Although it may be difficult (and often impossible) to know what is going on inside \(S\), it is easy to keep track of the number of customers departing in successive intervals. In a different approach related to the technique of _embedded Markov chains_, one waits until a customer begins service before taking measurements. In that case, the period always begins with \(\boldsymbol{\pi}=\mathbf{p}\). When the interval is over, one waits for the next completion before measuring again. But then the mean number of departures is not \(\Delta/\bar{x}\), even for large time, because we are always starting over. In Chapter 6, \(S\) is generalized so that several customers can be served at once. In that case, when a customer leaves, the internal state of the residual subsystem is not known, so one cannot start over until \(S\) is completely empty. Such behavior is called a _semi-Markov process_, and is discussed fully in Chapter 8. The technique described herein does generalize to multiple customer service without any conceptual complications.

<!-- Pages 202-202 -->

**Example 3.5.1:** Consider an example such as Exercise 3.5.14. Initially, \(S\) is in state \(a[1,0]\). Suppose that in the first minute \(C_{1}\) and \(C_{2}\) have both finished, but \(C_{3}\) is still in \(S\). At that moment, \(C_{3}\) will be at phase 1 with probability \([\pi\!\!\!\!/(1,2)]_{1}\). Using (3.5.21b) (with \(\pi_{1}=1\)), this probability is 0.7143. Now suppose that \(C_{3}\) is still busy by the end of the second minute; then at that moment it is at phase 1 with probability 0.2941. One gets this by using (3.5.21b) again, but this time \(\pi_{1}=0.7143\), and of course, \(\pi_{2}=0.2857\). If one measures the number of completions in the interval \((0,2]\) without noting how many finished in the first minute, the probability that \(C_{3}\) will be at phase 1 is 0.5556.

Interestingly enough, if no customers finish in the first minute, and two finish in the second minute, the sequence for phase 1 to be busy is \(1.0000\to 0.3333\to 0.6757\), but if one customer finishes in each of the two minutes, the sequence is \(1.0000\to 0.6000\to 0.5556\). This happens to be the same as when going to 2 without considering the number at 1, but this is not always the case. Anyway, we see that the three different ways of having two completions in 2 minutes, keeping track of how many completed in the first minute, yield different results. Now, for instance, in calculating the mean time for \(C_{3}\) to finish using the data above and (3.5.15d), we get three different answers, 0.837838, 0.777778, and 0.647059 minute, respectively, for 2, then 0; 1, then 1; and 0, then 2. \(\blacktriangle\)

**Exercise 3.5.16:** Extend the discussion above to three 1-minute intervals where a total of three customers finished service. What is the mean time until \(C_{4}\) finishes in each case?

It is hoped that the reader can now extend this procedure to any example. Any information that one has concerning past behavior of a system should be usable in calculating conditional events in the future.

with Rational Laplace transform

<!-- Pages 203-203 -->

## Chapter 4 M/G/1 Queue

_The shortest path between two truths in the real domain passes through the complex domain._

J. Hadamard

_A mathematician may say anything he pleases, but a scientist must be at least partially sane._

Willard Gibbs

We are finally ready to look at nonexponential queues in earnest. In Chapter 2 we looked at closed loops in which both subsystems were single servers with exponential service time distributions. We showed how to transform a closed system into an open one, and how certain types of non steady-state behavior should be analyzed. In Chapter 3, we showed how a large class of nonexponential servers (ME distributions) can be treated exactly, using a matrix representation, and applied it to examining various aspects of renewal processes, as well as the specific behavior of a single general server, including residual times. We now combine those two chapters in studying the M/ME/1 queue, first looking at steady-state closed systems, then "opening" them, and finally, extending the transient results of Chapter 2. In those cases where a particular result does not depend on the specific properties of a matrix, the result becomes applicable to M/G/1 queues as well. Much of this material is an outgrowth of the Ph.D. thesis by John L. Carroll [Carroll79], and the associated papers, [CarrollLipvdL82], and [TehranipourvdLLip89]. Equivalent results were also obtained by Marcel Neuts [Neuts82].

### 4.1 S.s. M/Me/1// \(N\) (and M/Me/1/ \(N\)) Loop

We start, as always, by making some new definitions. In Chapter 2 each state could be described uniquely by \(n\), the number at \(S_{1}\), whereas in Chapter 3 the states were described by identifying the phase in \(S_{1}\) where the active customer was. Here both must be specified to describe uniquely a state of the system shown in Figure 4.1.1. This figure is itself a combination of Figures 2.1.1 and 3.1.1, where the single server, \(S_{1}\) of Figure 2.1.1 is replaced by the \(m\)-phase subsystem, S, of Figure 3.1.1.

All the objects in the following list are the same as defined in Chapter 3: **p**, **P**, **q\({}^{\prime}\)**, **\(\boldsymbol{\epsilon^{\prime}}\)**, **M**, **B**, **V**, **Q**\(\boldsymbol{=\epsilon^{\prime}}\)**p**, and the linear operator, \(\Psi\left[\,\cdot\,\right]\). For a closed

<!-- Pages 204-204 -->

system with \(N\) customers, define the following.

_Definition 4.1.1_

\([\boldsymbol{\pi}(n;N)]_{i}:=\) _steady-state probability that there are n customers in the queue at \(S_{1}\), and the one being served is at phase i. \(n\)_ includes the customer being served, and \(\boldsymbol{\pi}(n;N)\) is a row vector with \(m\) components. The associated scalar probability, \(r(n;N)\) is the same as Definition 2.1.1. 

Although \(\boldsymbol{\pi}_{i}(0;N)\) has no meaning (if no customers are at \(S_{1}\), no phase can be busy), it is useful to define the vector

\[\boldsymbol{\pi}(0;N):=r(0;N)\mathbf{p}. \tag{4.1.1}\]

Then for all \(n\), \(0\leq n\leq N\),

\[r(n;\ N)=\sum_{i=1}^{m}\pi_{i}(n;N)=\boldsymbol{\pi}(n;N)\boldsymbol{\ell}^{ \prime}. \tag{4.1.2}\]

From these definitions, we see that there are \(m\,N+1\) states describing the closed system [or \(m\,(N+1)\) states if we make believe that \(\pi

<!-- Pages 205-205 -->

superdiagonal, and subdiagonal elements are nonzero matrices. He chose the term QBD because birth-death processes are also tridiagonal, but with scalar components. He also speculated about an algebraic theory for Markovian networks [Wallace72]. All queueing systems considered here are special cases of QBD processes, but we do not look at them in that context.

#### 4.1.1 Balance Equations

Let us first introduce some new notation.

**Definition 4.1.2**: **{j; n; N}** _is an integer triplet that corresponds to one possible state of an M/ME/1//N loop. \(N\) is the total number of customers in the system, \(n\) is the number of customers at \(S_{1}\), including the one in service, and \(j\) is the phase in \(S_{1}\) that is busy. We can say that the system is in state \(\{j\,;n;\,N\}\). If we are dealing with an open system (\(N=\infty\)), we use the notation \(\{j;\,n\}\)._

\(\Xi:=\{j\,|1\leq j\leq m,\,j\) _is a phase in S\({}_{1}\}\)_. Only one customer can be active at a time in \(S_{1}\), thus \(\Xi\) is the set of all _internal states_ of \(S_{1}\). We can say that the system is in internal state \(j\in\Xi\), or that the active customer is at phase \(j\) in \(S_{1}\).

Remember, too, we are assuming that \(S_{1}\) and \(S_{2}\) operate independently. This means that only one thing happens at a time. The term "one thing" means whatever we wish. Thus a customer leaving \(S_{i}\) and being replaced immediately by the next customer in the queue is "one thing." Also, the process whereby a customer leaves one subsystem (and is replaced by a successor), goes to the other, and finding it empty immediately enters into service is "one thing." However, if two customers are active at the same time (e.g., one in each subsystem), only one at a time can change state. In general, those processes that take \(0\) time (moving from one subsystem to the other, entering \(S_{i}\), moving from one phase to another) are considered to be part of the previous process.

Recall from Theorem 1.3.3 that balance equations are valid because they are the same as \(\boldsymbol{\pi Q}=0\), the steady-state _Chapman-Kolmogorov equation_. As a direct generalization of Section 2.1.2. and (2.1.4a), [and as a special case of Equation (1.3.9a)] in order for the system to be in a steady state, the probability rate of leaving state \(\{i;\,n;\,N\}\) must be equal to the probability rate of entering that state. Thus for state \(\{\cdot;\,0;\,N\}\) we have

\[\lambda r(0;N)=\sum_{j}\pi_{j}(1;N)M_{jj}q_{j}=\boldsymbol{\pi}(1;N)\mathbf{Mq }^{\prime}.\]

In words, the probability rate of leaving the state where no one is at \(S_{1}\) is equal to the probability of there being no one there \([r(0;N)]\) times the probability rate of a customer finishing at \(S_{2}\)\([\lambda]\). The middle term of the equation above is the probability rate of entering state \(\{\cdot;\,0;\,N\}\). This is equal to the sum of probability rates of having the customer in \(S_{1}\) being served by \(j\)\([\pi_{j}(1;N)]\), who

<!-- Pages 206-206 -->

then finishes there \([\mu_{j}=M_{jj}]\), and leaves \([q_{j}]\). The rightmost expression of the equation is the matrix equivalent of the middle expression. From (3.1.1b) and (3.1.3) it follows directly that

\[\mathbf{Mq^{\prime}}=\mathbf{B\epsilon^{\prime}}.\] (4.1.3a) Thus if both sides of the preceding equation are multiplied on the right by \[\mathbf{p}\], and we use (4.1.1), we get the vector balance equation: \[\lambda\,\boldsymbol{\pi}(0;N)=\boldsymbol{\pi}(1;N)\mathbf{Mq^{\prime}}\, \mathbf{p}=\boldsymbol{\pi}(1;N)\mathbf{BQ},\] (4.1.3b) where \[\mathbf{Q}=\boldsymbol{\epsilon^{\prime}}\mathbf{p}\] is the idempotent matrix defined in Section 3.5.1 and has nothing to do with the transition rate matrix \[\boldsymbol{Q}\]. Except when direct reference is made to Chapter 1, \[\mathbf{Q}\] always has this meaning.

The balance equation for state \(\{i;\,N;\,N\}\) is derived as follows. In this case there is no one at \(S_{2}\), therefore there can be no arrivals to \(S_{1}\), but instead, the customer who is active in \(S_{1}\) can complete service at \(i\)\([\pi_{i}(N;N)M_{ii}]\), thereby causing the system to leave that state. The probability rate of entering state \(\{i;\,N;\,N\}\) is made up of two parts. Either the system could be in state \(\{i;\,N-1;\,N\}\), \([\pi_{i}(N-1;\,N)]\), and have the lone customer at \(S_{2}\) finish \([\lambda]\), or all \(N\) customers could already be at \(S_{1}\), but the active customer is at some other phase \(j\), \([\pi_{j}(N;N)]\), finishes there \([M_{jj}]\), and goes to \(i[P_{ji}]\). Note that a completion at \(S_{2}\) changes the _external state_ of the system (\(n\) goes from \(N-1\) to \(N\)) but not the internal state (the active customer at \(S_{1}\) does not move merely because a new customer has arrived at the queue, hence \(i\) in unchanged). So this equation is

\[\pi_{i}(N;N)M_{ii}=\lambda\,\pi_{i}(N-1;N)+\sum_{j}\pi_{j}(N;N)\,M_{jj}\,P_{ji}\]

or in matrix form,

\[\boldsymbol{\pi}(N;N)\mathbf{M}=\lambda\boldsymbol{\pi}(N-1;N)+\boldsymbol{ \pi}(N;N)\mathbf{MP}.\]

Remembering that \(\mathbf{B}=\mathbf{M}(\mathbf{I}-\mathbf{P})\), the equation above can be rearranged to

\[\boldsymbol{\pi}(N;N)\mathbf{B}=\lambda\boldsymbol{\pi}(N-1;N),\]

or, using \(\mathbf{B^{-1}}=\mathbf{V}\),

\[\boldsymbol{\pi}(N;N)=\boldsymbol{\pi}(N-1;N)\mathbf{V}\lambda. \tag{4.1.3c}\]

The balance equations for states where \(n\) is greater than \(0\) but less than \(N\) combine all the features of (4.1.3b) and (4.1.3c). It is useful to describe what happens in these cases with the help of the state transition diagram in Figure 4.1.2. As usual, the sum of the weights of the arrows going to \(\{i;\,n;\,N\}\) equals the sum of those leaving. So for \(i\in\Xi\), we have

\[\pi_{i}(n;N)(M_{ii}+\lambda)\] \[=\sum_{j}\pi_{j}(n;N)M_{jj}P_{ji}+\sum_{j}\pi_{j}(n+1;N)M_{jj}q_{j} \,p_{i}+\pi_{i}(n-1;N)\lambda.\]

<!-- Pages 207-207 -->

These \(m\) equations can be summarized by the vector equation

\[\boldsymbol{\pi}(n;\,N)(\mathbf{M}+\lambda\mathbf{I})=\boldsymbol{\pi}(n;N) \mathbf{M}\,\mathbf{P}+\boldsymbol{\pi}(n+1;N)\mathbf{M}\,\mathbf{q}^{\prime}\, \mathbf{p}+\boldsymbol{\pi}(n-1;N)\lambda\mathbf{I}.\]

This, in turn, can be rearranged, as with the previous equations, to yield the rest of the balance equations. For \(0<n<N\),

\[\boldsymbol{\pi}(n;N)(\mathbf{B}+\lambda\mathbf{I})=\boldsymbol{\pi}(n+1;N) \mathbf{B}\,\mathbf{Q}+\boldsymbol{\pi}(n-1;N)\lambda\mathbf{I} \tag{4.1.3d}\]

We mention here that (4.1.3d) is valid for \(n=1\) by virtue of (4.1.1).

The set of Equations (4.1.3) falls in the class of "second-order finite-difference vector equations," not a particularly informative name for our purposes. They are similar in appearance to the balance equations for the M/M/1 queue (2.1.4a) and reduce to them when \(S_{1}\) is exponential. In the next section we prove that they reduce to first-order equations and then give an explicit expression for the general solution.

Figure 4.1.2: **Steady-state transition diagram for state \(\{i;\,n;\,N\}\) of an M/ME/1//N closed loop**. An arrow pointing to the left represents a customer finishing at phase \(i\), \(\big{[}\{(\mathbf{M}+\lambda\mathbf{I})^{-1}\mathbf{M}\}_{ii}\big{]}\), and leaving \(S_{1},[\{\mathbf{q}\}_{i}]\), followed by another customer entering and going to \(j\), \([\{\mathbf{p}\}_{j}]\). There is also implicitly an arrow pointing horizontally to the left to cover the possibility that the entering customer goes to the same phase left behind by the departing customer \([p_{i}]\). A vertical arrow corresponds to a customer finishing at phase \(i\), \([(\mathbf{M}+\lambda\mathbf{I})^{-1}\mathbf{M}]\), and going to phase \(j\), \([\{\mathbf{P}\}_{ij}]\). An arrow to the right (no diagonal arrows allowed) corresponds to a customer finishing at \(S_{2}\), \([(\mathbf{M}+\lambda\mathbf{I})^{-1}\lambda]\), and immediately going to \(S_{1}\), without changing the internal state.

<!-- Pages 208-208 -->

#### 4.1.2 Steady-State Solution

First consider (4.1.3d) for \(n=N-1\):

\[\boldsymbol{\pi}(N-1;N)(\mathbf{B}+\lambda\mathbf{I})=\boldsymbol{\pi}(N;N) \mathbf{B}\,\mathbf{Q}+\lambda\boldsymbol{\pi}(N-2;N).\]

Next replace \(\boldsymbol{\pi}(N;N)\) with (4.1.3c), divide by \(\lambda\), and regroup terms to get (recalling that \(\mathbf{V}\,\mathbf{B}=\mathbf{I}\))

\[\boldsymbol{\pi}(N-1;N)\left(\mathbf{I}+\frac{1}{\lambda}\mathbf{B}-\mathbf{Q }\right)=\boldsymbol{\pi}(N-2;N).\]

Now define the important pair of matrices

\[\mathbf{A}:=\mathbf{I}+\frac{1}{\lambda}\mathbf{B}-\mathbf{Q}\] (4.1.4a) and (assuming that it exists) \[\mathbf{U}:=\mathbf{A}^{-1}. \tag{4.1.4b}\]

It then follows that

\[\boldsymbol{\pi}(N-1;N)=\boldsymbol{\pi}(N-2;N)\mathbf{U}.\] (4.1.5a) Before proving by induction that this equation is true for all \(n<N\), we enumerate a collection of simple relations (stated in the form of the following lemma) that prove useful throughout the rest of the book.

**Lemma 4.1.1:** For \(\mathbf{A}\) and \(\mathbf{U}\), defined by Equations (4.1.4), the following are matrix identities.

\[\lambda\mathbf{A}\boldsymbol{\epsilon}^{\prime}=\mathbf{B}\,\boldsymbol{ \epsilon}^{\prime},\quad\,\lambda\mathbf{V}\mathbf{A}\,\boldsymbol{\epsilon}^ {\prime}=\boldsymbol{\epsilon}^{\prime},\quad\,\mathbf{U}\,\mathbf{B}\, \boldsymbol{\epsilon}^{\prime}=\lambda\boldsymbol{\epsilon}^{\prime},\]

and since \(\mathbf{Q}=\boldsymbol{\epsilon}^{\prime}\mathbf{p}\),

\[\mathbf{U}\mathbf{B}\mathbf{Q}=\lambda\mathbf{Q}\quad\text{and}\quad\lambda \mathbf{A}\mathbf{Q}=\mathbf{B}\mathbf{Q}.\]

Similarly,

\[\lambda\mathbf{p}\mathbf{A}=\mathbf{p}\mathbf{B},\quad\,\lambda\mathbf{p}

<!-- Pages 213-213 -->

Although the two equations for \(\Lambda(N)\) must be equal, it takes some effort to prove that they are the same algebraically, which we leave for the following exercise.

**Exercise 4.1.3:** Prove by direct algebraic manipulation that

\[r(0;N)-\rho r(N;N)=1-\rho,\]

or equivalently,

\[(1-\rho)\Psi\left[\mathbf{K}(N)\right]=1-\rho\Psi\left[\mathbf{U}^{N-1}\lambda \mathbf{V}\right].\]

**Exercise 4.1.4:** Calculate \(\Lambda(N)\) for the closed \(\mathrm{M}/E_{2}/1//N\) loop, where \(\bar{x}+1/\lambda=1\) [i.e., \(\lambda=1+\rho\), and \(\bar{x}=\rho/(1+\rho)\)] and \(\rho=0.5\) for \(N=1\) through 20. Repeat the calculations for \(\rho=0.9\), \(1.0\), and \(2.0\). Draw the four curves on the same graph and compare with the graphs in Exercise 2.1.3.

**Exercise 4.1.5:** Do the same as in Exercise 4.1.4, but now \(S_{1}\) is the hyperexponential described in Exercise 4.1.2.

#### 4.1.3 Departure and Arrival Queue-Length Probabilities

In the preceding section we derived the steady-state probabilities of what a _random observer_ would see over a long period of time. There are two special sets of moments in time that deserve separate treatment. These time points are referred to as _embedding points_. _Embedded Markov chains_ are used to consider the following questions.

1. What will a customer see upon arriving at \(S_{1}\)?

2. What will a customer leave behind upon exiting \(S_{1}\)?

Given that it takes no time for a customer to go from one server to another, these questions are the same as asking the equivalent questions of \(S_{2}\). In the case of the \(\mathrm{M}/\mathrm{G}/1\) queue, the two questions turn out to have the same answer, and almost the same as \(r(n;N)\), but this is not the case for other systems. We prove the equality here and at the same time demonstrate the method that can be used in the other cases.

First we define a set of steady-state vectors.

<!-- Pages 216-216 -->

Of course, \(a(n;N)\) is also the probability that the customer will leave \(N-n-1\) customers behind at \(S_{2}\), and \(d(n;N)\) is the probability that the customer will find \(N-n-1\) other customers already waiting or being served at \(S_{2}\). We look at our loop from this point of view in Chapter 5. It is not hard to see that \(a(N;N)=d(N;N)=0\), because the arriving or departing customer cannot count himself. The other probabilities can be evaluated using the following argument.

We know the steady-state vector probabilities \([\mathbf{w}(n;N)]\) of the system's state between events. There are two types of events. Either something happens in \(S_{1}\), or something happens in \(S_{2}\). The probability that the event will occur in \(S_{1}\) is \((\lambda\mathbf{I}+\mathbf{M})^{-1}\,\mathbf{M}\) if \(n\) is not \(0\) or \(N\), whereas it is \(0\) for \(n=0\), and \(1\) if \(n=N\). If the event is in \(S_{2}\), it will result in an arrival to \(S_{1}\), and if the event is in \(S_{1}\), one of two things can happen. Either the active customer will leave \([\mathbf{q}^{\prime}]\), with another (if available) taking his place \([\mathbf{p}]\), or he will just go to another phase \([\mathbf{P}]\). All together, there are six different kinds of terms, which we now list with their probabilities. In the following set of equations we use the notation "\(\mathbf{Pr}[X\to Y]\)" to mean "the probability that the system will go to state Y at the next event, AND that it is in state X at present."

\[\begin{array}{lclclcl}(1)&\mathbf{Pr}[\{\cdot;\,0;\,N\}&\to&\{i;\,1;\,N\}]&= &[\mathbf{w}(0;\,N)]_{i};\\ (2)&\mathbf{Pr}[\{i;\,n;\,N\}&\to&\{i;\,n+1;\,N\}]&=&[\mathbf{w}(n;\,N)]_{i} \,[(\lambda\mathbf{I}+\mathbf{M})^{-1}\lambda\mathbf{I}]_{ii};\\ (3)&\mathbf{Pr}[\{j;\,n;\,N\}&\to&\{i;\,n;\,N\}]&=&[\mathbf{w}(n;\,N)]_{j}\,[ (\lambda\mathbf{I}+\mathbf{M})^{-1}\mathbf{MP}]_{ji};\\ (4)&\mathbf{Pr}[\{j;\,n;\,N\}&\to&\{i;\,n-1;\,N\}]&=&[\mathbf{w}(n;\,N)]_{j}\, [(\lambda\mathbf{I}+\mathbf{M})^{-1}\mathbf{M}\,\mathbf{q}^{\prime}\mathbf{p}] _{ji};\\ (5)&\mathbf{Pr}[\{j;\,N;\,N\}&\to&\{i;\,N;\,N\}]&=&[\mathbf{w}(N;\,N)]_{j}\,[ \mathbf{P}]_{ji};\\ (6)&\mathbf{Pr}[\{j;\,N;\,N\}&\to&\{i;\,N-1;\,N\}]&=&[\mathbf{w}(N;\,N)]_{j}\,[ \mathbf{q}^{\prime}\mathbf{p}]_{ji}.\end{array} \tag{4.1.11}\]

Of course, the sum of these terms is \(1\), and if rearranged would yield the balance equations we just used to get the \(\mathbf{w}\)s in the first place. We have enumerated them with a different purpose in mind. First, consider only those transactions that result in an arrival to \(S_{1}\): namely, (1) and (2). Their sum is the probability of an arrival to \(S_{1}\) irrespective of \(n\). The sum of the two terms in (4.1.11), whose reciprocal we call \(G_{a}(N)\), is [use Equations (4.1.10)]

\[\begin{array}{lcl}\frac{1}{G_{a}(N)}&:=&\mathbf{w}(0;N)\boldsymbol{\epsilon ^{\prime}}+\lambda\sum_{n=1}^{N-1}\mathbf{w}(n;N)(\lambda\mathbf{I}+\mathbf{M} )^{-1}\boldsymbol{\epsilon^{\prime}}\\ &=&\lambda\,C(N)\left[r(0;N)+\sum_{n=1}^{N-1}r(n;N)\right].\end{array}\]

The sum of the \(r\)'s must be \(1\), and the expression in brackets has all but one of them, therefore we get the following.

\[\frac{1}{G_{a}(N)}=\lambda C(N)[1-r(N;N)].\] (4.1.12a) By the rule of conditional probabilities \[[P(B\,|\,A)=P(B\cap A)/P(A)]\], the marginal arrival probabilities are \[G_{a}(N)\] times the appropriate terms above,

<!-- Pages 218-218 -->

For \(0\leq n<N\),

\[\mathbf{a}(n;N)=\frac{1}{1-r(N;N)}\boldsymbol{\pi}(n;N),\] (4.1.13a) \[\mathbf{d}(n;N)=\frac{r(n;N)}{1-r(N;N)}\mathbf{p},\] (4.1.13b) \[a(n;N)=d(n;N)=\frac{r(n;N)}{1-r(N;N)},\] (4.1.13c) and finally, \[a(N;N)=d(N;N)=0.\] (4.1.13d) By virtue of the completeness of ME functions, as described in Section 3.2.1, the scalar equations are true for classes of service time distributions more general than ME. Thus (4.1.13c) and (4.1.13d) are valid for all M/G/1/ /\(N\) queues. Last, note that although \(a(n;N)\) and \(d(n;N)\) are equal, their vector counterparts are not. We show how these results carry over to the open queue in succeeding sections. 

You may be wondering what terms (3) and (5) from Equations (4.1.11) contribute to the behavior of an M/ME/1 queue. After all, no customers are exchanged between \(S_{1}\) and \(S_{2}\) during these events. Their role is to give \(S_{1}\) its nonexponential character, as seen by an outside observer.

### Open M/ME/1 Queue

In Section 2.1.2 we showed how an M/M/1 /\(N\) loop becomes an open M/M/1 queue when \(N\) becomes unboundedly large. In Section 3.5 we showed that a server with an unboundedly long queue generates a renewal process, and in particular, if the server is exponential, its departures are Poisson distributed. Recall from (3.1.4b) that \(\Psi\left[\mathbf{V}\right]\) is the mean service time for \(S_{1}\) and \(\lambda\) is the mean service rate for \(S_{2}\) [see (1.1.4a) and surrounding discussion], so

\[\rho:=\textbf{utilization factor}=\lambda\Psi\left[\mathbf{V}\right]=\lambda \bar{x}.\]

Therefore, if the mean service time of our general server \(S_{1}\) is less than the mean service time of \(S_{2}\) [\(\rho<1\)], the M/ME/1/ /\(N\) loop approaches an M/ME/1 open queue for very large \(N\). In reality, the number of customers in a system is always finite, but if \(N\) is large enough, then the probability that all (or even most) of them will be at \(S_{1}\) at any time is so small that such events can be neglected in any performance considerations. In that case, \(N\) can be replaced by infinity. The reader might ask, "What is meant by _so small_?" Recall the definition of the limit of a sequence of numbers (see any calculus book). Let \(\{a_{n}\,|\,0\leq n\}\) be such a sequence. Then if for every \(\epsilon>0\) there exists a unique number \(a\) such that for some \(N\) (possibly dependent on \(\epsilon\)) the following is true.

\[|a-a_{n}|<\epsilon\ \ \ \ \forall\ \ n>N,\]

<!-- Pages 223-223 -->

#### 4.2.2.1 Mean Queue Length

The mean queue length of a general server with Poisson arrivals can be calculated directly from (4.2.5):

\[\bar{q}:=\sum_{n=1}^{\infty}n\,r(n)=(1-\rho)\Psi\left[\sum_{n=1}^{\infty}n{\bf U }^{n}\right].\] (4.2.6a) From the properties of the geometric series, we know that \[\sum_{n=1}^{\infty}n{\bf U}^{n}=({\bf I}-{\bf U})^{-1}({\bf I}-{\bf U})^{-1}{ \bf U}={\bf K}\,{\bf K}\,{\bf U}.\] We also know that \[{\bf K}{\bf U}={\bf U}{\bf K}={\bf K}-{\bf I}\], so ( 4.2.3c ) and ( 4.2.3d ) can be used to reduce the mean queue-length formula to \[\bar{q}=(1-\rho){\bf p}{\bf K}({\bf K}-{\bf I})\boldsymbol{\epsilon}^{\prime}= (1-\rho)\Psi\left[\left({\bf I}+\frac{\lambda}{1-\rho}{\bf V}\right)\left( \frac{\lambda}{1-\rho}{\bf V}\right)\right]\] \[=\lambda\Psi\left[{\bf V}+\frac{\lambda}{1-\rho}{\bf V}^{2}\right].\] (4.2.6b) But \[\Psi\left[\lambda{\bf V}\right]=\rho\], and \[\Psi\left[{\bf V}^{2}\right]={\bf E}[X^{2}]/2\], [from ( 3.1.9 )], so we get the Pollaczek-Khinchine (P-K) formula: \[\bar{q}=\rho+\frac{\lambda^{2}}{1-\rho}\frac{{\bf E}[X^{2}]}{2}\;.\] (4.2.6c) Another form for the P-K formula, which is perhaps more enlightening, can be written by recalling the definition of variance \[[\sigma^{2}={\bf E}[X^{2}]-\bar{x}^{2}]\] and the squared coefficient of variation \[[C_{v}^{2}=\sigma^{2}\,/\,\bar{x}^{2}]\]. Then \[\bar{q}=\frac{\rho}{1-\rho}+\frac{\rho^{2}}{1-\rho}\frac{C_{v}^{2}-1}{2}\;.\] (4.2.6d) Let \[T_{s}\] be the random variable denoting the time a customer spends in the system. The mean time he spends in \[S_{1}\] or its queue is given by _Little's formula_ [Equation ( 2.1.7 )], namely, \[{\bf E}[T_{s}]=\frac{\bar{q}}{\lambda}=\frac{\bar{x}}{1-\rho}+\frac{\bar{x} \rho}{1-\rho}\frac{C_{v}^{2}-1}{2}\;.\] (4.2.6e) In this form, for a given \[\rho\] and \[\bar{x}\], it is clear that if \[C_{v}^{2}\] is greater than 1, the mean queue length and the mean time in the subsystem will be longer than that for an M/M/1 queue (for which \[C_{v}^{2}=1\] ), whereas if \[C_{v}^{2}\] is less than 1, \[\bar{q}\] and \[{\bf E}[T_{s}]\] will be shorter. See Figures 1.1.2 and 1.1.3 for well-behaved examples. \[{\bf E}[T_{s}]\] can be written in yet another form, one that can be interpreted directly. From ( 4.2.6c ) we get \[{\bf E}[T_{s}]=\bar{x}+\frac{\rho}{1-\rho}\left[\frac{{\bf E}(X^{2})}{2\bar{x}} \right]. \tag{4.2.6f}\]

<!-- Pages 224-224 -->

This can be understood in the following way. Suppose a customer arrives at an empty queue needing a time \(x\) to be served. While he is being served, \(\lambda x\) more customers arrive. It will take on average \((\lambda x)\bar{x}\) amount of time before the last of them begins service. But in that interval of time, another \(\rho x\lambda\) (we have made use of \(\rho=\lambda\bar{x}\)) will have arrived, and they will have to wait an average of \(\rho x\lambda\bar{x}\) time before the last one of them is processed. Continuing in this way and adding all the delays, we get \((1+\rho+\rho^{2}+\rho^{3}+\cdots)x=x/(1-\rho)\). We see that the ubiquitous term \(1/(1-\rho)\) is due to the propagated delay due to an initial delay. In Theorem 3.5.4 we showed that the mean residual time \(\bar{x}_{r}\) is given by the expression in square brackets above.

We also show in Theorem 4.3.1 below that the mean time remaining for the customer in service when a new customer arrives is the same \(\bar{x}_{r}\). Thus (4.2.6f) tells us that an arriving customer will take on average \(\bar{x}\) to be served, _plus_ if the server is busy when he arrives \([\rho]\) he will have to wait, on average \(\bar{x}_{r}/(1-\rho)\) before he begins service. We give one cautionary reminder that Equations (4.2.6) are true only for the steady-state M/G/1 open queue.

A point to be made concerning the P-K formula is the following. Although it is true that all M/G/1 queues have the same \(\bar{q}\) and mean system time for a given \(\lambda,\ \bar{x},\ \text{and}\ C_{v}^{2}\), that does not imply that other properties are the same. For instance, different distributions yield different queue-length probabilities, as we show in the next example.

Figure 4.2.1: M/G/1 Queue-length probabilities (on a log scale) for two pairs of \(H_{2}\), and two hyper-Erlangian functions with the same first three moments. In all cases, \(\bar{x}=1\), \(C_{v}^{2}=10\), and \(\mathbbm{E}(X^{3})=330.0\). The pair that starts higher corresponds to \(\rho=0.5\), and the other pair has \(\rho=0.9\). The M/M/1 queue (\(C_{v}^{2}=1\)) is included for comparison.

<!-- Pages 229-229 -->

\[=\mathbf{p}\left[\mathbf{I}+\frac{\lambda}{1-\rho}\mathbf{V}\right]\left[ \mathbf{I}+\lambda\mathbf{V}+\frac{\lambda^{2}}{1-\rho}\mathbf{VQV}\right]\left[ \mathbf{I}+\frac{\lambda}{1-\rho}\mathbf{V}\right]\boldsymbol{\epsilon^{\prime}}.\]

It is straightforward, if a bit tedious, to multiply out all terms and regroup them to get

\[Q^{\prime\prime}(1)=\frac{2}{1-\rho}\Psi\left[(\lambda\mathbf{V})^{2}\right]+ \frac{2}{1-\rho}\Psi\left[(\lambda\mathbf{V})^{3}\right]+2\left(\frac{\Psi \left[(\lambda\mathbf{V})^{2}\right]}{1-\rho}\right)^{2}.\]

Further manipulation yields

\[\sigma_{q}^{2}=\rho(1-\rho)+\frac{3-2\rho}{1-\rho}\Psi\left[(\lambda\mathbf{V} )^{2}\right]\]

\[+\;\frac{2}{1-\rho}\Psi\left[(\lambda\mathbf{V})^{3}\right]+\left(\frac{\Psi \left[(\lambda\mathbf{V})^{2}\right]}{1-\rho}\right)^{2}.\] (4.2.9a) We put this into another form by making use of the fact that \(\Psi\left[(\lambda\mathbf{V})^{2}\right]=\rho^{2}+\rho^{2}(C_{v}^{2}-1)/2\). Then

\[\sigma_{q}^{2}=\frac{\rho(1-2\rho^{2}+2\rho^{3})}{(1-\rho)^{2}}+\frac{\rho^{2 }(3-5\rho+4\rho^{2})}{(1-\rho)^{2}}\left(\frac{C_{v}^{2}-1}{2}\right)\]

\[+\;\frac{\rho^{4}}{(1-\rho)^{2}}\left(\frac{C_{v}^{2}-1}{2}\right)^{2}+\frac{2 }{1-\rho}\Psi\left[(\lambda\mathbf{V})^{3}\right]. \tag{4.2.9b}\]

The next two equations give expressions for two special cases. For exponential servers, \(C_{v}^{2}=1\) and \(\Psi\left[(\lambda\mathbf{V})^{n}\right]=\rho^{n}\), so

\[\sigma_{q}^{2}=\frac{\rho}{(1-\rho)^{2}}.\]

For the deterministic distribution \(C_{v}^{2}=0\), and \(\Psi\left[(\lambda\mathbf{V})^{n}\right]=\rho^{n}/n!\), so

\[\sigma_{q}^{2}=\frac{\rho(12-18\rho+10\rho^{2}-\rho^{3})}{12(1-\rho)^{2}}.\]

We have seen that (4.2.8f) is easy enough to use, although a bit tedious, to get the moments of the queue length. Use of (4.2.8e) is considerably harder and even more tedious to use. In either case, even the second moment is not particularly informative for general analysis, so we leave it for now. However, in the following section we surprisingly find a better use of (4.2.8f).

#### 4.2.3 System Time Distribution

The P-K transform formulas (4.2.8) turn out to have more significance than that implied in the preceding section. Following standard texts, we now show that \(Q(z)\) is also the Laplace transform \(B_{s}^{*}(s)\) of the system time pdf, \(b_{s}(x)\), where \(s=\lambda(1-z)\). Then we will go even further (thanks to Appie van de Liefvoort, who first recognized it [11]) and find the matrix generator \(\mathbf{(\;p_{s}\;,\;B_{s}\;)}\) of the system time distribution itself.

Recall the definition of system time (or total, or response time) from the end of Section 2.1.3, and define the steady-state distribution.

<!-- Pages 230-230 -->

**Definition 4.2.1**.: \(X_{s}:=\) _r.v for the time a customer spends at \(S_{1}\) from the moment he arrives until the moment he completes service._

\(B_{s}(x):=\) **Pr\((X_{s}\leq x)\)**_. That is, \(B_{s}(x)\) is the PDF for system time, \(b_{s}(x)\) is its derivative, and \(R_{s}(x)=1-B_{s}(x)\) is the probability that the customer will still be in the subsystem at time \(x\). _

From Theorem 4.2.4 we know that the steady-state probability of finding \(n\) customers at \(S_{1}\)\([r(n)]\), is the same as the probability that a departing customer will leave \(n\) customers behind \([d(n)]\). Now, because the arrival process to \(S_{1}\) is Poisson, the probability that \(n\) customers will arrive in the time interval \(x\) (the time spent there by our now-departing customer), is given by (3.5.16b). Therefore, the probability that he will leave \(n\) customers behind, irrespective of how long he was at \(S_{1}\), is

\[d(n)=r(n)=\int_{\mathrm{o}}^{\infty}\frac{(\lambda x)^{n}}{n!}e^{-x\lambda}b_ {s}(x)\,dx.\]

Next, insert this into the expression for \(Q(z)\) [Equations (4.2.8a) and (4.2.8e)], to get

\[Q(z)=\sum_{n=\mathrm{o}}^{\infty}z^{n}r(n)=\sum_{n=\mathrm{o}}^{\infty}\int_{ \mathrm{o}}^{\infty}\frac{(\lambda xz)^{n}}{n!}e^{-x\lambda}b_{s}(x)dx\]

\[=\int_{\mathrm{o}}^{\infty}\sum_{n=\mathrm{o}}^{\infty}\frac{(\lambda xz)^{n }}{n!}e^{-x\lambda}b_{s}(x)dx=\int_{\mathrm{o}}^{\infty}e^{\lambda xz}e^{-x \lambda}b_{s}(x)dx.\]

Finally, we identify the Laplace transform in the following theorem.

**Theorem 4.2.5**.: The Laplace transform for the steady-state system-time distribution in an M/G/1 queue is given by

\[B_{s}^{*}[\lambda(1-z)]=Q(z)=\int_{\mathrm{o}}^{\infty}e^{-\lambda(1-z)x}b_{s} (x)dx,\] (4.2.10a) and from ( 4.2.8f ), we have for M/ME/1 queues, \[B_{s}^{*}(s)=(1-\rho)\Psi\left[(\mathbf{I}-z\mathbf{U})^{-1}\right],\] (4.2.10b) where \[s=\lambda(1-z)\]. In particular (for \[z=0\] ), \[B_{s}^{*}(\lambda)=(1-\rho)\]. _

This is a most interesting result, but remember that this simple expression occurred for two special reasons. First, \(d(n)\) and \(r(n)\) are equal, and second, the Poisson arrival process and the Laplace transform are both generated by the exponential function. We cannot expect such simple results for the G/G/1 queue. In attempting an alternative derivation using the arrival probabilities (which also satisfy Theorem 4.2.4) we get a result that so far has not been shown equal to (4.2.10b). We postpone this derivation until the end of the next section, after we have discussed residual times.

<!-- Pages 233-233 -->

which peaks at \(x=0.5\). When \(\rho\) is close to 1, \(b_{s}(x)\) looks more like the interarrival distribution \(\lambda\exp(-\lambda\,x)\). The curve labeled \(\rho=0.95\) does not seem to support this. Bear in mind, however, that in general, \(b_{s}(0)=(1-\rho)b(0)\), which in this case is 0, while the exponential has a value of \(\lambda\) at the origin. Note that the curve rises rapidly from 0 and then gently decays close to the exponential curve. Another interesting feature of this figure is that all the curves peak at approximately the same place (\(x=0.5\)). It seems that for small \(x\), \(b_{s}(x)\) retains the shape of \(b(x)\) for all \(\rho\). 

It should be interesting to study \(b_{s}(x)\) further, using other pdfs. The reader must not be too quick to generalize from what is learned from the exponential and Erlangian-2 distributions.

**Exercise 4.2.3:** Using the definitions given by Equations (4.2.11) and \(s=\lambda(1-z)\), manipulate (4.2.10b) directly to get (4.2.12c). Also, show that \(b_{s}(0)=(1-\rho)b(0)\). Furthermore, prove by direct algebraic manipulation that \(\mathbb{E}[X_{s}]=\mathbb{E}[T_{s}]\); that is, show that (4.2.12a) for \(n=1\) and (4.2.6e) yield the same result. [Hint: Use (4.2.13b) and (4.2.13d) in (4.2.12a).]

#### Buffer Overflow and Customer Loss

In Section 2.1.4 we discussed the overflow probabilities for the M/M/1 queue, and the customer loss probabilities for the M/M/1/N queue. Before we gen

Figure 4.2.3: **System time density function \(b_{s}(x)\) for the M/\(E_{2}\)/1 queue**, with \(\rho=0.1\), \(0.5\), \(0.8\), \(0.9\), and \(0.95\). For small \(\rho\), \(b_{s}(x)\) tends to look like the service-time density function, \(4x\exp(-2x)\), whereas for \(\rho\) close to 1, it looks very much like the interarrival time density function \(\lambda\exp(-\lambda x)\), except near \(x=0\).

<!-- Pages 234-234 -->

eralize to the M/G/1 and M/G/1/N queues, the reader should review that section. We note that in telecommunications applications, a customer is called a _packet_ or _cell_.

In this section we set up the formulas for determining the _overflow probability_\(P_{o}(N)\) and the _customer loss_ probability \(P_{f}(N)\). As in Section 2.1.4, \(P_{o}(N)\) is the probability that an M/G/1 queue will be at least as long as \(N\) when a customer arrives, causing him to be placed in a _backup buffer_. \(P_{f}(N)\) is the probability that an M/G/1/N queue will be full when a customer arrives, thereby causing that customer to be lost, or what is mathematically equivalent, have to return to the queue at \(S_{2}\). First we find \(P_{o}(N)\).

##### Buffer Overflow Probabilities

From Theorems 4.2.3 and 4.2.4, we know that \(a(n)=r(n)=(1-\rho)\Psi\left[\mathbf{U}^{n}\right]\). Then, following Equations (2.1.8), we have

\[P_{o}(N)=\sum_{n=N}^{\infty}a(n)=(1-\rho)\sum_{n=N}^{\infty}\Psi\left[ \mathbf{U}^{n}\right]=(1-\rho)\Psi\left[\sum_{n=N}^{\infty}\mathbf{U}^{n}\right]\]

\[=(1-\rho)\Psi\left[\mathbf{U}^{N}\sum_{n=0}^{\infty}\mathbf{U}^{n}\right]=(1- \rho)\Psi\left[\mathbf{U}^{N}\left(\mathbf{I}-\mathbf{U}\right)^{-1}\right]=(1 -\rho)\Psi\left[\mathbf{U}^{N}\,\mathbf{K}\right].\]

Although it is not clear which expression is more useful, we can use (4.2.3d) to get

\[P_{o}(N)=(1-\rho)\Psi\left[\mathbf{U}^{N}\,\mathbf{K}\right]=(1-\rho)\Psi \left[\mathbf{U}^{N}\right]+\lambda\Psi\left[\mathbf{U}^{N}\mathbf{V}\right].\] (4.2.14a) This compares with ( 2.1.8d ).

Given that \(\mathbf{U}\) is a matrix, it is not easy to see just how \(P_{o}(N)\) varies with \(N\). However, from the spectral decomposition theorem [see (1.3.8b)], we know that for \(N\) large enough

\[\mathbf{U}^{N}\longrightarrow s^{N}\,\mathbf{v}_{\mathbf{s}}^{\prime}\, \mathbf{u}_{\mathbf{s}}, \tag{4.2.14b}\]

where \(s\) is the largest eigenvalue of \(\mathbf{U}\), with eigenvectors \(\mathbf{v}_{\mathbf{s}}^{\prime}\) and \(\mathbf{u}_{\mathbf{s}}\). If the service time distribution is well behaved in the sense of Definition 3.3.1, then this equation will be accurate enough for reasonable size \(N\). To get an idea of what size that might be, let \(s_{1}\) be the second largest eigenvalue. Then we would expect that \(|s_{1}/s|^{N}\ll 1\). When we insert (4.2.14b) into the expression for \(P_{o}(N)\) we get

\[P_{o}(N)=(1-\rho)\Psi\left[\mathbf{U}^{N}\,\mathbf{K}\right]\longrightarrow(1 -\rho)[(\mathbf{p}\,\mathbf{v}_{\mathbf{s}}^{\prime})(\mathbf{u}_{\mathbf{s}} \,\mathbf{K}\,\boldsymbol{\ell}^{\prime})]s^{N}, \tag{4.2.14c}\]

where the expression in square brackets is independent of \(N\).

<!-- Pages 236-236 -->

**Exercise 4.2.4:** The primary buffer of a network router has enough space for 100 packets, and \(\rho=0.9\). Assume that the packets are arriving in a Poisson stream. What fraction of the arriving packets will find the buffer full and have to be placed in a backup buffer? Do the calculations for the following service-time distributions.

* Exponential;
* Erlangian-2;
* \(H_{2}(x)\) of (3.2.8e), with \(C_{v}^{2}=10\) and \(p=0.1\);
* \(H\!E_{2}(x)\) of (3.2.16f), with the same first 3 moments as \(H_{2}(x)\);
* \(b_{+}(x)\) of Example 3.2.4.

How much primary buffer would have to be added to each to reduce the probability of overflow by a factor of 10? How much buffer would have to be added to each to get the same \(P_{o}\) as for the \(E_{2}\) distribution? And last, in each case, how much would the router have to be sped up to give the same overflow probability as for \(E_{2}\)?

What we have said so far applies to well-behaved functions. What happens if the service time distribution is subexponential (see Definition 3.3.1), and in particular, power-tailed? Such distributions, if they can be represented exactly, must have infinite dimensional representations. Therefore \(\mathbf{U}\) must have an infinite number of eigenvalues, all less than 1 in value. In this case, the value 1 is an _accumulation point_ in the sense that there must be an infinite number of points arbitrarily close to it. As a trivial example, consider the set \(S=\{s_{n}\,|\,s_{n}=1-1/n\}\). For every \(\epsilon>0\), no matter how small, there are an infinite number of points in \(S\) such that \(|1-s_{n}|<\epsilon\). It is not necessary to understand this more deeply, except to see what it does to Equation (4.2.14b). There is no \(N\) large enough for this to be a reasonable approximation. Therefore, PT distributions never show the geometric behavior that allows buffer overflow to be controlled easily.

But what about TPTs? In this case \(\mathbf{U}\) is finite-dimensional, and there exists a largest eigenvalue, but it is so close to 1, and to many other eigenvalues that (4.2.14b) may not apply for any \(N\) of physically reasonable size. Consequently we must try elsewhere for some idea as to how M/TPT/1 queues behave. We already did this in Section 4.2.2, where we saw from some numerical calculations [namely (4.2.7)] that \(r(n)\Longrightarrow c(\rho)/n^{\alpha}\). Because \(r(n)=a(n)\), we get

\[P_{o}(N)=\sum_{n=N}^{\infty}a(n)\Longrightarrow c(\rho)\sum_{n=N}^{\infty} \frac{1}{n^{\alpha}}=\operatorname{O}\left(\frac{1}{N^{\alpha-1}}\right)\]

which certainly is _not_ geometric. Recall from Section 2.1.4 that if one doubles the size of the primary buffer of an M/M/1 queue, one in effect squares the

<!-- Pages 237-237 -->

probability of overflow. So, if \(P_{o}(N)\) is small, then \(P_{o}(2N)\) will be significantly smaller. But here,

\[\frac{P_{o}(N)}{P_{o}(2N)}\Longrightarrow\frac{(2N)^{\alpha-1}}{N^{\alpha-1}}=2 ^{\alpha-1}.\]

So, if \(\alpha=1.4\) (a typical value found in telecommunications systems) then we get only a \(32\%\) reduction in overflow probability (\(2^{.4}=1.3195\)). This is not a very effective way to improve service. Note that even if \(\alpha>2\) (the distribution has a finite variance), \(P_{o}(N)\) is not reduced by nearly as much as for well-behaved distributions.

The above statements carry over to TPTs if the range of the distribution is large enough (see the discussion in Section 3.3.6.1). The reader should test this out in the following exercise.

**Exercise 4.2.5:** Redo all of Exercise 4.2.4 using the TPT distributions taken from Example 3.3.4. Let \(\theta=0.5,\ \alpha=1.4\), and thus \(\gamma=(1/\theta)^{1/\alpha}\). Perform the calculations for \(T=10,\ 20,\ 30,\ \text{and}\ 40\). You should be able to show that the overflow probabilities do not change appreciably with \(T\) when \(T\) is large enough, even though \(C_{T}^{2}\) grows unboundedly with increasing \(T\). Repeat the calculations for \(\alpha=2.4\). Here \(C_{\infty}^{2}\) is finite, but the buffer problem remains. In all cases calculate the range of the distributions \([x_{r}(T)=\gamma^{T}/\mu(T)]\).

**Customer Loss Probabilities**

Calculating the loss probabilities \(P_{f}(N)\) requires finding the steady-state arrival probabilities for the M/G/1/N queue. Definition 2.1.4 for \(r_{f}(n;\,N)\) and \(a_{f}(n;\,N)\) is directly applicable here, and we can even extend them to the vector probabilities, \(\boldsymbol{\pi}_{\mathbf{f}}(n;\,N)\) and \(\mathbf{a}_{\mathbf{f}}(n;\,N)\).

**Definition 4.2.2**: \([\boldsymbol{\pi}_{\mathbf{f}}(n;\,N)]_{i}:=\) _probability that a random observer of an \(\mathrm{M/G/1/}N\) queue will see \(n\) customers at \(S_{1}\), with the active customer being at phase \(i\)._ Clearly, \(r_{f}(n;\,N)=\boldsymbol{\pi}_{\mathbf{f}}(n;\,N)\boldsymbol{\epsilon}^{\prime}\).

\([\mathbf{a}_{\mathbf{f}}(n;\,N)]_{i}:=\) _probability that a customer, arriving at an \(\mathrm{M/G/1/}N\) queue will find \(n\) customers already at \(S_{1}\), with the active customer being at phase \(i\)._ Clearly, \(a_{f}(n;\,N)=\mathbf{a}_{\mathbf{f}}(n;\,N)\boldsymbol{\epsilon}^{\prime}\).

If the arriving customer sees \(N\) customers already at \(S_{1}\) (i.e., the buffer is full), then he is lost (or he returns to \(S_{2}\)). Therefore,

\[P_{f}(N)=a_{f}(N;\,N).\]

Recall that the subscript, '\(f\)' stands for _finite buffer_.

Fortunately for us, for Poisson arrivals, an arriving customer sees the same thing as a random observer. In fact, by the same argument given at the beginning of Section 2.1.4, the M/G/1/N and M/G/1//N queues satisfy

\[\mathbf{a}_{\mathbf{f}}(n;\,N)=\boldsymbol{\pi}_{\mathbf{f}}(n;\,N)= \boldsymbol{\pi}(n;\,N). \tag{4.2.15}\]

<!-- Pages 238-238 -->

Only \(\mathbf{a}(n;N)\) is different by a normalization factor because \(\mathbf{a}(N;\,N)=\mathbf{o}\) (an arriving customer cannot see \(N\) customers at the queue because he is one of them).

From Theorem 4.1.2, we have

\[P_{f}(N)=r(N;\,N)=\lambda r(0;\,N)\Psi\left[\mathbf{U}^{N-1}\mathbf{V}\right]=r (0;\,N)\Psi\left[\mathbf{U}^{N}\left(\lambda\mathbf{A}\,\mathbf{V}\right) \right].\]

But \(\lambda\mathbf{AV}\boldsymbol{\epsilon^{\prime}}=(1-\rho)\mathbf{K} \boldsymbol{\epsilon^{\prime}},\) from (4.2.3a), so

\[P_{f}(N)=(1-\rho)r(0;\,N)\Psi\left[\mathbf{U}^{N}\,\mathbf{K}\right]. \tag{4.2.16}\]

Interestingly enough, this only differs from \(P_{o}(N)\) by the factor \(r(0;\,N),\) which for well-behaved distributions is approximately \((1-\rho)\) when \(N\) is large. That is,

\[\frac{P_{f}(N)}{P_{o}(N)}=r(0;\,N)\longrightarrow(1-\rho).\]

Everything we said about the behavior of \(P_{o}(N)\) for large \(N\) carries over to \(P_{f}(N),\) reduced by the factor \(r(0;\,N).\) Thus \(P_{f}(N)<P_{o}(N)\) for all \(N\) and all \(\rho<1.\) For \(\rho\geq 1\)\(P_{o}(N)\) is not defined (no steady state), but \(P_{f}(N)\) still is. The following exercises show the differences.

**Exercise 4.2.6:** Redo all of Exercise 4.2.4, but for \(P_{f}(N).\) Compare the two sets of results.

TPT service time distributions also cause problems for control of customer loss, as can be seen by doing the following.

**Exercise 4.2.7:** Redo all of Exercise 4.2.5, but for \(P_{f}(N).\) Compare the two sets of results.

Often a system must be designed so that no more than a fraction \(p_{\ell}\) of packets should be lost. Then the question becomes "How big must the buffer be?" In the section surrounding (2.1.10b) we showed that for any single-server queue \(\rho\) could be greater than \(1\) and still have a stable queue if \(p_{\ell}>0,\) but only up to \(\rho<\rho_{m}=1/(1-p_{\ell}).\) In this case, \(\rho\) and \(p_{\ell}\) are assumed given, and one evaluates (4.2.16) for multiple values of \(N\) until one finds that largest \(N\) for which \(P_{f}(N)\leq p_{\ell}.\) This issue is explored in the following exercise.

**Exercise 4.2.8:** Consider the question presented in the previous paragraph. Suppose some application can afford a \(2\%\) loss (\(p_{\ell}=.02).\) Find the buffer size needed to satisfy this constraint for the five service time distributions given in Exercise 4.2.4. Do this for enough values of \(0<\rho<\rho_{m}\) to draw a smooth curve. Note that all the curves blow up at \(\rho=\rho_{m}.\) Produce another graph where the \(Y\)-axis is \((\rho_{m}-\rho)*N.\) Here, the curves should be finite at \(\rho=\rho_{m}.\)

<!-- Pages 239-239 -->

**Exercise 4.2.9:** Redo Exercise 4.2.8, but now for the service time distributions given in Exercise 4.2.5. What is the behavior of \((\rho_{m}-\rho)*N\) as \(\rho\) approaches \(\rho_{m}\)? Is it still finite?

#### Distribution of Interdeparture Times

We have developed enough results to be able to look once again at departures from \(S_{1}\). As in Section 2.1.6, we place our observer just outside the exit of \(S_{1}\) and have her measure the time between departures. The problem is more complicated only because \(S_{1}\) now represents some general server. It is useful, then, to review Section 2.1.5 before going on.

We ask the following question. Given that a customer, call him \(C_{1}\), has just left \(S_{1}\), how long will it be before the next one, call him \(C_{2}\), leaves? We can assume that our observer has been sitting for a long time, so the system is in its steady state. Also, she has no idea how many customers are at \(S_{1}\), but if the system is closed, she knows what \(N\) is.

_Definition 4.2.3_

\(X_{d}(N):=r.v.\) _denoting the time between departures from \(S_{1}\) of a steady-state \(M/ME/1//N\) queue._

\(X_{d}:=X_{d}(\infty)\)_._

\(B_{d}(x;\,N):=\operatorname{\textbf{Pr}}(X_{d}(N)\leq x)=\) _PDF for the interdeparture times of a steady-state \(M/ME/1//N\) loop._ The process begins immediately after customer \(C_{i-1}\) leaves \(S_{1}\), and ends as soon as customer \(C_{i}\) leaves. Customer \(C_{i}\) may not yet have arrived at \(S_{1}\) when \(C_{i-1}\) left. (In that case, \(C_{i-1}\) left behind an empty queue.) \(b_{d}(x;\,N)\) is the derivative of \(B_{d}(x;\,N)\), and \(R_{d}(x;N)=1-B_{d}(x;N)\) is the probability that the second customer is still in the subsystem or has not yet arrived at time \(x\). The subscript \(d\) reminds us that this is a _de_parture process. 

We are assuming that \(i\) is large enough so that the interdeparture times are identically distributed. However, we postpone considering the correlation of successive departures until Section 8.3.5. Only two things are possible. Either \(S_{1}\) is busy and \(C_{i}\) must be served from the beginning, or \(S_{1}\) is idle and our patient observer must wait for \(C_{i}\) to arrive before being completely served. The probability that the latter will happen is \(d(0;N)\) [Equation (4.1.13c)], while the vector probability for the former to happen is \([1-d(0;\,N)]\mathbf{p}\). Following this description, the pdf for the process can be found by taking the convolution of the pdf's of \(S_{1}\) and \(S_{2}\), but instead, we will give a matrix representation of the process that is more useful and more picturesque.

Look at Figure 4.2.4. Consider \(S_{1}\) and \(S_{2}\) together as one subsystem. \(S_{2}\) is only an exponential server with service rate \(\lambda\), therefore we can assume that service begins there at the moment of the previous departure with probability \(d(0;N)\). The dimension of this composite subsystem is \(m+1\), corresponding

<!-- Pages 241-241 -->

One can easily prove by direct matrix multiplication that its inverse is

\[\mathbf{V_{d}}=\mathbf{B_{d}}^{-1}=\left[\begin{array}{cc}1/\lambda&\mathbf{pV} \\ \mathbf{o^{\prime}}&\mathbf{V}\end{array}\right]. \tag{4.2.17c}\]

Now that we have a matrix representation of the departure time distribution, generated by \(\mathbf{\{p_{d}\,,\,B_{d}\}}\) (or \(\mathbf{\{p_{d}\,,\,V_{d}\}}\)), we can find its moments, and even the pdf itself. First, let us find the mean interdeparture time when there are \(N\) customers in the loop. From Theorem 3.1.1, Equation (3.1.9),

\[\mathbf{E}[X_{d}(N)]:=\int_{\mathrm{o}}^{\infty}x\,b_{d}(x;N)\,dx=\mathbf{p_{d }}(N)\,[\mathbf{V_{d}}]\boldsymbol{\epsilon^{\prime}_{d}}\]

\[=[d(0;N),\,\{1-d(0;N)\}\mathbf{p}]\left[\begin{array}{cc}1/\lambda&\mathbf{ pV}\\ \mathbf{o^{\prime}}&\mathbf{V}\end{array}\right]\boldsymbol{\epsilon^{\prime}_ {d}}\]

\[=\left[\frac{d(0;N)}{\lambda},\,d(0;N)\mathbf{pV}+\{1-d(0;N)\}\mathbf{pV} \right]\boldsymbol{\epsilon^{\prime}_{d}}=\left[\frac{d(0;N)}{\lambda},\, \mathbf{pV}\right]\boldsymbol{\epsilon^{\prime}_{d}}.\]

Given that \(\rho=\lambda\bar{x}\), the mean time reduces to the following simple expression (compare with (2.1.19b).

\[\mathbf{E}[X_{d}(N)]=\frac{1}{\lambda}[d(0;N)+\rho]. \tag{4.2.18a}\]

\(d(0;N)\) can be calculated from (4.1.13c), at the same time that the other properties of the steady-state M/G/1 // \(N\) queue are computed, which as usual, we leave as an exercise. An interesting aspect of this representation is that the departure time's dependence on \(N\) appears only in \(\mathbf{p_{d}}(N)\).

Before finding the equation for the pdf, we find the mean interdeparture time for the open system. We already know from (4.2.5b) and Theorem 4.2.4 that \(\lim_{N\to\infty}d(0;N)=1-\rho\) as long as \(\rho<1\), so

\[\mathbf{E}[X_{d}]:=\lim_{N\to\infty}\mathbf{E}[X_{d}(N)]=\frac{1}{\lambda}(1- \rho+\rho)=\frac{1}{\lambda}\quad\text{for}\;\;\rho<1. \tag{4.2.18b}\]

Actually, (4.2.18a) is valid for all \(\rho\). If \(\rho\) is greater than 1, then \(d(0;N)\) goes to 0 as \(N\) grows larger, so in this case,

\[\mathbf{E}[X_{d}]:=\lim_{N\to\infty}\mathbf{E}[X_{d}(N)]=\frac{1}{\lambda}(0+ \rho)=\bar{x}\quad\text{for}\;\;\rho>1. \tag{4.2.18c}\]

Surprised? Of course not. After all, \(\mathbf{E}[X_{d}]\) is the reciprocal of the mean departure rate, and as long as \(\rho\) is less than 1, what goes in must come out, so the arrival rate equals the departure rate (in the steady state, of course). We already saw this for the M/M/1 queue in (2.1.20a). If \(\rho>1\) then the departure rate is limited by the service rate of \(S_{1}\). Note that the departure and arrival rates are equal to each other for all \(N\), but they only equal \(\lambda\) for the open queue. In any closed network, even the busiest server will be idle some of the time, so the throughput will be less than maximum in proportion to the time it is not busy.

<!-- Pages 243-243 -->

departure process is some sort of average of the squared coefficients of variation for the interarrival distribution (\(C_{v}^{2}=1\) for exponential distributions) and the service time distribution \(C_{v}^{2}\).

We are almost ready to find the density function itself. Recall from Theorem 3.1.1 that because \(\boldsymbol{\left\langle\mathbf{p_{d}}(N)\,,\,\mathbf{B_{d}}\right\rangle}\) generates \(b_{d}(x;\,N)\), they are related by (3.1.7d), or

\[b_{d}(x;N)=\mathbf{p_{d}}(N)[\mathbf{B_{d}}\exp(-x\mathbf{B_{d}})]\boldsymbol{ \ell_{d}}. \tag{4.2.20}\]

We can make use of this formula by either finding a similarity transformation matrix that diagonalizes \(\mathbf{B_{d}}\), or by replacing \(\exp(\,\cdot\,)\) with its Taylor expansion and substituting a general expression for \(\mathbf{B_{d}}^{n}\) (assuming that we can find one). We do the latter here. First, from (4.2.17b) let us look at the square of \(\mathbf{B_{d}}\):

\[\mathbf{B_{d}}^{2}=\left[\begin{array}{cc}\lambda^{2}&-\lambda^{2}\mathbf{ p}\left(\mathbf{I}+\frac{1}{\lambda}\mathbf{B}\right)\\ \mathbf{o^{\prime}}&\mathbf{B}^{2}\end{array}\right].\]

If the reader cannot guess at a general expression for the \(n\)-th power of \(\mathbf{B_{d}}\), then calculating and examining \(\mathbf{B_{d}}^{3}\) should give sufficient hint. We leave that step out and write the expression directly. Before we do that, we are beginning to see that the matrix expressions can become rather large and cumbersome, so for convenience, we define the matrix \(\mathbf{X}\) for this section only.

\[\mathbf{X}:=\left(\mathbf{I}-\frac{1}{\lambda}\mathbf{B}\right)^{-1}.\]

Then the \(n\)-th power of \(\mathbf{B_{d}}\) is

\[\mathbf{B_{d}}^{n}=\left[\begin{array}{cc}\lambda^{n}&-\lambda^{n}\mathbf{p} \sum_{k=0}^{n-1}\left(\frac{1}{\lambda}\mathbf{B}\right)^{k}\\ \mathbf{o^{\prime}}&\mathbf{B}^{n}\end{array}\right]\]

\[=\left[\begin{array}{cc}\lambda^{n}&-\lambda^{n}\mathbf{p}\mathbf{X}\left( \mathbf{I}-\left(\frac{1}{\lambda}\mathbf{B}\right)^{n}\right)\\ \mathbf{o^{\prime}}&\mathbf{B}^{n}\end{array}\right].\] (4.2.21a) The proof is by induction and is left as an exercise.

**Exercise 4.2.10:** Prove by induction that (4.2.21a) is true for all \(n>0\). That is, multiply either of the two matrix expressions by \(\mathbf{B_{d}}\) and show that the resulting expression is of the same form, with the index \(n\) increased by \(1\).

The process of summing all the terms of the form \((1/n!)(-x\mathbf{B_{d}})^{n}\) is not difficult, because it can be done element by element, or block by block. First, define the \((m+1)\times(m+1)\) matrix, \(\mathbf{R_{d}}(x):=\exp(-x\mathbf{B_{d}})\) [recall the reliability matrix function of Equations (3.1.6)], then

\[[\mathbf{R_{d}}(x)]_{ij}=[\exp(-x\mathbf{B_{d}})]_{ij}=\sum_{n=0}^{\infty} \frac{(-x)^{n}}{n!}\left[(\mathbf{B_{d}})^{n}\right]_{ij}.\]

<!-- Pages 245-245 -->

Therefore, recalling that \(d(0;N)\) is given by Theorem 4.1.4,

\[b_{d}(x;N)=b(x)+d(0;N)\]

\[\times\left(\Psi\left[(\mathbf{I}-\lambda\mathbf{V})^{-1}\right]\lambda e^{-x \lambda}-\Psi\left[(\mathbf{I}-\lambda\mathbf{V})^{-1}\mathbf{B}\exp(-x \mathbf{B})\right]\right).\] (4.2.22a) In particular, for \[x=0\], \[b_{d}(0;N)=[1-d(0;N)]b(0). \tag{4.2.22b}\]

This formula is as simple as it can get in terms of its dependence on the customer population, so there is no real gain in writing down the limit as \(N\) goes to infinity. We point out, though, that [as with the mean interdeparture time (4.2.18)] when \(\rho\) is less than \(1\), \(d(0;\ N)\) is replaced by \(1-\rho\), but that does not simplify (4.2.22) any, except when \(x=0\), for then \(b_{d}(0)=\rho b(0)\). If \(\rho\) is greater than \(1\), then \(d(0;N)\) goes to \(0\) for large \(N\), so \(b_{d}(x)=b(x)\), as expected. Also, note that because \(b(x)\) and \(b_{d}(x)\) are both density functions, the integral from \(0\) to infinity of each function is \(1\). Therefore, the integral of the term multiplying \(d(0;N)\) must be \(0\). In other words, the two terms inside the large parentheses contribute opposing changes to \(b(x)\) that exactly cancel out upon integration. This can be shown directly by first recognizing that

\[\int_{\mathrm{o}}^{\infty}\mathbf{B}\exp(-x\mathbf{B})dx=\mathbf{I}.\]

There is one other limit that is interesting. Under very light loads (i.e., when \(\rho\) is very small), \(\lambda\mathbf{V}\) is also very small. In this case, \((\mathbf{I}-\lambda\mathbf{V})\) drops out, \(d(0;N)\) can be replaced by \(1\), and we end up with the reasonable result that \(b_{d}(x;N)\rightarrow\lambda e^{-x\lambda}\). We see, then, that as \(\rho\) increases from \(0\) to \(1\), the interdeparture distribution gradually changes from the arrival distribution to the service distribution. "Exponential in \(\rightarrow\) exponential out (EIEO)" is valid only under light loads.

**Example 4.2.3:** We have used \(\boldsymbol{\{\mathrm{p}_{4}\,,\,\mathrm{B}_{4}\}}\) from (4.2.17) to generate \(b_{d}(x)\) for the open \(\mathrm{M}/E_{2}/1\) queue (\(N=\infty\)) by directly evaluating (3.1.7d) for many values of \(x\), using the algorithm described in Section 3.1.4. Just as with Figure 4.2.3, we set \(\bar{x}=1\) and selected various values for \(\rho\). The results are shown in Figure 4.2.5. This figure looks similar to Figure 4.2.3; however, note that their dependence on \(\rho\) is completely inverted relative to each other, although they are extremely close for \(\rho=0.5\). When \(\rho\) is very close to \(1\), \(b_{d}(x)\) is very peaked, just as is \(E_{2}(x)\). In fact the curve labeled \(\rho=0.95\) is virtually indistinguishable from the same Erlangian-2 distribution, given above, which peaks at \(x=0.5\). When \(\rho\) is very small, \(b_{d}(x)\) will look more like the interarrival distribution \(\lambda\exp(-\lambda x)\). The curve labeled \(\rho=0.1\) does not seem to support this. Bear in mind, analogous to the system-time distribution, that in general, \(b_{d}(0)=\rho b(0)\), which in this case is \(0\), whereas the exponential has a value of \(\lambda\) at the origin. Note that the curve rises rapidly from \(0\) and then gently decays close to the exponential curve. Another interesting feature that this figure shares with Figure 4.2.3 is that all the curves peak at approximately

<!-- Pages 246-246 -->

the same place (\(x=.5\)). Again, it seems that for small \(x\), \(b_{d}(x)\) retains the shape of \(b(x)\) for all \(\rho\). 

It would be interesting to find out if this "peaking" property is typical of interdeparture distributions for all M/G/1 queues.

We have one question to ask before moving on. Why should EIEO be true for an open system _even_ if \(S_{1}\) is exponential, as was proven in Chapter 2, Equation (2.1.20b) (it was _not_ true for the closed system)? After all, our representation of the departure process has dimensions equal to the sum of the dimensions of \(S_{1}\) and \(S_{2}\), which in the case of the M/M/1 queue should be 2.

Of course, we would expect (4.2.22) to duplicate (2.1.20b) for the open system, which it does if \(S_{1}\) is 1-dimensional. In that case, \(\mathbf{B}\) goes to \(\mu\), \(\lambda\mathbf{V}\) goes to \(\rho\), and \(b(x)\) becomes \(\mu e^{-x\mu}\). Put this all together with the fact that \(d(0;N)\) goes to \(1-\rho\) and the negative term in the large brackets of (4.2.22b) exactly cancels \(b(x)\), leaving \(b_{d}(x)=\lambda e^{-x\lambda}\). But this argument does not give us much insight. Another view is to look at the matrix representation of \(b_{d}(x)\). Note that the initial vector for the open system \([1-\rho,\rho]\) is a left eigenvector of \(\mathbf{B_{d}}\), with eigenvalue \(\lambda\). That is,

\[[1-\rho,\rho]\left[\begin{array}{cc}\lambda&-\lambda\\ 0&\mu\end{array}\right]=\lambda[1-\rho,\rho].\]

We discussed minimal representations in Section 3.4.1, where we showed by

Figure 4.2.5: Interdeparture time density function, \(b_{d}(x)\) for the M/\(E_{2}\)/1 queue, with \(\rho=0.1\), 0.5, 0.8, 0.9, and 0.95. For small \(\rho\), except near \(x=0\), \(b_{d}(x)\) tends to look like the interarrival distribution \(\lambda\exp(-\lambda x)\), but for \(\rho\) close to 1, it looks very much like the service-time density function, \(4x\)\(\exp(-2x)\).

<!-- Pages 247-247 -->

example that the dimension of the invariant subspaces of \(\mathbf{p}\) and \(\boldsymbol{\epsilon^{\prime}}\) determine the dimension of the minimal representation. In this case, given that the equation above is true, from Theorem 3.1.1, we have for the M/M/1 queue,

\[b_{d}(x)=\mathbf{p_{d}}\mathbf{B_{d}}\exp(-x\mathbf{B_{d}})\boldsymbol{ \epsilon^{\prime}_{d}}=\lambda\mathbf{p_{d}}\mathbf{I_{d}}\exp(-x\lambda \mathbf{I_{d}})\boldsymbol{\epsilon^{\prime}_{d}}=\lambda e^{-x\lambda} \mathbf{p_{d}}\boldsymbol{\epsilon^{\prime}_{d}}=\lambda e^{-x\lambda}.\]

Whenever either \(\boldsymbol{\epsilon^{\prime}}\) or the entrance vector is an eigenvector of the generating matrix, \(\mathbf{B}\) or \(\mathbf{V}\), the resulting pdf is exponential [15]. In Section 8.3.5.4 we prove that EIEO is, in fact, only true as the M/M/1 queue reaches its steady state.

### M/G/1 Queue Dependence On \(n\)

In Chapter 3 we discussed the idea of residual times, where what can be predicted about the future is contained in what is known about the system now, and is summarized by the residual vector [Equations (3.5.10) to (3.5.13)]. In particular, if nothing is known about the internal state of \(S_{1}\) (except that it is busy), the mean time until a customer leaves is given by (3.5.12b), with pdf given by (3.5.13). We can extend this to the M/ME/1/\(\left/N\right.\) loop and the M/ME/1 queue in the following way.

#### 4.3.1 Residual Time as Seen by a Random Observer

Suppose that a random observer comes to view \(S_{1}\) without knowing anything about its past history except that \(n\) customers are there at present. The probability that she will find \(n\) customers there is \(r(n;N)\), but we can actually give an expression for the internal state of \(S_{1}\) at the moment she arrives.

_Definition 4.3.1_

\(\boldsymbol{\pi_{\mathbf{r}}}(n;N):=\) _residual probability vector of the state \(S_{1}\) is in when a random observer first arrives, given that there are n customers in a steady-state M/ME/1//\(N\) queue. \(\boldsymbol{\pi_{\mathbf{r}}}(n;N)\,\boldsymbol{\epsilon^{\prime}}=1\). \([\boldsymbol{\pi_{\mathbf{r}}}(n;N)]_{i}\) is the probability that the customer in service in \(S_{1}\) will be at phase \(i\) when the observer comes. There is no internal state if \(n=0\), but for convenience we let \(\boldsymbol{\pi_{\mathbf{r}}}(0;N)=\mathbf{p}\). _

From (4.1.6a) and (4.1.6b), we have

\[\boldsymbol{\pi_{\mathbf{r}}}(n;N)=\frac{\boldsymbol{\pi}(n;N)}{r(n;N)}=\frac {\mathbf{p}\mathbf{U}^{n}}{\Psi\left[\mathbf{U}^{n}\right]}\quad\text{for}\ \ 0\leq n<N\] (4.3.1a) and \[\boldsymbol{\pi_{\mathbf{r}}}(N;N)=\frac{\mathbf{p}\mathbf{U}^{N-1}\mathbf{V}}{ \Psi\left[\mathbf{U}^{N-1}\mathbf{V}\right]}\,. \tag{4.3.1b}\]

These vectors serve as the initial vectors for the process of the active customer completing service. Thus

\[\boldsymbol{\left\langle\,\boldsymbol{\pi_{\mathbf{r}}}(n;N)\,,\,\mathbf{B} \,\right\rangle}\]

<!-- Pages 248-248 -->

is the generator of the distribution function of the r.v. \(X_{r}(n;\,N)\), the time remaining for the one in service, given that the random observer has found \(n\) customers at \(S_{1}\). For instance, the density function for this process is given by the expression

\[b_{r}(x;n;N):=\boldsymbol{\pi_{\mathrm{r}}}(n;N)\mathbf{B}\exp(-x\mathbf{B}) \boldsymbol{\epsilon^{\prime}}=\frac{\Psi\left[\mathbf{U}^{n}\mathbf{B}\exp(- x\mathbf{B})\right]}{\Psi\left[\mathbf{U}^{n}\right]}\] (4.3.2a) for \[0<n<N\], and \[b_{r}(x;N;N):=\frac{\Psi\left[\mathbf{U}^{N-1}\mathbf{V}\mathbf{B}\exp(-x \mathbf{B})\right]}{\Psi\left[\mathbf{U}^{N-1}\mathbf{V}\right]}=\frac{\Psi \left[\mathbf{U}^{N-1}\exp(-x\mathbf{B})\right]}{\Psi\left[\mathbf{U}^{N-1} \mathbf{V}\right]}\;. \tag{4.3.2b}\]

These formulas are not as hard to compute as they look. First, the vectors \(\mathbf{p}\mathbf{U}^{n}\) can be calculated recursively, and in any case are needed to compute the steady-state probabilities. Second, \(\exp(-x\mathbf{B})\boldsymbol{\epsilon^{\prime}}\) can be calculated recursively by the algorithm given in Section 3.1.4.

The mean time remaining for the one in service is

\[\mathbf{E}[X_{r}(n;\,N)]=\frac{\Psi\left[\mathbf{U}^{n}\mathbf{V}\right]}{\Psi \left[\mathbf{U}^{n}\right]}\quad\text{for}\;\;0<n<N \tag{4.3.3a}\] \[\mathbf{E}[X_{r}(N;\,N)]=\frac{\Psi\left[\mathbf{U}^{N-1}\mathbf{V}^{2}\right] }{\Psi\left[\mathbf{U}^{N-1}\mathbf{V}\right]}\;. \tag{4.3.3b}\]

In particular, \(\mathbf{E}[X_{r}(0;\,N)]=\Psi\left[\mathbf{V}\right]=\bar{x}\).

The mean residual time [from (3.5.12b)] is of interest because it can differ enormously from the mean service time. It is not hard to find examples where the queue-length dependent residual times differ as much from \(\mathbf{E}[X_{r}]\) and each other as \(\mathbf{E}[X_{r}]\) differs from \(\bar{x}\).

**Example 4.3.1:** As can be seen in Figure 4.3.1, for even the simplest nonexponential distribution (the Erlangian-2), \(\mathbf{E}[X_{r}(n;N)]\) can vary greatly. The value at \(n=0\) corresponds to the mean service time, which we have set equal to \(1\). The average value of the queue-length times, weighted over the \(r(n;N)\)s, we show below, turns out to be equal to the mean residual time, \(\mathbf{E}[X_{r}]\). Therefore, the weighted average is independent of \(\rho\) and \(N\). The big drop in all curves between \(19\) and \(20\) is real. Note that all of these numbers would be equal to each other and to \(\bar{x}\) if this were an M/M/1 queue. \(\blacktriangle\)

The procedure we have applied to \(\bar{b_{r}}(x;n;N)\) and \(\mathbf{E}[X_{r}(n;N)]\) can also be applied to the Laplace transform. Thus,

\[B_{r}^{*}(s;\,n;\,N):=\boldsymbol{\pi_{\mathrm{r}}}(n;N)[\mathbf{I}+s\mathbf{ V}]^{-1}\boldsymbol{\epsilon^{\prime}}. \tag{4.3.3c}\]

This function actually has an interesting physical meaning. Recall that \(B^{*}(\lambda)\) is the probability that a customer who has just started service will finish before the next customer comes, [see discussion after Theorem 3.1.1, and (2.1.1b)], \(B_{r}^{*}(\lambda;n;N)\) must be the probability that the customer in service at \(S_{1}\) when a random observer starts looking (and sees \(n\) customers there), will finish

<!-- Pages 251-251 -->

independent of \(N\) and is equal to \(\boldsymbol{\pi_{\pi}F\epsilon^{\prime}}\), where \(\boldsymbol{\pi_{r}}\) is given by (3.5.10b). That is, the "expected value of" \(\mathbf{F}\) (call it \(\bar{F}_{r}\)), is

\[\bar{F}_{r}:=\frac{\sum_{n=1}^{N}\bar{F}_{r}(n;N)\,r(n;N)}{1-r(0;N)}=\frac{ \mathbf{pVF\epsilon^{\prime}}}{\mathbf{pV\epsilon^{\prime}}}=\frac{\Psi\left[ \mathbf{V}\mathbf{F}\right]}{\Psi\left[\mathbf{V}\right]}=\boldsymbol{\pi_{r }F\epsilon^{\prime}}. \tag{4.3.5a}\]

The result is independent of \(N\), thus it is also true for open systems (i.e., when \(N\to\infty\)). 

**Proof:** First note that \(1-r(0;N)=\Psi\left[\mathbf{K}(N)-\mathbf{I}\right]/\Psi\left[\mathbf{K}(N)\right]\), and for \(n<N\) that

\[r(n;N)\bar{F}_{r}(n;N)=\frac{\Psi\left[\mathbf{U}^{n}\mathbf{F}\right]}{\Psi \left[\mathbf{K}(N)\right]},\]

with a similar expression for \(n=N\). Then

\[\sum_{n=1}^{N}\bar{F}_{r}(n;N)r(n;N)=\frac{\Psi\left[(\mathbf{K}(N)-\mathbf{I })\mathbf{F}\right]}{\Psi\left[\mathbf{K}(N)-\mathbf{I}\right]}.\]

The theorem follows directly from (4.3.4c). 

We next state as a corollary that the "average" residual time and density are the same as the mean residual time and density discussed in Chapter 3.

**Corollary 4.3.1:** The mean time (appropriately averaged over the steady-state queue-length probabilities) a randomly arriving observer of an M/G/1 queue (either open or closed) will have to wait for the customer who is presently in service at \(S_{1}\) to complete service is given by \(\bar{V}_{r}\) and is equal to \(\bar{x}_{r}\), the mean residual time of \(S_{1}\). That is, if we let \(\mathbf{F}=\mathbf{V}\) in (4.3.5a), we get:

\[\bar{x}_{r}=\frac{\Psi[\mathbf{V}\mathbf{V}]}{\Psi[\mathbf{V}]}=\frac{ \mathbf{E}(X^{2})}{2\bar{x}}.\]

Furthermore, the time remaining is distributed according to (3.5.13). Finally, the mean residual vector [Equation (3.5.10b)] is the same for all \(N\) and satisfies

\[\boldsymbol{\pi_{r}}=\frac{\sum_{n=1}^{N}r(n;N)\boldsymbol{\pi_{r}}(n;N)}{1-r( 0;N)}=\frac{1}{\Psi[\mathbf{V}]}\mathbf{pV}. \tag{4.3.5b}\]

\(\blacksquare\)

**Proof:** Let \(\mathbf{F}=\mathbf{V}\) in (4.3.5a) to get the mean time, and let \(\mathbf{F}=\mathbf{B}\exp(-x\mathbf{B})\) for the distribution; then compare with (3.5.10b) and (3.5.13). **QED**

This applies to the Laplace transform as well. If our observer knows nothing about \(S_{1}\) except that someone is in service, then the probability, \(C_{r}\), that

<!-- Pages 253-253 -->

Note that this theorem is not necessarilly true for queues that are not of M/G/1-type.

Be reminded that although a customer has the same probability of finding \(n\) customers in \(S_{1}\) when he arrives as when he leaves, the internal state will be different. The internal state seen by the arriving customer is proportional to \(\boldsymbol{\pi}(n;N)\), whereas that for the departing customer is always \(\mathbf{p}\) (the next customer in the queue enters \(S_{1}\)).

Now that we know that our random observer sees the same thing as the customers in the system, it pays to elaborate some on the equations of the preceding section. On the one hand, the outsider cannot make any use of the system's facilities without changing the steady-state solution. On the other hand, the customers cannot refuse to make use of the facilities without destroying the steady state. Therefore, even though both may have "inside information" as to expected waiting times, they cannot act upon it without changing the system's subsequent behavior. In any case it is good to know what one is in for.

When a customer arrives at \(S_{1}\) with \(n\) customers already there, he must wait for the one in service to complete, and for \(n-1\) additional customers to start and finish. The distribution of time that he must wait is identical to that for the \(n\)-th renewal epoch \(Y_{n}\) of a generalized renewal process, as discussed in Section 3.5. All \(n\) customers have pdfs generated by the same matrix, \(\mathbf{B}\), but the first one has a starting vector given by (4.3.1a) as opposed to \(\mathbf{p}\) for the other customers. Thus the mean waiting time for the new customer conditioned on the number already in the queue (call it \(\operatorname{\mathbb{E}}[X_{w}(n)]\)) is [see (4.3.3a)]

\[\operatorname{\mathbb{E}}[X_{w}(n)]=\operatorname{\mathbb{E}}[X_{r}(n)]+(n-1) \bar{x},\ \ \ \ 0<n<N.\] (4.3.6a) The total time he will spend in the system averages to \[\operatorname{\mathbb{E}}[X_{s}(n)]=\operatorname{\mathbb{E}}[X_{w}(n)]+\bar{ x}=\operatorname{\mathbb{E}}[X_{r}(n)]+n\bar{x}.\] (4.3.6b) Continuing in this way, we see that the variance of his waiting time can be written as \[\sigma_{w}^{2}(n)=\frac{\Psi\left[\mathbf{U}^{n}(2\mathbf{V}^{2}-\mathbf{VQ} \mathbf{U}^{n}\mathbf{V})\right]}{\Psi\left[\mathbf{U}^{n}\right]}+(n-1) \sigma^{2}\] (4.3.6c) where \[\sigma^{2}=\Psi\left[(2\mathbf{V}^{2}-\mathbf{VQ}\mathbf{V})\right]\] is the variance of the service time distribution. To get the variance of his total system time (again, conditioned on \[n\] ), simply add one more \[\sigma^{2}\] to ( 4.3.6c ). These equations are easy enough to compute, especially if one is calculating the steady-state queue-length probabilities anyway. The higher moments are also accessible, but more difficult.

**Exercise 4.3.3:** Continuing Exercise 4.2.3, calculate \(\operatorname{\mathbb{E}}[X_{w}(n)]\), \(\sigma_{w}^{2}(n)\), and the squared coefficient of variation, \(C_{w}^{2}(n):=\sigma_{w}^{2}(n)/(\operatorname{\mathbb{E}}[X_{w}(n)])^{2}\). Plot your answers for \(C_{w}^{2}(n)\) versus \(n\) (\(0<n<N\)). Also plot the equivalent points for the M/M/1/\(\left/N\right.\) queue for comparison [\(C_{w}^{2}(n)=1/n\)].

<!-- Pages 256-256 -->

#### 4.4.1 Exponential Moments, \(\alpha_{k}(s)\), and Their Meaning

Let us look at Equations (4.2.8b) and (4.2.8c). Recalling that \(\mathbf{D}(s)=(\mathbf{I}+s\mathbf{V})^{-1}\), and \(d(s)=\Psi\left[\mathbf{D}(s)\right]\), it follows that

\[\frac{d}{ds}\mathbf{D}(s)=-\mathbf{V}(\mathbf{I}+s\mathbf{V})^{-2}=-\mathbf{ V}\mathbf{D}(s)^{2}\]

and

\[\frac{d}{ds}d(s)=-\Psi\left[\mathbf{V}\mathbf{D}(s)^{2}\right].\]

In general,

\[\left(\frac{d}{ds}\right)^{k}d(s)=(-1)^{k}k!\Psi\left[\mathbf{V}^{k}\mathbf{D} (s)^{k+1}\right].\]

On the other hand, \(d(s)=B^{*}(s)=\int_{\mathrm{o}}^{\infty}e^{-sx}b(x)dx\), and

\[\left(\frac{d}{ds}\right)^{k}d(s)=\left(\frac{d}{ds}\right)^{k}\int_{\mathrm{ o}}^{\infty}e^{-sx}b(x)dx=(-1)^{k}\int_{\mathrm{o}}^{\infty}x^{k}e^{-sx}b(x)dx.\]

Therefore,

\[k!\Psi\left[\mathbf{V}^{k}\mathbf{D}(s)^{k+1}\right]=\int_{\mathrm{o}}^{ \infty}x^{k}e^{-sx}b(x)dx.\]

Define the _exponential moments_ as given in [12],

\[\alpha_{k}(s):=\int_{\mathrm{o}}^{\infty}\frac{(sx)^{k}}{k!}e^{-sx}b(x)dx.\] (4.4.1a) When no confusion is likely to arise, the dependence of \[\mathbf{D}\] on the parameter \[s\], is suppressed [i.e., \[\mathbf{D}(s)\] and \[\mathbf{D}\] are the same thing]. Then \[\alpha_{k}(s)=\Psi\big{[}(s\mathbf{V}\mathbf{D})^{k}\mathbf{D}\big{]}\,. \tag{4.4.1b}\]

These functions have physical meanings. The term, \((sx)^{k}\exp(-sx)/k!\), in (4.4.1a) is the Poisson probability with arrival rate \(s\) that \(k\) customers will arrive in time interval \(x\). \([b(x)\,dx]\) can be thoght of as the probability that a service time will take a time within \(dx\) of \(x\). Therefore, \(\alpha_{k}(s)\) is the probability that \(k\) customers will arrive after a customer begins being served and before he is finished. It follows, then, that \(\sum_{k=\mathrm{o}}^{\infty}\alpha_{k}=1\). This can be shown directly from (4.4.1a), because

\[\sum_{k=\mathrm{o}}^{\infty}\alpha_{k}(s)=\int_{\mathrm{o}}^{\infty}\sum_{k= \mathrm{o}}^{\infty}\left[\frac{(sx)^{k}}{k!}\right]e^{-sx}b(x)dx=\int_{ \mathrm{o}}^{\infty}e^{sx}e^{-sx}b(x)=1.\]

We have used the fact that the sum in square brackets is the Taylor expansion for \(e^{sx}\). We can also easily get the mean number of arrivals.

\[\sum_{k=\mathrm{o}}^{\infty}k\,\alpha_{k}(s)=\int_{\mathrm{o}}^{\infty}\sum_{ k=1}^{\infty}k\left[\frac{(sx)^{k}}{k!}\right]e^{-sx}b(x)dx\]

<!-- Pages 257-257 -->

\[=\int_{\rm o}^{\infty}sx\sum_{k=\rm o}^{\infty}\left[\frac{(sx)^{k}}{k!}\right]e^{ -sx}b(x)dx=s\int_{\rm o}^{\infty}x\,b(x)dx=s\bar{x},\]

where we have used \(k/k!=1/(k-1)!\).

**Exercise 4.4.1:** Show by direct computation, using (4.4.1b) that

\[\sum_{k=\rm o}^{\infty}\alpha_{k}(s)=1\quad\mbox{and}\quad\sum_{k=\rm o}^{ \infty}k\alpha_{k}(s)=s\Psi[{\bf V}].\]

This is identical to the results when using the integral definition of \(\alpha_{k}\), recognizing that \(\Psi[{\bf V}]=\mbox{\sf E}\hskip-2.0pt\mbox{\sf E}[X]=\bar{x}\).

Next define:

\[d_{k}(s):=\Psi\left[{\bf D}(s)^{k}\right]. \tag{4.4.1c}\]

From (4.2.8c), it follows that \(d(s)=d_{1}(s)=\alpha_{\rm o}(s)\), and that \(d_{\rm o}(s)=1\). A little manipulation lets us see that

\[s{\bf V}{\bf D}(s)={\bf I}-{\bf D}(s),\]

so (using the binomial expansion) we get a relationship between the \(\alpha^{\prime}\)s and the \(d^{\prime}\)s,

\[\alpha_{k}(s)=\Psi\left[({\bf I}-{\bf D})^{k}{\bf D}\right]=\Psi\left[\sum_{ j=\rm o}^{k}\left(\begin{array}{c}k\\ j\end{array}\right)(-1)^{j}{\bf D}^{j+1}\right]\]

\[=\sum_{j=\rm o}^{k}\left(\begin{array}{c}k\\ j\end{array}\right)(-1)^{j}d_{j+1}(s). \tag{4.4.2a}\]

#### 4.4.2 Connection to Laguerre Polynomials

The \(d^{\prime}_{k}\)s can be written in terms of the \(\alpha^{\prime}_{k}\)s, leading to perhaps a more interesting result. From \({\bf D}={\bf I}-s{\bf V}{\bf D}\), we can write for \(d_{k}(s)\),

\[d_{k+1}(s)=\Psi\left[({\bf I}-s{\bf V}{\bf D})^{k}{\bf D}\right]=\sum_{j=\rm o }^{k}\left(\begin{array}{c}k\\ j\end{array}\right)\Psi\left[(-s{\bf V}{\bf D})^{j}{\bf D}\right]\]

\[=\sum_{j=\rm o}^{k}\left(\begin{array}{c}k\\ j\end{array}\right)(-1)^{j}\alpha_{j}(s). \tag{4.4.2b}\]

Next substitute the original definition for \(\alpha_{j}\) from (4.4.1a) to get

\[d_{k+1}(s)=\int_{\rm o}^{\infty}\left[\sum_{j=\rm o}^{k}\left(\begin{array}[] {c}k\\ j\end{array}\right)\frac{(-sx)^{j}}{j!}\right]e^{-sx}b(x)dx. \tag{4.4.2c}\]

<!-- Pages 258-258 -->

It is somewhat surprising to find that the expression in brackets is the _Laguerre polynomial_ of order \(j,\ [L_{j}(sx)]\), which satisfies the following orthogonality condition (see a book such as [15] for full information)

\[\int_{\mathrm{o}}^{\infty}L_{j}(x)L_{k}(x)e^{-2x}\,dx=\delta_{jk}. \tag{4.4.3}\]

The Laguerre polynomials form a complete set, in that any _appropriately well-behaved_ function of \(x\) can be expanded by them in much the same way that periodic functions can be expanded in a Fourier series of sines and cosines. That is, we can say the following. Equation (4.4.2c) can be rewritten as

\[d_{k+1}(s)=\int_{\mathrm{o}}^{\infty}L_{k}(sx)e^{-sx}b(x)dx,\] (4.4.4a) which by the completeness property of orthogonal polynomials, lets us formally write \[b(x)=s\sum_{k=\mathrm{o}}^{\infty}d_{k+1}(s)L_{k}(sx)e^{-sx}. \tag{4.4.4b}\]

This leads to the sum rule,

\[\int_{\mathrm{o}}^{\infty}b^{2}(x)dx=s\sum_{k=\mathrm{o}}^{\infty}\left[d_{k} (s)\right]^{2}. \tag{4.4.4c}\]

These equations are true for any \(s>0\), which allows us to make the statement that every theorem proved by the method of Laguerre functions is automatically true here, too. (See, e.g., [15] and [16] for examples of the use of Laguerres in queueing theory.)

The Laguerre polynomials are often used to approximate functions, but in a context where a least squares fit is meaningful. Such fits do not guarantee that a finite (truncated) sum of \(L_{k}^{\prime}\)s, as in (4.4.4a) will be positive for all \(x\), whereas any approximation to \(b(x)\) must be greater than \(0\) for all \(x\) to be physically meaningful, so if one is to try this approximation method, great care must be taken.

**Exercise 4.4.2:** Prove that (4.4.4b) is identically true in the formal sense. That is, replace \(d_{k}\) by (4.4.1c), substitute for \(L_{k}(sx)\), and manipulate to get (3.1.7d). Similarly, use (4.4.3) and (4.4.4b) to prove (4.4.4c).

There is one last set of functions of \(s\) to be defined. We use \(s\mathbf{VD}(s)=\mathbf{I}-\mathbf{D}(s)\), to write

\[\gamma_{n}(s):=\Psi\left[(s\mathbf{VD})^{n}\right]=\Psi\left[(\mathbf{I}- \mathbf{D})^{n}\right]. \tag{4.4.5a}\]

<!-- Pages 263-263 -->

This, together with the fact that \(r(0)=1-\rho\), is the recursive formula given in most books. Its physical interpretation is as follows, using the meaning of (4.4.1a). The steady-state probability that \(n\) customers will be found at \(S_{1}\) is equal to the probability that when no customers are present, \(n\) customers arrive before any of them finish \([r(0)\alpha_{n}]\), plus the probability that there are \(0<k\leq n+1\) customers present \([r(k)]\) and \(n-k+1\) arrive before any finish \([\alpha_{n-k+1}]\).

The closed system is somewhat more difficult. We have shown that for all \(0\leq n<N,\ r(n;N)\) is proportional to \(r(n)\), therefore we need only evaluate \(\Psi\left[\mathbf{U}^{N-1}\mathbf{V}\right]\) by a separate means, and renormalize. That is, given that Equations (4.1.7) are true, \(r(N;N)=\lambda r(0;N)\Psi\left[\mathbf{U}^{N-1}\,\mathbf{V}\right]\), and \(r(n;N)=r(0;N)u_{n}\) for \(n<N\). So

\[\frac{1}{r(0;N)}=\Psi\left[\mathbf{U}^{N-1}\mathbf{V}\right]+1+\sum_{n=1}^{N- 1}u_{n}.\]

Finally, note that \(\lambda\mathbf{A}\mathbf{V}=\mathbf{I}+\lambda\mathbf{V}-\lambda\mathbf{Q} \mathbf{V}\), so

\[b_{n}:=\Psi\left[\mathbf{U}^{n-1}\lambda\mathbf{V}\right]=\Psi\left[\mathbf{ U}^{n}\lambda\mathbf{A}\mathbf{V}\right]=\Psi\left[\mathbf{U}^{n}(\mathbf{I}+ \lambda\mathbf{V}-\lambda\mathbf{Q}\mathbf{V})\right]\]

\[=u_{n}+b_{n+1}-\rho u_{n},\]

which yields the simple recursive relation, starting with \(b_{1}=\rho\),

\[b_{n+1}=(1-\rho)u_{n}-b_{n}. \tag{4.4.11}\]

This last formula is not usually included in standard texts but is valid for all M/G/1 / \(N\) queues.

As a final thought on this subject, note that the \(b_{N}\)'s not only give the steady-state probabilities that all \(N\) customers are at \(S_{1},[r(N;N)]\), they also yield the residual waiting times for \(n<N\) in the queue. That is, from (4.3.3a),

\[\mathbf{E}[X_{r}(n<N;\,N)]=\frac{b_{n+1}}{\lambda u_{n}}\;. \tag{4.4.12}\]

Equation (4.3.3b) must still be calculated by a different algorithm.

#### 4.4.4 M/M/X//\(N\) Approximations to M/ME/1//\(N\) Loops

It is not our purpose here to search for approximations to the equations we have worked so hard to derive. Rather, we wish to explore the extent of robustness of _Jackson networks_ (see, e.g., [10], [11], [12], and the entire issue of _Computing Surveys_, 3 [14]). The loop with two load-dependent servers, which we described in Section 2.1.5 and assigned the symbol M/M/X//\(N\), can be viewed as a Jackson network with two service centers. In fact, Equations (2.1.11) were deliberately written in a form that reflects the product-form solution one sees in more general networks. One of the great attributes of Jackson networks is their ability to describe the steady-state behavior of a whole network, based

<!-- Pages 264-264 -->

on the properties of the individual service centers (the set of load-dependent service rates). Most important, the properties ascribed to each service center do not depend on the properties of other servers or the system as a whole. Of course, we are accomplishing the same thing in this book, but we have found it necessary to give each subsystem properties that must be expressed by a nontrivial matrix rather than a simple set of scalars. We point out that the M/M/X//N loop, unlike our M/ME/1//N formulation, simply does not have the structure to distinguish residual processes, or other transient properties, from those of the steady state. Therefore, we only compare the steady-state behaviors here.

Suppose that we observe a system which is exactly described by an M/G/1//N loop over a very long period of time. How would one measure the _load dependence_ of a server? A natural and self-consistent definition, or defining measurement procedure, would be as follows (thanks to Victor Wallace for the underlying idea). Let \(t\) be the total time that the system has been under observation, and as we did in Section 1.1.1, let \(N_{i}(t)\) be the number of customers who have left \(S_{i}\) in that time. If \(t\) is indeed very large, we would expect the ratio of \(N_{1}(t)\) to \(N_{2}(t)\) to be very close to 1, close enough so that we can assume that they are equal to each other, and drop the subscript. Then the system throughput is measured as

\[\Lambda(N)\approx\frac{N(t)}{t}\:.\] (4.4.13a) Next, we define the following measurable quantities.

_Definition 4.4.1_

\(N_{i}(n;t):=\) _number of departures from \(S_{i}\) in the time interval, t, which occurred while there were n customers there (counting the one who left)._ Every time a customer leaves \(S_{i}\), the observer, noting how many customers were there just before the departure, increments that counter by 1. 

Then we can say that

\[\sum_{n=1}^{N}N_{i}(n;t)=N(t). \tag{4.4.13b}\]

_Definition 4.4.2_

\(T_{i}(n;t):=\) _total time that there were n customers at \(S_{i}\)._ Every time a customer enters or leaves a subsystem, the observer notes how many customers were there just before that event and adds the amount of time since the previous arrival or departure to the appropriate counter. Of course, an arrival to one subsystem occurs at the same time as the departure from the other subsystem, so two counters are modified simultaneously. 

We then have

\[\sum_{n=0}^{N}T_{i}(n;t)=t\quad\text{for}\:\:i=1,\:2. \tag{4.4.13c}\]

<!-- Pages 265-265 -->

The best we can say about load-dependent service rates is to describe them as "the rate at which customers leave a subsystem for a given queue length." So we use the following, consistent with the definitions we gave in Section 2.1.5 (for arbitrary load dependence).

\[\mu(n)\approx\frac{N_{1}(n;t)}{T_{1}(n;t)}\] (4.4.14a) and \[\lambda(k)\approx\frac{N_{2}(k;t)}{T_{2}(k;t)}. \tag{4.4.14b}\]

These parameters are similar to those considered by J. P. Buzen's _operational analysis_ (e.g., [BuzenDenning]). We assume that \(t\) is so large that the steady-state probabilities we have previously derived for various events are very close to the measured relative frequencies of those events. From our rules and definitions, \(T_{1}(n;t)\) must be approximately equal to the probability that there are \(n\) customers at \(S_{1}\), multiplied by the total time that the system was observed. That is,

\[T_{1}(n;t)\approx r(n;N)\,t.\] (4.4.15a) Also, after some thought, the reader should be able to accept the following formula: \[N_{1}(n;t)\approx d(n-1;N)\,N(t). \tag{4.4.15b}\]

The \(r\)'s and \(d\)'s were defined in Definitions 4.1.1 and 4.1.5, respectively. Remember that \(d(n;N)\) is the probability that a customer will leave \(n\) other customers behind, but \(N_{1}\) and \(N_{2}\) are defined as including the departing customer, hence the \(n-1\) in (4.4.15b). The equivalent formulas for \(S_{2}\) are (\(k\) is the number at \(S_{2}\))

\[T_{2}(k;t)\approx r(N-k;N)\,t\] (4.4.16a) and \[N_{2}(k;\,t)\approx d_{2}(k-1;\,N)\,N(t).\]

The symbol \(d_{2}(k-1;N)\) is borrowed from Section 5.1.2 and is the probability that a customer when departing \(S_{2}\) will leave behind \(k-1\) customers. Clearly, that same customer will arrive at \(S_{1}\), finding \(N-k\) customers already there. (Let's see: there are \(k-1\) at \(S_{2}\), \(N-k\) at \(S_{1}\), and \(1\) traveling, giving a total of \(k-1+N-k+1=N\), right.) Therefore, \(d_{2}(k-1;N)=a(N-k,N)\), and we can write

\[N_{2}(k;\,t)\approx a(N-k;\,N)\,N(t). \tag{4.4.16b}\]

We are now ready to put things together. Using Equations (4.4.13a) and (4.4.15) in (4.4.14a) yields

\[\mu(n)=\frac{d(n-1;\,N)\,N(t)}{r(n;\,N)\,t}=\frac{d(n-1;\,N)}{r(n:\,N)}\, \Lambda(N).\]

But from (4.1.13c) and (4.1.8b), and noting that \(1/\bar{x}_{2}=\lambda\), we have

\[\mu(n)=\frac{r(n-1;\,N)}{r(n;\,N)}\frac{\Lambda(N)}{1-r(N;\,N)}=\lambda\frac{ r(n-1;\,N)}{r(n;\,N)}. \tag{4.4.17a}\]

<!-- Pages 267-267 -->

to be constant, but the matrix \(\mathbf{U}\) depends on \(\lambda\) in a nontrivial way.

**Example 4.4.1:** Let us look at \(\mu(1)\) from (4.4.19a), for an \(\mathrm{M}/E_{2}/1/\left/N\right.\) queue. In that case (see Exercise 3.1.1)

so (recall that \(\mathbf{Q}=\boldsymbol{\epsilon^{\prime}}\,\mathbf{p}\))

\[\mathbf{A}=\mathbf{I}+\frac{1}{\lambda}\mathbf{B}-\boldsymbol{\epsilon^{ \prime}}\,\mathbf{p}=\left[\begin{array}{cc}1&0\\ 0&1\end{array}\right]+\frac{\mu}{\lambda}\left[\begin{array}{cc}1&-1\\ 0&1\end{array}\right]-\left[\begin{array}{cc}1&0\\ 1&0\end{array}\right].\]

We know that \(\bar{x}_{1}=2/\mu\); therefore, \(\rho=\lambda\bar{x}_{1}=2\lambda/\mu\). Thus we can write

\[\mathbf{A}=\left[\begin{array}{cc}\frac{2}{\rho}&-\frac{2}{\rho}\\ &\\ -1&1+\frac{2}{\rho}\end{array}\right]\]

and

\[\mathbf{U}=\mathbf{A}^{-1}=\frac{\rho}{2}\left[\begin{array}{cc}1+\frac{ \rho}{2}&1\\ &\\ \frac{\rho}{2}&1\end{array}\right].\]

Of course, \(\Psi\left[\mathbf{U}\right]=\mathbf{p}\,\mathbf{U}\,\boldsymbol{\epsilon^{ \prime}}\), so (4.4.19a) for \(n=1\) becomes

\[\bar{x}_{1}\,\mu(1)=\frac{4}{4+\rho}.\]

We see even in this simplest of all nontrivial queues, that a load-dependent exponential approximation to a (load-independent) nonexponential server depends heavily on parameters of other parts of the system, as represented here by \(\rho\). For instance, when \(\rho=0\), we get \(\mu(1)=1/\bar{x}_{1}\), which is what one would expect. But for \(\rho=1\), \(\mu(1)=0.8/\bar{x}_{1}\). For yet larger values of \(\rho\) (remember that for closed systems, \(\rho\) can take on any nonnegative value), \(\mu(1)\) will be even smaller. Similar comments can be made for \(\mu(k)\), \(k>1\). \(\blacktriangle\)

Our conclusion is that Jackson networks, due to their parametric richness, are robust enough to fit the measurements of any given network of service centers. This can be most useful, because one is often overcome with a flood of data in measuring the performance of complex systems, and the product-form solution provides a framework on which the data can be _hung_, to test self-consistency and provide meaning. They also warn us not to try too hard to get more out of a system near saturation. However, one must be very cautious in using the same data in extrapolating to other systems if the systems do not satisfy the assumptions that went into the derivation of the product-form solution. In short, Jackson network model _explains_ everything, but its predictions are no better than the assumptions that go into it.

<!-- Pages 268-268 -->

### 4.5 Transient Behavior of M/ME/1 Queues

It is in the discussion of non-steady-state properties of queues that LAQT shows its unique value, for we see that all events correspond to some linear matrix operation on a state vector. The approach is quite general, but for now we limit ourselves to those topics covered in Section 2.3. Before reading further, the reader should go back to that section, as well as Section 3.1, and review the material contained therein, carefully.

#### 4.5.1 First-Passage Processes for Queue Growth

To evaluate the time it takes for a queue to grow to a given length, we must first find out how long it takes the queue to go from \(n\) to \(n+1\) for the first time. The procedure we must use is in the same spirit as Section 2.3.1, but more complex. Not only can the external state of the system (i.e., the number of customers at \(S_{1}\)) change by one unit at a time, up or down, as in Chapter 2, but it can also remain constant, as in Chapter 3. Furthermore, we must keep track of the internal state of the system as the queue grows. Because \(n\) can never exceed the total number in the system, \(N\) plays no role in this process (unless \(S_{2}\) is a load-dependent server, a subject we could cover with equal ease). Therefore, this section is equally valid for open and closed systems. Unfortunately, we have to be satisfied with recursive formulas for the parameters of interest rather than the nice explicit expressions we were able to get for the M/M/1 queue. We are not making the claim that explicit expressions do not exist, but merely that we have not found them as yet. Very little work has been done with these formulas up to now, so there is every reason to hope that an adventurous, algebraically oriented researcher will find one in the future.

#### 4.5.1 Conditional Probabilities for Queue Growth

Before even looking at times for _first passage_, we must first find out the probability that the system will be in state \(j\) when it reaches queue length \(n+1\) for the first time after starting in \(\{i;\,n\}\). On first thought this seems to be a trivial question. It certainly is trivial for decreasing lengths, because a decrease can only occur immediately after a departure, subsequent to which, another customer enters \(S_{1}\), putting the system in _internal state_\(\mathbf{p}\). By this we mean the following. "The probability that the system is in state \(\{i;\,n\}\) is \(p_{i}\)." We use the two expressions synonymously.

What we just said about decreasing lengths would seem to be true for increasing lengths as well. For then, an increase can only occur immediately after an arrival to \(S_{1}\), and that does not change the internal state at all. Ah, but many things may have happened before that final arrival sent the system from \(n\) to \(n+1\). Suppose that initially the system has \(n\) customers at \(S_{1}\) and the active customer is at phase \(i\). That is, the system is in state \(\{i;\,n\}\). Define the conditional probability matrix.

<!-- Pages 269-269 -->

**Definition 4.5.1**: \(\mathbf{H_{u}}(n){:=}\) _probability matrix of first passage from n to \(n+1\)_ That is, \([\mathbf{H_{u}}(n)]_{ij}\) is the probability that \(S_{1}\) will be in state \(j\) when its queue goes from \(n\) to \(n+1\) for the first time, given that it started in state \(\{i;\,n\}\). As in Section 2.3, the subscript \(\mathbf{u}\) stands for _up._ Recall that a subscript is **boldfaced**, if and only if the object to which it is attached is a vector or matrix. 

We assert that the queue must grow to \(n+1\) some day, so the sum across each row must be \(1\):

\[\mathbf{H_{u}}(n)\,\boldsymbol{\ell^{\prime}}=\boldsymbol{\ell^{\prime}}\quad \text{ for all }\ n\ \geq\ 0. \tag{4.5.1}\]

Thus \(\mathbf{H_{u}}(n)\) is isometric. We prove this algebraically after we have found a recursive formula for the \(\mathbf{H_{u}}\)'s. For the remainder of this section we usually drop the subscript when there is no ambiguity. The following discussion is similar to the material in Section 4.1.2 related to Figure 4.1.2.

Given that our system is initially in state \(\{i;\,n\}\), the first event can occur in only two ways: either a completion occurs in \(S_{1}\), with probability \([(\mathbf{M}+\lambda\mathbf{I})^{-1}\mathbf{M}]_{ii}\), or there is a completion at \(S_{2}\), with probability \([(\mathbf{M}+\lambda\mathbf{I})^{-1}\lambda]_{ii}\). Next look at Figure 4.5.1. If the event occurred in \(S_{2}\), a customer will arrive at \(S_{1}\), increasing the number there by one without changing the internal state. This corresponds to the solid arrow going diagonally upward and to the right (labeled I, \(a\to d\)). If the event occurred in \(S_{1}\), one of two things could happen. Either the active customer goes from \(i\) to some other phase, say \(k\) (with probability \(P_{ik}\)), thereby leaving the system in the same external state \([n]\), or he could leave \(S_{1}\) (with probability \(q_{i}\)) and be replaced by a new customer who would then go to phase \(k\) (with probability \(p_{k}\)), putting the system in state \(\{k;\,n-1\}\). If the former is the case, it is like starting over again, and given that the system now starts in state \(\{k;\,n\}\), it will find itself in external state \(n+1\) for the first time with probability \([\mathbf{H}(n)]_{kj}\) of being in internal state \(j\). This sequence of events corresponds to the solid vertical arrow, followed by the wavy arrow pointed diagonally upward to the right (labeled II, \(a\to c\to f\)).

Recall from Chapter 2 that a wavy arrow represents the infinity of possible ways to get from the tail to the head, and a solid arrow corresponds to a direct, single process. The last case puts the system in state \(\{k;\,n-1\}\), from which it must eventually get back to \(\{l;\,n\}\) for some \(l\), and then finally to \(\{j;\,n+1\}\). This is represented in Figure 4.5.1 by the path labeled III (\(a\to b\to e\to g\)), which is the solid arrow pointing diagonally to the left, followed by two successive wavy arrows diagonally upward to the right.

The three sequences of events are mutually exclusive, and exhaustive, but remember to sum over all possible intermediate states \(k\) and \(l\). They clearly are mutually exclusive. We show that they are exhaustive by proving that the sum of the three sets of initial probability matrices is isometric, which is the same as showing that customer surely went somewhere. Look at the following. The \((ij)\)-th component of each of the three terms is the probability of taking path I, II, or III, respectively, ending in internal state \(j\), after starting in state

<!-- Pages 272-272 -->

**Theorem 4.5.1:** For any M/G/1//\(N\) queue, and for any \(\rho\), if at any time there are \(n<N\) customers in the queue of \(S_{1}\), then given enough time, the queue will eventually have \(n+1\) customers in it [i.e., \(\mathbf{H_{u}}(n)\,\boldsymbol{\epsilon^{\prime}=\boldsymbol{\epsilon^{\prime}}}\)].

This might be called the "pessimist's theorem," because it implies that no matter how bad things are now (long queue), if our random observer waits long enough, she will certainly see it get worse some day (longer queue). There are at least two weaknesses to this argument, however. First of all, the theorem assumes that conditions will remain the same for time immemorial, the _homogeneous_ assumption. Second, the pessimist is assuming that the random observer will live long enough to see things get worse. This is an important reason for studying non-steady-state behavior. For if "some day" is longer than say, the age of the universe, who cares? In Chapter 2 we calculated what this time would be for an exponential queue [Equations (2.3.2)], and saw that this could be long indeed if \(\rho<1\). See a related discussion in Section 3.3.6 on the St. Petersburg Paradox and PT distributions.

We now show how to calculate mean _first-passage times_ for general queues in the next section, after saying some final remarks about the first-passage matrices. Equation (4.5.2d) seems simple enough, so we might be encouraged to substitute it into (4.5.2b) or (4.5.2c) to get an explicit formula for \(\mathbf{H_{u}}(2)\), but the resulting expression does not simplify greatly. For higher \(n\) it is even messier. It is better to think of these formulas as a recursive definition of the (\(\mathbf{H_{u}}\))s, and to use (4.5.2b) or (4.5.2c) to numerically compute them recursively when explicit examples are needed. Note that in general, the (\(\mathbf{H_{u}}\))s are all different, although they do approach a limit for large \(n\).

From these matrices one can also find the probability matrices of first passage from \(n\) to \(n+l\), for any \(n\) and \(l\).

_Definition 4.5.2_

\(\mathbf{H_{u}}(n\to n+l):=\) _probability matrix of **first passage** from n to \(n+l\), \(l\geq 1\)._ That is, \([\mathbf{H_{u}}(n\to n+l)]_{ij}\) is the probability that \(S_{1}\) will be in state \(j\) when its queue goes from \(n\) to \(n+l\) for the first time, given that it started in state \(i\) with \(n\) customers. In particular, \(\mathbf{H_{u}}(n\to n+1)=\mathbf{H_{u}}(n)\).

The _first-passage matrix_ of going from \(n\) to \(n+2\) is simply

\[\mathbf{H_{u}}(n\to n+2)=\mathbf{H_{u}}(n)\mathbf{H_{u}}(n+1),\]

and in general,

\[\mathbf{H_{u}}(n\to n+l+1)=\mathbf{H_{u}}(n\to n+l)\mathbf{H_{u}}(n+l)\]

\[=\mathbf{H_{u}}(n)\mathbf{H_{u}}(n+1)\cdots\mathbf{H_{u}}(n+l).\]

Would the author be presumptuous in declaring it obvious that \(\mathbf{H_{u}}(n\to n+l)\) is isometric?

<!-- Pages 273-273 -->

A particularly interesting matrix (it is actually a vector) is the probability of first passage from \(0\to n\). It is given by

\[\mathbf{p_{u}}(n):=\mathbf{pH_{u}}(1)\mathbf{H_{u}}(2)\cdots\mathbf{H_{u}}(n-1). \tag{4.5.4}\]

Here too, it is clear that \(\mathbf{p_{u}}(n)\,\boldsymbol{\epsilon^{\prime}}=1\) for all \(n\), so Theorem 4.5.1 extends to the statement: "given enough time, every possible queue length will be experienced at least once." But what is "enough time?" We discuss this vector further when we actually define it in Definition 4.5.4.

The first-passage matrices may not appear to be very interesting in their own right, but they are needed for calculating first-passage times, as shown in the next section.

##### 4.5.1.2 Mean First-Passage Time for Queue Growth

This section is a direct generalization of the material in Section 2.3.1. By arguments similar to those required to derive (4.5.2), one can derive the mean time for the queue to grow from \(n\) to \(n+1\) for the first time. First define the vector \(\boldsymbol{\tau^{\prime}_{u}}(n)\).

_Definition 4.5.3_

\(\boldsymbol{\tau^{\prime}_{u}}(n):=\)_mean first-passage time vector from n to n+1_. The \(i\)-th component is the mean time it takes for the queue at \(S_{1}\) to have \(n+1\) customers for the first time, having started in state \(\{i;\,n\}\). 

Look once more at Figure 4.5.1. Suppose that there are \(n\) customers in the queue at \(S_{1}\), and the active customer is at phase \(i\). From that figure, one of three things will happen next. The mean time until the next event is given by \(1/(\lambda+\mu_{i})=[(\lambda\mathbf{I}+\mathbf{M})^{-1}\boldsymbol{\epsilon^ {\prime}}]_{i}\). If the event that occurs is an arrival from \(S_{2}\), [path I], the process is over. If, however, the event is internal to \(S_{1}\), [path II], the system will go to state \(\{j,\,n\}\) with probability given by \([(\lambda\mathbf{I}+\mathbf{M})^{-1}\mathbf{MP}]_{ij}\), and then will take another \([\boldsymbol{\tau^{\prime}_{u}}(n)]_{j}\) to accomplish the task. Worse yet, if the event results in a departure from \(S_{1}\), as shown in path III, the system, finding itself in some state \(\{j;\,n-1\}\) with probability \([(\lambda\mathbf{I}+\mathbf{M})^{-1}\mathbf{Mq^{\prime}p}]_{ij}\), must first get back to length \(n\) in time \([\boldsymbol{\tau^{\prime}_{u}}(n-1)]_{j}\) and then on to \(n+1\). But this long excursion of going down and back up puts the system into state \(k\) with probability \([(\lambda\mathbf{I}+\mathbf{M})^{-1}\mathbf{Mq^{\prime}pH_{u}}(n-1)]_{ik}\). (At last we see the need for a first-passage matrix.) The three processes together lead to the following vector equation.

\[\boldsymbol{\tau^{\prime}_{u}}(n)=(\lambda\mathbf{I}+\mathbf{M})^{-1} \boldsymbol{\epsilon^{\prime}}+(\lambda\mathbf{I}+\mathbf{M})^{-1}\mathbf{MP} \boldsymbol{\tau^{\prime}_{u}}(n)\]

Next, premultily both sides of the equation by \((\lambda\mathbf{I}+\mathbf{M})\), bring all terms proportional to \(\boldsymbol{\tau^{\prime}_{u}}(n)\) to the left-hand side, and get

\[[\lambda\mathbf{I}+\mathbf{M}-\mathbf{MP}-\mathbf{Mq^{\prime}pH_{u}}(n-1)] \boldsymbol{\tau^{\prime}_{u}}(n)=\boldsymbol{\epsilon^{\prime}}+\mathbf{Mq^{ \prime}p\boldsymbol{\tau^{\prime}_{u}}}(n-1).\]

This formula has several familiar components. Recall that \(\mathbf{M}-\mathbf{MP}=\mathbf{B}\), \(\mathbf{Mq^{\prime}p}=\mathbf{BQ}\), and thus from (4.5.2b) the term in brackets is \(\lambda\) times the

<!-- Pages 275-275 -->

arrives, thereby leaving the queue with only \(n-1\) customers. Therefore, it will take longer to recover if \(n\) is larger. 

It would be most interesting to study first-passage times for other distributions, because very little is known about this type of behavior.

The first-passage time vectors do not by themselves give us the times we are looking for. We must first decide what state we are in when the process begins. In Chapter 2 this was no problem, in as much as we only had to know the number in the queue. Now unfortunately, we must make some statement as to the initial internal state of \(S_{1}\). Once we do this (whether the system is open or closed, irrespective of whether \(\rho\) is less than, equal to, or greater than 1), we can then calculate such things as

1. The mean first-passage time of going from \(n\) to \(n+1\), given that the customer in service has just begun;

2. The mean first-passage time to \(n+1\), as seen by a random observer who sees \(n\) customers there initially;

3. The mean first-passage time to \(n+1\), given that there are \(n\) customers in the queue, and the last customer just arrived;

Figure 4.5.2: **The two components of mean first-passage time vector \(\boldsymbol{\tau^{\prime}_{\boldsymbol{\boldsymbol{\boldsymbol{\boldsymbol{ \boldsymbol{\boldsymbol{\boldsymbol{\boldsymbol{\boldsymbol{\boldsymbol{\boldsymbol{\boldsymbol{ \boldsymbol{\boldsymbol{\boldsymbol{\boldsymbol{ \boldsymbol{ }}}}}}}}}}}}}}(n)\), as a function of the number of customers at \(S_{1}\), for the M/\(E_{2}\)/1 queue. There are five sets of curves, corresponding to \(\rho=\) 0.5, 0.8, 0.95, 1.0, and 2.0. If the process starts when a customer first enters, he goes to phase 1, and when finished there, goes to phase 2, after which he leaves. If a new customer arrives before the active customer leaves, the process ends (the queue has grown by 1). Otherwise, the process continues, with possibly many events occurring. For all \(\rho\) and \(n,[\boldsymbol{\tau^{\prime}}]_{1}\) (dashed lines) lies below \([\boldsymbol{\tau^{\prime}}]_{2}\) (solid lines). The curves corresponding to \(\rho=2\) are not negligible. For \(n\geq 20\), their values are constant at 0.809 and 1.118, respectively.**

<!-- Pages 276-276 -->

4. The mean first-passage time from \(n\) to \(n+1\), given that the queue was originally empty;

5. The mean time for a queue to grow to \(n\) for the first time, given that a customer has just arrived at an empty queue.

(Note that items 1 to 4 yield identical results for the M/M/1 queue.) For instance, the internal state of \(S_{1}\) immediately after a customer departs and a new customer enters is the entrance vector \(\mathbf{p}\). Therefore, the first item of the list above can be calculated as follows.

**Corollary 4.5.2a:** The mean time for an M/ME/1 queue to grow to \(n+1\) for the first time, given that \(n\) customers are there at the beginning, and the customer in service at \(S_{1}\) has just begun, is given by

\[\mathbf{p}\boldsymbol{\tau_{u}^{\prime}}(n).\]

This is the same as the _mean first-passage time to \(n+1\)_, given that a customer has just left behind \(n\) customers. It is also the same as the "mean time for \(S_{1}\) to return to queue length \(n+1\) for the first time, given that it just dropped to n." There are, no doubt, other equivalent statements. The state the system will be in when this occurs is given by

\[\mathbf{p}\mathbf{H_{u}}(n).\]

Thus the expression

\[\mathbf{p}\boldsymbol{\tau_{u}^{\prime}}(n)+\mathbf{p}\mathbf{H_{u}}(n) \boldsymbol{\tau_{u}^{\prime}}(n+1)\]

is the mean first-passage time to \(n+2\), given that service has just begun with \(n\leq N-2\) customers.

Another interesting passage time is given by item 2 above. The condition as stated there is insufficient to derive an expression. After all, what was the history of the queue before the random observer arrived? We could assume that the system has been in operation for a long time, long enough to be near its steady state. This was discussed in Section 4.3.1 in analyzing residual times. We follow that section here. Thus the random observer will find the system in the composite state described by the vector [see (4.3.1a)]

\[\frac{1}{r(n;N)}\boldsymbol{\pi}(n;N)=\boldsymbol{\pi_{\mathbf{r}}}(n)=\frac{ 1}{\Psi\left[\mathbf{U}^{n}\right]}\mathbf{p}\mathbf{U}^{n}.\]

The residual vector appears again. Note that this vector does not depend on \(N\), except that \(n\) must be less than \(N\). If \(n=N\), the queue can never rise above \(N\) anyway. We can state the time for this process by the following.

**Corollary 4.5.2b:** The mean time for a steady-state M/ME/1 queue to grow to \(n+1\) for the first time, as seen by a random observer who finds \(n\) customers there already, is given by

\[\boldsymbol{\pi_{\mathbf{r}}}(n)\,\boldsymbol{\tau_{u}^{\prime}}(n)\quad \text{for}\ \ 0\leq\ n<N\]

<!-- Pages 277-277 -->

(yes, it is true for \(n=0\)). After the system finally gets to \(n+1\), it will be in state

\[\boldsymbol{\pi_{\mathrm{r}}}(n)\,\mathbf{H_{u}}(n).\]

The expression

\[\boldsymbol{\pi_{\mathrm{r}}}(n)\boldsymbol{\tau_{\mathrm{u}}^{\prime}}(n)+ \boldsymbol{\pi_{\mathrm{r}}}(n)\mathbf{H_{u}}(n)\,\boldsymbol{\tau_{\mathrm{u }}^{\prime}}(n+1)\]

is the mean first-passage time from \(n\) to \(n+2\), as seen by a random observer. \(\blacksquare\)

In Section 4.3.2 we showed that an arriving customer will see much the same thing as a random observer if he remembers not to count himself as a member of the queue. Thus a newly arriving customer will find \(S_{1}\) in state \(\boldsymbol{\pi_{\mathrm{r}}}(n)\), given that there are already \(n\) customers there. In other words, he becomes the \((n+1)\)st customer. Thus he will _not_ see the same mean passage times as did the random observer, because he is part of the action. In fact, he may not even be around long enough to see the queue grow longer than it was when he first arrived. For instance, suppose that a customer arrives at an empty queue. Then he himself enters \(S_{1}\) and puts it in state \(\boldsymbol{\pi_{\mathrm{r}}}(0)=\mathbf{p}\). If he finishes service before the next customer arrives, he will not be around to see the queue grow to 2, even though it will eventually happen [in mean time \(\mathbf{p}\,\boldsymbol{\tau_{\mathrm{u}}^{\prime}}(1)\)]. We state this result as yet another corollary. The reader should compare this with the previous one to be sure that the differences are clear.

**Corollary 4.5.2c:** The mean time for a steady-state M/ME/1 queue to grow to \(n+1\) for the first time, given that the \(n\)-th customer has just arrived, is given by

\[\boldsymbol{\pi_{\mathrm{r}}}(n-1)\boldsymbol{\tau_{\mathrm{u}}^{\prime}}(n) \quad\text{for}\;\;0<n<N\]

(no, it is not true for \(n=0\)). After the queue length finally reaches \(n+1\), it will be in state

\[\boldsymbol{\pi_{\mathrm{r}}}(n-1)\mathbf{H_{u}}(n).\]

The expression

\[\boldsymbol{\pi_{\mathrm{r}}}(n-1)\,\boldsymbol{\tau_{\mathrm{u}}^{\prime}}(n )+\boldsymbol{\pi_{\mathrm{r}}}(n-1)\,\mathbf{H_{u}}(n)\,\boldsymbol{\tau_{ \mathrm{u}}^{\prime}}(n+1)\]

is the mean first-passage time for the queue to grow from \(n\) to \(n+2\), given that a customer has just arrived. \(\blacksquare\)

The most important variation on the theme of this section is the first-passage time starting with an empty subsystem, or starting with the arrival of a customer to an empty subsystem. We assume the former, but the two differ only by the mean time until a customer arrives, which is \(1/\lambda\). This is the process that corresponds to the queue growth discussed in Section 2.3.1 for the M/M/1 queue. To do this, we need two new types of objects.

<!-- Pages 278-278 -->

**Definition 4.5.4**: \(\mathbf{p_{u}}(n):=\) _probability vector for first passage from \(0\) to n._ Component \([\mathbf{p_{u}}(n)]_{i}\) is the probability that a customer will be in state \(i\) when the queue at \(S_{1}\) reaches length \(n\) for the first time, given that the queue was initially empty.

This vector was actually introduced in (4.5.4), but we were not ready to use it then.

**Definition 4.5.5**: \(t_{u}(n):=\) _mean first-passage time for the queue at \(S_{1}\) to grow from \(n\) to \(n+1\), given that the queue was originally empty, and a customer has just arrived_. The process begins at the moment the queue reaches length \(n\).

This more or less corresponds to Definition 2.3.1 for \(\boldsymbol{\tau_{\mathsf{u}}}(n)\), but an M/M/1 queue has no internal states (or rather, only one internal state), so it did not make any difference when service began.

We can describe this process through the eyes of the random observer. At some time in the past she observed that the queue at \(S_{1}\) was empty (no one was being served). She then watched the queue, and when it finally reached the length \(n\), she turned on her timer. At that moment, the system was in state \(\mathbf{p_{u}}(n)\). This is the initial vector for what follows. When the queue finally reaches length \(n+1\), she turns off the timer. The mean time that her timer shows is \(t_{u}(n)\).

Let us suppose that there is no one at \(S_{1}\) initially, then in mean time, \(t_{u}(0)=1/\lambda\), the first customer will arrive, putting the system into internal state \(\mathbf{p_{u}}(1)=\mathbf{p}\). Eventually, the queue will grow to \(2\) for the first time, in mean time, \(t_{u}(1)=\mathbf{p}\boldsymbol{\tau_{\mathsf{u}}^{\prime}}(1)\), at which time the system will be in internal state \(\mathbf{p_{u}}(2)=\mathbf{p}\mathbf{H_{u}}(1)\). At some time in the future the queue will get to \(3\) for the first time, taking on average \(t_{u}(2)=\mathbf{p_{u}}(2)\boldsymbol{\tau_{\mathsf{u}}^{\prime}}(2)\) units of time. At that moment the system will find itself in internal state \(\mathbf{p_{u}}(3)=\mathbf{p}\mathbf{H_{u}}(1)\mathbf{H_{u}}(2)=\mathbf{p_{u}}( 2)\mathbf{H_{u}}(2)\). The sequence continues until the number of customers at \(S_{1}\) reaches \(N\). The total time it takes to go from \(0\) to \(n\) is the sum of the \(t_{u}^{\prime}\)s.

**Example 4.5.5**: _In Figure 4.5.3, we plotted the components of \(\mathbf{p_{u}}(n)\) as a function of \(n\) for the M/\(E_{2}/1\) queue. It is not easy to understand what is going on here, because the process is so complicated. The residual vector (Definition 4.3.1)\(\boldsymbol{\pi_{\mathsf{r}}}(n)\) is quite different from this. In the residual process, a random observer (and for the M/G/1 queue, an arriving customer) will find a steady-state system in vector state \(\boldsymbol{\pi_{\mathsf{r}}}(n)\) as given by (4.3.1), assuming that there were \(n\) customers there already. The vector \(\mathbf{p_{u}}(n)\) refers only to the customer whose arrival brings the queue to length \(n\) for the first time, given that the queue started at \(0\). Thus this special customer found \(n-1\) customers there already when he arrived._

**Definition 4.5.6**: \(t(0\to n):=\) _mean first-passage time from 0 to n._ This is the

<!-- Pages 279-279 -->

mean time it will take the queue at \(S_{1}\) to grow to length \(n\), given that \(S_{1}\) was initially empty. This is the same as Definition 2.3.2. 

This process is summarized by the final corollary of this section.

**Corollary 4.5.2d:** The mean time for an M/ME/1 queue (open or closed) to grow from \(n\) to \(n+1\) for the first time, given that \(S_{1}\) was initially empty, starting with \(t_{u}(0)=1/\lambda\), is

\[t_{u}(n):=\mathbf{p_{u}}(n)\boldsymbol{\tau_{u}^{\prime}}(n),\ \ \ \ \ n=1,\ 2,\ldots.\] (4.5.6a) Starting with \[\mathbf{p_{u}}(1):=\mathbf{p}\], the internal state of the system at the moment of first passage to \[n\], \[\mathbf{p_{u}}(n)\] is given recursively by \[\mathbf{p_{u}}(n)=\mathbf{p_{u}}(n-1)\mathbf{H_{u}}(n-1),\ \ \ \ \ n=1,\ 2,\cdots \tag{4.5.6b}\]

The mean first-passage time from \(0\) to \(n\) is the same as (2.3.3a), namely

\[t(0\to n)=\sum_{l=0}^{n-1}t_{u}(l). \tag{4.5.7}\]

Figure 4.5.3: **Components of \(\mathbf{p_{u}}(n)\), the probability vector of first passage from 0 to \(n\), versus \(n\), for the M/\(E_{2}\)/1 queue.** If a customer arrives at an empty queue, he will certainly go to phase 1. Thus all curves start with \([1,\ 0]\). The two sets of curves are mirror images of each other about the line \(\mathbf{p_{u}}(n)=1/2\), because for any \(n\), the sum of the two components is 1. For all \(\rho\), the vectors reach their asymptotic values before \(n=10\). Compare with the mean residual vector \(\boldsymbol{\pi_{\mathrm{r}}}=[0.5,\ 0.5]\).

<!-- Pages 280-280 -->

Compare this with (2.3.3a). These formulas are independent of \(N\) and are true as long as \(n\leq N\). \(\blacksquare\)

**Example 4.5.3:** The overall behavior of \(t(0\to n)\) for the M/\(E_{2}/1\) queue is similar to that for the M/M/1 queue, given in Figure 2.3.2. In Figure 4.5.4 we have plotted the two types on the same graph so they can be compared. Although similar, they have distinct differences. As \(n\) gets larger, the two curves separate from each other, and the closer \(\rho\) gets to 1, the greater the separation, with the \(E_{2}\) curve lying below the M/M/1 curve. When \(\rho\) is much greater than 1, the growth is dominated by the difference of the arrival and service rates, but there _is_ a difference, depending on the pdf of \(S_{1}\). For the M/\(H_{2}/1\) queue, the differences are more pronounced, and the corresponding curves end up above those for the M/M/1 queue. \(\blacktriangle\)

Is this property dependent on \(C_{v}^{2}\)? The reader should explore the behavior of this process for other distributions, considering that so little is known about this subject.

Note that the first-passage processes we have been discussing allow the queue at \(S_{1}\) to empty any number of times before finally reaching its goal. In the third subsection of Section 4.5.3 we study the first excursion to \(n\) during a _busy period_. In that case we find the _probability_ that the queue will reach length \(n\) before it empties, because it is not certain to do so. We have to develop some other expressions first.

Figure 4.5.4: Comparison of the mean first-passage times from 0 to \(n\), \(t(0\to n)\), between the M/M/1 queue and the M/\(E_{2}/1\) queue, for \(\rho=\)0.5, 1.0, and 1.5. In all cases, the curve corresponding to \(E_{2}\) ends up lower, but the two do cross.

<!-- Pages 281-281 -->

#### 4.5.2 Formal Procedure for Finding System Parameters

After reading the preceding section, the reader must have become familiar with how to set up the expressions needed to calculate various system parameters. We now outline a formal procedure for doing this. First, based on the given conditions, or initial assumptions, one finds the _initial vector_\(\mathbf{p_{i}}\), that describes the internal state of the system initially (e.g., the \(\mathbf{p_{u}}\)'s). Then, depending on the process of interest, _propagation matrices_, \(\mathbf{S_{p}}\), are found (e.g., the first-passage matrices). Finally, the _final vector_, \(\mathbf{v^{\prime}_{f}}\), that contains the kind of information desired (e.g., \(\boldsymbol{\tau^{\prime}}\) for mean times and \(\boldsymbol{\epsilon^{\prime}}\) for probabilities), is found. The desired scalar property (call it g) is then given by

\[g=\mathbf{p_{i}}\mathbf{S_{p}}\mathbf{v^{\prime}_{f}}.\] (4.5.8a) The initial and final vectors are commonly made of propagation matrices post- or premultiplying other initial or final vectors, whereas propagation matrices are usually products of other propagation matrices. In this way one can build up an unlimited sequence of conditions and results without difficulty. Also, the boundary between \[\mathbf{i}\] and \[\mathbf{p}\], or \[\mathbf{p}\] and \[\mathbf{f}\], is not necessarily unique, nor is it important to try to find a definition that makes them unique.

The reader should peruse through the material already covered, to see if this scheme holds true everywhere. In doing so you will notice that almost always, an initial vector can be written as the entrance vector of \(S_{1},[\mathbf{p}]\), post-multiplied by a propagation matrix (call it \(\mathbf{S_{i}}\)). Also, almost always, the final vector can be written as some other propagation matrix (call it \(\mathbf{S_{f}}\)), premultiplying \(\boldsymbol{\epsilon^{\prime}}\). This leads to

\[g=\mathbf{p}\mathbf{S_{i}}\mathbf{S_{p}}\mathbf{S_{f}}\boldsymbol{\epsilon^{ \prime}}=\Psi\left[\mathbf{S_{i}}\mathbf{S_{p}}\mathbf{S_{f}}\right]. \tag{4.5.8b}\]

We now see why the \(\Psi\left[\,\cdot\,\right]\) operator appears in so many places and why it is such a useful object.

#### 4.5.3 Properties of the \(\boldsymbol{k}\)-Busy Period

Everything that goes up must come down; well, almost everything. Whenever \(S_{1}\) is emptied of customers (\(n=0\)), we say that "a busy period has ended." If observation began with some initial conditions (call them collectively \(\{\cdots\}\)), then we have a "\(\{\cdots\}\)-busy period." As described in Section 2.3.2, if a customer has just arrived at an empty subsystem, we simply have the beginning of a _busy period_. Clearly, studying busy periods requires studying queue-length reduction.

We proceed in analogy with Section 4.5.1. However, not all objects will work out in the same way. The \(\mathbf{H_{d}}\) matrices are much simpler than the \(\mathbf{H^{\prime}_{u}}\)s. However, the \(\boldsymbol{\tau^{\prime}_{d}}\) vectors depend explicitly on \(N\), as well as \(n\); thus length reduction processes are somewhat more complicated to express. The reason for this, as we presently show, is that in its attempt to go up, the queue can never drop below 0, and thus is bounded by its own length. In trying to shrink, the queue can falter and grow to any length before finally coming down. A ceiling of \(N\) is imposed by the system's finite population, and the higher the

<!-- Pages 282-282 -->

ceiling, the longer it takes to get down to \(0\). Actually, first-passage processes to go from \(n\) to \(n-1\) depend on \(N-n\), so unless \(S_{2}\) is load dependent, the problem is not that bad.

We have one last point before going on. In dealing with a growing queue, we had to start at \(0\). Similarly, in studying the decreasing queue, the recursive equations must start at \(N\). But where does one start in an open system?

##### Conditional Probabilities for Queue Decrease

The first-passage matrices from \(n\) to \(n-1\) can be written down with some thought and no algebra. A decrease in queue length can only occur after a departure. Immediately after that a new customer (provided that \(n\) was greater than \(1\) originally) enters \(S_{1}\), putting the system in internal state \(\mathbf{p}\). Given that this is independent of the state the system was in initially, our desired matrix must be \(\mathbf{Q}\). However, we go through a full algebraic derivation, because we have do it anyway when we derive the corresponding first-passage times. Define the following matrix for an M/ME/\(1//N\) loop.

_Definition 4.5.7_

\(\mathbf{H_{d}}(n;N):=\)_probability matrix of first passage from \(n\) to \(n-1\)_. Component \([\mathbf{H_{d}}(n;N)]_{ij}\) is the probability of finding the system in state \(\{j\); \(n-1\); \(N\}\), given that the queue at \(S_{1}\) has reached length \(n-1\) for the first time, after starting in state \(\{i\); \(n\); \(N\}\). 

Next look at Figure 4.5.5. This diagram is similar to Figure 4.5.1, but here the wavy lines go from higher to lower \(n\). It also includes the possibilities when all customers are already at \(S_{1}\) [\(n=N\)]. Clearly, if all customers are at \(S_{1}\), the next event must be there, and either the customer in service stays in \(S_{1},[\mathbf{P}]\), and then eventually leaves \([\mathbf{H_{d}}(N;N)]\), or leaves directly, and is replaced by the next customer \([\mathbf{q^{\prime}p}]\). Thus

\[\mathbf{H_{d}}(N;N)=\mathbf{P}\mathbf{H_{d}}(N;N)+\mathbf{q^{\prime}p}.\]

Now solve for \(\mathbf{H_{d}}(N;N)\) to get, using (3.1.1b):

\[\mathbf{H_{d}}(N;N)=(\mathbf{I}-\mathbf{P})^{-1}\mathbf{q^{\prime}p}= \boldsymbol{\epsilon^{\prime}}p=\mathbf{Q},\] (4.5.9a) as expected. For any other \[n>0\] (we drop the \[\mathbf{d}\] for now), Figure 4.5.5 implies that \[\mathbf{H}(n;N) =(\lambda\mathbf{I}+\mathbf{M})^{-1

<!-- Pages 285-285 -->

**Definition 4.5.9**: \(t_{d}(n;N):=\) _mean first-passage time from n to n-1._ This is the mean time it will take for the queue at \(S_{1}\) to drop to \(n-1\) for the first time, given that it started with queue length \(n\) and the active customer had just begun service. The "given" part can also be worded as "given that a customer has just departed, leaving \(n\) customers behind." Implicit in this is the assumption that the queue can never exceed \(N\). \({}_{\blacksquare}\)

From its definition, it follows that

\[t_{d}(n;N):=\mathbf{pr^{\prime}_{d}}(n;N)=\frac{1}{\lambda}\left[\Psi\left[ \mathbf{K}(N-n+1)\right]-1\right]\]

\[=\frac{1}{\lambda}\left[\frac{1}{r(0;N-n+1)}-1\right]=\frac{1-r(0;N-n+1)}{ \lambda\,r(0;N-n+1)}\;. \tag{4.5.13}\]

This is a rather interesting result. It says, in words, that the mean time to go from \(n\) to \(n-1\) for the first time in an M/G/1//\(N\) queue \([t_{d}(n,N)]\), can be expressed in terms of properties of the steady-state M/G/1//\((N-n+1)\) queue with the same \(\rho\). It is equal to \(1/\lambda\) times the ratio of the steady-state probability that \(S_{1}\) would be busy to the probability that it would be idle. Furthermore, as long as \(N\) is finite, it is true for all \(\rho\).

Of particular interest is the case where \(n=1\), for that corresponds to the mean time of a busy period of an M/G/1//\(N\) loop. This was discussed in the first part of Section 2.3.2 in the context of the M/M/1//\(N\) loop, but now we have a more general theorem for M/G/1 queues. First,

\[\mathbf{\tau^{\prime}_{d}}(1;N)=\frac{1}{\lambda}[\mathbf{K}(N)-\mathbf{I}] \mathbf{\epsilon^{\prime}},\] (4.5.14a) then we get an expression that is valid for any G/G/12 queue: \[t_{d}(1;N)=\frac{1}{\lambda}\frac{1-r(0;N)}{r(0;N)}=\frac{1}{\lambda}\frac{s.s.\;prob.\;that\;S_{1}\;is\;busy}{s.s.\;prob.\;that\;S_{1}\;is\;idle}\;. \tag{4.5.14b}\]

The rightmost expression does not explicitly depend upon \(N\). It shows that the ratio of probabilities is the expected number of customers who will be served in a busy period. We proved this formula in (2.3.7d), but in a different way.

Footnote 2: The expression, 'GI/G/1' is also commonly used, where 'GI' stands for _General Independent_. Unless otherwise stated, we assume that the arrivals are independent (they constitute a renewal process), so we usually use 'G' in this book.

The \(k\)-busy period for the M/G/1//\(N\) loop requires some extra explanation beyond that given in Definition 2.3.4, because we must define the starting state.

**Definition 4.5.10**: \(t(k\to 0;N)=\) _mean time for the k-busy period of an M/G/1//\(N\) loop._

This is the mean time for the queue at \(S_{1}\) to drain (drop to 0) given that there were \(k\) customers there initially, and the one in service had just begun.

<!-- Pages 287-287 -->

**Definition 4.5.11**.: \(\mathbf{W_{u}}(n;k):=\) _probability matrix that the queue will go from \(n\) to \(n+1\) without dropping to \(k\). \(\mathbf{W_{u}}(n;k)\)_ assumes the following initial conditions. Given an M/ME/1//\(N\) loop, there are \(n<N\) customers at \(S_{1}\), and the active customer is at phase \(i\). The process ends when either the queue grows to \(n+1\), or shrinks to \(k<n\). If it is the former, then \([\mathbf{W_{u}}(n;k)]_{ij}\) is the probability that the system will be in state \(\{j;\,n+1;\,N\}\).

In other words, \([\mathbf{W_{u}}(n;\,k)]_{ij}\) is the probability that the system will go from \(\{i;\,n;\,N\}\) to \(\{j;\,n+1;\,N\}\) for some (any) \(j\) without going to \(\{\cdot\,,\,k;\,N\}\). Component \(i\) of vector \(\mathbf{W_{u}}(n;k)\boldsymbol{\epsilon^{\prime}}\) is the probability of going from \(\{i;\,n;\,N\}\) to any internal state of \(n+1\) customers, without dropping to \(k\). But this process is not certain to happen, so it cannot have probability \(1\), thus \(\mathbf{W_{u}}(n;k)\) is not isometric.

This process, and in fact all first-passage processes, fall into the class of _taboo processes_ (or _tabu processes_). For such processes, the entire state space of the system is partitioned into three (disjoint) subsets. The process begins with the system in a single state in one of the subsets, and ends when the system finds itself in any one of the states of the other two subsets. In our case, subset \(1\) consists of all internal states corresponding to queue lengths of \(k+1\), \(k+2\), \(\ldots\), \(n-1\), and \(n\), whereas subset \(2\) is all the states with queue length \(<k\). Subset \(3\) consists of all the states with queue length \(>n\). It is "tabu' to enter subset \(3\), and the process is a success if it ends in subset \(2\). The initial state is \(\{i;\,n;\,N\}\), which is an element of subset \(1\). This concept is much broader than we need. In fact, it obscures the underlying view in LAQT, that all internal states belonging to one queue length should always be treated as a whole.

There is a natural scalar that goes with matrix \(\mathbf{W_{u}}(n;k)\), which we now define.

**Definition 4.5.12**.: \(W_{u}(n;k):=\) _probability that the queue at \(S_{1}\) will rise from \(n\) to \(n+1\) without first dropping to \(k\), given that the active customer has just begun service._ We call this "the scalar probability associated with \(\mathbf{W_{u}}(n;k)\)."

From its definition it is clear that

\[W_{u}(n;k):=\mathbf{p}\mathbf{W_{u}}(n;k)\boldsymbol{\epsilon^{\prime}}=\Psi \left[\mathbf{W_{u}}(n;k)\right]. \tag{4.5.17}\]

Each of the \(\mathbf{W}\) matrices we presently introduce has an analogous \(W\) scalar counterpart.

Fortunately, Figure 4.5.1 is applicable to deriving the relationships among the \(\mathbf{W_{u}}(n;k)\)s. First look at \(\mathbf{W_{u}}(k+1;k)\). \([\mathbf{W_{u}}(k;k)\) must be \(\mathbf{0}\), because the system is already at its lower bound.] There are two successful paths available in this case. Either an arrival occurs, putting the system in state \(\{i;\,n+1\}\) immediately, or there is an internal transition, after which the queue eventually rises to \(n+1\) without ever having a departure. Thus

\[\mathbf{W_{u}}(k+1;k)=\lambda(\lambda\mathbf{I}+\mathbf{M})^{-1}+(\lambda \mathbf{I}+\mathbf{M})^{-1}\mathbf{MPW_{u}}(k+1;k).\]

<!-- Pages 288-288 -->

Multiply by \((\lambda\mathbf{I}+\mathbf{M})\), collect terms, and get

\[\mathbf{W}_{\mathbf{u}}(k+1;k)=\left(\mathbf{I}+\frac{1}{\lambda}\mathbf{B} \right)^{-1}=\lambda(\lambda\mathbf{I}+\mathbf{B})^{-1}. \tag{4.5.18a}\]

We are now ready to treat the general case. Here all three types of events can occur, because the queue at \(S_{1}\) can drop by \(1\) and still go back up. We write, for \(n>k+1\) (while momentarily dropping the subscript \(\mathbf{u}\)),

\[\mathbf{W}(n;k) =\lambda(\lambda\mathbf{I}+\mathbf{M})^{-1}+(\lambda\mathbf{I}+ \mathbf{M})^{-1}\mathbf{MP}\mathbf{W}(n;k)\] \[+\]

The usual manipulations lead to the following recursive formulas. For fixed \(k\), and \(n>k+1\),

\[\mathbf{W}_{\mathbf{u}}(n;k)=\lambda\left[\lambda\mathbf{I}+\mathbf{B}- \mathbf{BQ}\mathbf{W}_{\mathbf{u}}(n-1;k)\right]^{-1}. \tag{4.5.18b}\]

So, for instance,

\[\mathbf{W}_{\mathbf{u}}(k+2;k)=\lambda\left[\lambda\mathbf{I}+\mathbf{B}- \mathbf{BQ}(\lambda\mathbf{I}+\mathbf{B})^{-1}\right]^{-1}.\]

A comparison of (4.5.18b) with (4.5.2b) shows that \(\mathbf{W}_{\mathbf{u}}(n;k)\) and \(\mathbf{H}_{\mathbf{u}}(n)\) satisfy the same recursive formula, yet they are not equal. In particular, \(\mathbf{W}_{\mathbf{u}}(n;k)\) is not isometric, even though \(\mathbf{H}_{\mathbf{u}}(n)\) is. This apparent dilemma is easily resolved when we recognize that the two sets of matrices have different first matrices in their recursive construction, Equations (4.5.2e) and (4.5.18a). Recall that we proved by induction that \(\mathbf{H}_{\mathbf{u}}(n)\) is isometric. First we showed that \(\mathbf{H}_{\mathbf{u}}(0)\boldsymbol{\epsilon}^{\prime}=\boldsymbol{\epsilon}^ {\prime}\), and second, showed that if it was true for \(\mathbf{H}_{\mathbf{u}}(n)\), then it must be true for \(\mathbf{H}_{\mathbf{u}}(n+1)\). We could show the second part of the proof for \(\mathbf{W}_{\mathbf{u}}(n;k)\), but we cannot satisfy the first condition. For \(\mathbf{W}_{\mathbf{u}}(k+1;k)

<!-- Pages 291-291 -->

**Example 4.5.4:** We have calculated \(W_{u}(1\to n)\) for the M/\(E_{2}\)/1 queue and have plotted the results as a function of \(n\), for various values of \(\rho\), in Figure 4.5.6. We see that if \(\rho\leq 1\), the probability goes to 0 as \(n\) increases, but for \(\rho>1\), \(W_{u}(1\to n)\) asymptotically approaches a value greater than 0. This value is the probability that the busy period will never end. We have also bothered to compare with the M/M/1 queue, as given by Equations (2.3.11) in Figure 4.5.7. Note that for \(\rho<1\) the two queues have similar behavior, but they do cross. For larger \(n\), the M/M/1 queue has a slightly higher probability of growing longer. We would expect this, because the mean queue length for the steady-state M/M/1 queue is longer than that for the M/\(E_{2}\)/1 queue. One should not draw any conclusions about this without first studying other distributions.

An unexpected result shows up when \(\rho\) is greater than 1. In that case, the open M/ME/1 system can never reach a steady state. We know from (2.3.11c) that the probability that the busy period will never end is \(1-1/\rho\) for the M/M/1 queue, which for \(\rho=1.5\) is 0.3333, the asymptotic value of that curve. However, for the M/\(E_{2}\)/1 queue the asymptotic value is approximately 0.42, or over 30% higher! This seems to be counterintuitive (if one can have intuition about these things), but after some thought we give the following explanation.

Figure 4.5.6: Probability \(W_{u}(1\to n)\) that the number of customers at an M/\(E_{2}\)/1 queue will rise to at least \(n\) during a busy period versus \(n\), for \(\rho=\)0.5, 0.9, 1.0, 1.5, and 2.0. Obviously, the probability that it will reach at least length one, is 1, for all \(\rho\). For \(\rho>1\) there is a finite probability that the queue will grow forever (if you can find an infinite number of customers). The larger \(\rho\) is, the larger that probability.

<!-- Pages 292-292 -->

First note that in the D/D/1 queue there is never any waiting when \(\rho\) is less than 1, but there is no chance whatever that the busy period will end when \(\rho\) is greater than 1. In these examples, when \(\rho\) is greater than 1, the probability that the queue will drain becomes vanishingly small as the queue length increases, hence the rapid approach to the asymptotic value for both distributions (once the queue reaches 10, for \(\rho=1.5\), there is no hope that it will ever drain). Therefore, it is only for short queues that there is some reasonable probability of dropping to 0. For this to happen, the customers who are in the queue must put a smaller demand on the server than is average. Now, the probability that a given customer will make a demand that is far below the mean is much less for Erlangian distributed service times than it is for exponential service times. Therefore, it is less likely to drain.

Consider the other extreme. We can construct distributions in which the vast majority of customers ask for a negligible amount of service time, but once in a while a customer with an enormous demand arrives. In such a case, the probability that the queue will contain only customers with small demands is close to 1, and therefore the queue will probably drain. 

In the next example we study the busy period behavior for various distributions, but only for \(\rho=1.5\).

**Example 4.5.5:** In Figure 4.5.8 we show \(W_{u}(1\to n)\) for various Erlangians up to \(E_{30}(x)\), as well as a hyperexponential-2 distribution with \(C_{v}^{2}=5.039\)

Figure 4.5.7: **Comparison of the probability \(W_{u}(1\to n)\) between the M/M/1 and M/\(E_{2}\)/1 queues versus \(n\)**, for \(\rho=\)0.5, 0.9, and 1.5. The curves for the \(E_{2}\) queue are the same as those in Figure 4.5.6. For \(\rho<1\) the two curves are close for all \(n\), but for \(\rho=1.5\), the two differ by over 30%. See the text and Figure 4.5.8 for more information.

<!-- Pages 293-293 -->

All distributions have a mean of 1. These results are consistent with our arguments in this and the preceding paragraph. The \(H_{2}(x)\) function is of the type in which 90% of the customers have small demands. This is connected to \(C_{v}^{2}\), but is not completely dependent on it. So we can only hazard a general statement which says that the probability that the busy period will end tends to increase with \(C_{v}^{2}\). Indeed, the Erlangians have \(C_{v}^{2}=1/n\); thus all the curves we present in this figure satisfy the rule. \(\blacktriangle\)

The above examples lead us to the following observation. The P-K formula in (4.2.6d) tells us that for \(\rho<1\) the bigger \(C_{v}^{2}\) is, the more likely it is for the queue to grow very large (big jobs kill). The example tells us that for \(\rho>1\), the bigger \(C_{v}^{2}\) is, the more likely it will be for the busy period to end (small jobs save). Remember, large \(C_{v}^{2}\) implies the occurrence of jobs that are much bigger than the mean. But to compensate for this, there must also be more jobs that are much smaller than the mean. We warn the reader that this is only a speculation, and the subject requires further study.

Very little research has been done on these equations, thus we know of no explicit formulas for the various \(\mathbf{W}\) matrices except for the M/M/1 queue. Surely with some effort, such expressions will be forthcoming. In the meantime, we continue deriving yet more equations, which might leave the reader

Figure 4.5.8: Probability that the population at \(S_{1}\) in an M/ME/1 queue will rise to at least \(n\) during a busy period, for the exponential, four different Erlangians, and a hyperexponential-2 distribution. Erlangians have a squared coefficient of variation, \(C_{v}^{2}=1/n\), and the hyperexponential function has a \(C_{v}^{2}=5.039\). All have a mean service time of 1, and \(\rho=1.5\). These curves satisfy the rule that the probability for the busy period to end, [\(1-W_{u}(1\to\infty)\)], increases with \(C_{v}^{2}\).

<!-- Pages 296-296 -->

We also have

\[\mathbf{w}_{\mathbf{d}}^{\prime}(1;N)=\mathbf{w}_{\mathbf{d}}^{\prime}(N\to 0)= \boldsymbol{\epsilon}^{\prime}. \tag{4.5.25b}\]

Note that these equations are for \(n=1\) only, because that is the only time the empty queue is reached.

To go from the artificial to the real convention, one merely right-multiplies with \(\boldsymbol{\epsilon}^{\prime}\) (\(\mathbf{Q}\,\boldsymbol{\epsilon}^{\prime}=\boldsymbol{\epsilon}^{\prime}\)). For instance,

\[\mathbf{w}_{\mathbf{d}}^{\prime}(1;k)=\mathbf{W}_{\mathbf{d}}(1;k)\boldsymbol {\epsilon}^{\prime},\]

and conversely,

\[\mathbf{W}_{\mathbf{d}}(1;k)=\mathbf{w}_{\mathbf{d}}^{\prime}(1;k)\mathbf{p}.\]

The distinction between the vector and matrix objects becomes meaningful when the arrival process is not Poisson, for then, even when the queue is empty, the arrival process is in some state. We show this in Chapter 5.

Equation (4.5.24a) simplifies considerably when Equations (4.5.23) are substituted into it, for now we have (using the real convention)

\[\mathbf{w}_{\mathbf{d}}^{\prime}(k\to 0)=\mathbf{Z}(0)\mathbf{Q}\,\mathbf{Z}(1) \cdots\mathbf{Q}\,\mathbf{Z}(k-1)\boldsymbol{\epsilon}^{\prime}\quad\text{for }\;k<N.\]

But recall from Lemma 3.5.1 that \(\mathbf{Q}^{2}=\mathbf{Q}\), and for any square matrix, \(\mathbf{D},\mathbf{QDQ}=\Psi\left[\mathbf{D}\right]\mathbf{Q}\). Also note that \(\Psi\left[\mathbf{DQ}\right]=\Psi\left[\mathbf{QD}\right]=\Psi\left[\mathbf{D}\right]\), so

\[W_{d}(n;k)=Z(k-n):=\Psi\left[\mathbf{W}_{\mathbf{d}}(n;k)\right]=\Psi\left[ \mathbf{Z}(k-n)\right].\] (4.5.26a) All this leads to, for \[k<N\], \[\mathbf{w}_{\mathbf{d}}^{\prime}(k\to 0)=\left[Z(1)\,Z(2)\,\cdots\,Z(k-1) \right](\mathbf{I}+\lambda\mathbf{V})^{-1}\boldsymbol{\epsilon}^{\prime},\] (4.5.26b) which is a vector.

The object in brackets is a product of scalars, and thus is itself a scalar, so the vectors \([\mathbf{w}_{\mathbf{d}}^{\prime}(k\to 0)\) for \(1\leq k<N]\) are all proportional to the same vector \(\mathbf{v}^{\prime}:=(\mathbf{I}+\lambda\mathbf{V})^{-1}\boldsymbol{\epsilon}^ {\prime}\). This vector is interesting in its own right, because from (3.1.10), it is the generator of the Laplace transform of \(S_{1}\) [i.e., \(\mathbf{p}\mathbf{v}^{\prime}=\mathbf{B}^{*}(\lambda)\)]. But what is more relevant to our discussion, is that \(\mathbf{p}\mathbf{v}^{\prime}\) is the probability that \(S_{1}\) will complete service before \(S_{2}\), given that they started at the same time! In fact, for any initial condition described by \(\mathbf{p}_{\mathbf{i}}\), \(\mathbf{p}_{\mathbf{i}}\mathbf{v}^{\prime}\) is the probability that \(S_{1}\) will finish before \(S_{2}\). Sometimes one wonders if the Laplace transform is a mathematical trick to divert us from getting a physical insight as to what is going on. D. G. Kendall [16] apparently shared this view in stating the desire of "... raising the Laplacian curtain which has hitherto obscured much of the queue-theoretic scene."

We see that (4.5.24) to (4.5.26) actually depend on \(N\) in an obvious but nontrivial way. We do not make the notation any more complicated than it is at present, because these matrices are of secondary importance to the last defined function of this chapter. It was actually defined in Section 2.3.2 for the M/M/1 queue. The same definition for the M/ME/1 //\(N\) queue suffices here as well. The object of interest is a scalar, because we both start and end with no one at \(S_{1}\). Define the following scalar.

<!-- Pages 299-299 -->

integer points must be 1, the two curves cross somewhere, and for large \(n\), the curve for \(E_{2}\) is higher. We give the same warning here as we did for the other curves. Although the two distributions yield similar results, one should look for other distributions that could give radically different results.

As a final comment, note that \(N=1\) is a trivial case, for then the queue will always grow to 1, and never grow further before the busy period ends. For \(N=2\), we have

\[W_{m}(1)=\Psi\left[\left(\mathbf{I}+\lambda\mathbf{V}\right)^{-1}\right]\]

and

\[W_{m}(2)=\lambda\Psi\left[\left(\lambda\mathbf{I}+\mathbf{B}\right)^{-1} \right].\]

The first equation, as we have noted before, is the probability that \(S_{1}\) will finish before \(S_{2}\), and of course, the second term is the probability that \(S_{2}\) will finish before \(S_{1}\). Their sum must be 1, which is easily shown by the following:

\[\left(\mathbf{I}+\lambda\mathbf{V}\right)^{-1}+\lambda\left(\lambda\mathbf{I }+\mathbf{B}\right)^{-1}=\left(\mathbf{I}+\lambda\mathbf{V}\right)^{-1}+ \lambda\mathbf{V}\left(\mathbf{I}+\lambda\mathbf{V}\right)^{-1}\]

\[=[\mathbf{I}+\lambda\mathbf{V}](\mathbf{I}+\lambda\mathbf{V})^{-1}=\mathbf{I},\]

followed by \(\Psi\left[\,\mathbf{I}\,\right]=1\).

Figure 4.5.9: **Probability \(W_{m}(n;20)\) as a function of \(n\), for both the M/M/1 and M/\(E_{2}\)/1 queues. Three sets of curves are shown, for \(\rho=0.5\), 0.9, and 1.5. The curves for the M/M/1 queue are the same as those in Figure 2.3.4 as long as \(n<20\). The value at \(n=20\) corresponds to the probability that the queue will exceed 19 during a busy period for any loop where \(N\geq 20\), so for \(\rho>1\) it is quite significant. Even for \(\rho=0.9\), this probability is not negligible. The sum over all integer points must be 1.**

<!-- Pages 300-300 -->

#### 4.5.4 Mean Time to Failure with Backup and Repair

Our emphasis so far has been on viewing customers as individuals who go around in circles demanding service, one at a time, from two different subsystems. An increasingly important application, with a completely different emphasis than we usually see in queueing theory texts, occurs in reliability theory, where one asks such questions as: "how long it will take before a subsystem has fewer functional components than is acceptable?" We are ready to set up the procedure by which such questions can be analyzed, using the material already discussed in this chapter. We are even prepared to solve many of the simpler problems, although the question of how one deals with multiple components functioning simultaneously must wait until Chapter 6. It is most important to note that the procedures we discuss now generalize directly once we have set up the structure for parallel processing.

Consider the following. Suppose that we have several identical appearing devices (terminals, computers, automobiles, VLSI chips, etc.). Once one of them is turned on, it continues to run until it fails (breaks down, or something). Assume that the lifetime of one of these devices is described by the function \(R_{1}(t)\). As you already know, this is the reliability function for \(S_{1}\), which is where the name came from. That is, \(R_{1}(t)\) is the probability that the device will still be functioning \(t\) units of time after it was first turned on, and \(b_{1}(t)=-R_{1}^{\prime}(t)\) is the pdf of the failure time. If only one device is available, the _Mean Time To Failure_ (MTTF) is the expected life of the device, namely,

\[T_{1}:=\int_{\mathrm{o}}^{\infty}t\,b_{1}(t)\,dt=\int_{\mathrm{o}}^{\infty}R(t )\,dt.\]

(It is easy to show, and is well known, that the two integrals are always equal.)

Let there now be several devices available, and as soon as the first one fails, a second one is started up. The second one is referred to as a _cold backup_ (cold, because it does not start up until the first one fails). If the first one is discarded, the pdf of the time until both have failed is the convolution of \(b_{1}(t)\) with itself, with an MTTF of \(2T_{1}\). Suppose, instead, that the broken one is immediately sent to the repair shop (with only one repairman), where the time it takes to fix it is distributed according to the pdf \(b_{2}(x)\). As soon as it is repaired, it is returned to the pool of available devices, as good as new [its reliability function \(R_{1}(t)\) is the same as it was the first time through]. The question to be answered is: "how long will it take to reach the unfortunate state where all the devices are in the repair shop?" Thus we have described the title of this section.

Let us call the process above, scheme (1). There are numerous variations that one can play on this scheme, some of which are: (2) failure occurs when only one (or in general, \(k\)) device(s) is (are) still functioning; (3) a backup must always be running, whether it is being used or not, even while the primary device is still functioning (hot backup, or parallel redundancy); and (4) the system has been running for some unknown time before questions are asked (residual times). Schemes (2) and (4) can be treated with material that we already have prepared in this chapter, but scheme (3) must wait until Chapter

<!-- Pages 301-301 -->

6 and the M/G/C//\(N\) queue.

By now it should be clear to the reader that if we let \(S_{1}\) represent \(b_{1}(t)\), and \(b_{2}(x)\) is exponentially distributed with mean \(1/\lambda\), then we are looking at an M/ME/1//\(N\) loop, where \(N\) is the total number of devices (i.e., \(N-1\) backups). Following scheme (1), suppose that initially all devices are functional, and one of them is started. Then the initial vector is \(\mathbf{p}\) itself. The MTTF in this circumstance is the same as the mean time for the \(N\)-busy period, \(t(N\to 0;N)\), as given in Definition 4.5.10. The _utilization parameter_\(\rho\) is less meaningful in this context. It is still \(\lambda T_{1}\), which is now the ratio of the mean lifetime to the mean repair time of a single device. We are not particularly interested in systems where \(\rho\) is close to 1, nor do open systems have much relevance (an infinite number of backups? Well, maybe in inventory problems where new parts are being manufactured continuously). Instead, we might expect \(\rho\) to be much greater than 1, because it usually takes much less time to repair a device than it did for it to break in the first place (retail commercial products such as children's toys excepted).

Let us first examine our equations for \(N=1\). Here repair time is of no significance (once you start falling, if you do not have a spare parachute, it is no use telling you that your failed parachute "can be mended in no time at all, after you land"), so as we said before, \(MTTF(1)=T_{1}\).

The case where \(N=2\) is most enlightening. As before, the mean time for the first one to fail is \(T_{1}\), but now the race is on to see if the first device can be repaired before the second one fails. According to (4.5.15),

\[MTTF(2)=t_{d}(1;2)+t_{d}(2;2).\]

But from (4.5.11a),

\[t_{d}(2;2)=\mathbf{p}\mathbf{r}_{\mathbf{d}}^{\prime}(2;2)=\mathbf{p}\mathbf{ V}\boldsymbol{\epsilon}^{\prime}=T_{1}\]

(of course), and from (4.5.12),

\[t_{d}(1;2)=\mathbf{p}\tau_{\mathbf{d}}^{\prime}(1;2)=\frac{1}{\lambda}\Psi \left[\mathbf{U}(\mathbf{I}+\lambda\mathbf{V})\right].\]

We played with expressions similar to this in Section 4.4.3. Look at (4.4.8b), where \(\mathbf{C}=\lambda\mathbf{V}\mathbf{D}=\mathbf{I}-\mathbf{D}\), \(\mathbf{D}=(\mathbf{I}+\lambda\mathbf{V})^{-1}\), \(\gamma_{1}=\Psi\left[\mathbf{C}\right]=1-\Psi\left[\mathbf{D}\right]\), and

\[\mathbf{p}\mathbf{U}(\mathbf{I}+\lambda\mathbf{V})=\frac{1}{1-\gamma_{1}} \mathbf{p}\mathbf{C}\mathbf{D}^{-1}=\lambda\Psi\left[\mathbf{D}\right]\, \mathbf{p}\mathbf{V}.\]

Therefore, \(t_{d}(1;2)=T_{1}/\Psi\left[\mathbf{D}\right]\), so

\[MTTF(2)=T_{1}\left(1+\frac{1}{\Psi\left[\mathbf{D}\right]}\right).\] (4.5.29a) As expected, the MTTF is proportional to the mean uptime of one device, but it also depends on the term \[1/\Psi\left[\mathbf{D}\right]\), which can be interpreted as the expected number of times the broken device will be repaired before the good one fails,

<!-- Pages 303-303 -->

We were able to find a convenient expression for \(MTTF(2)\), but for \(N>2\) it becomes more tedious. Because (4.5.12) is fairly simple, we now seek a general expression that is not recursive. From (4.5.12) and (4.5.13) we know that \(t_{d}(N-l;N)=\Psi\left[\mathbf{U}\mathbf{K}(l)\right]/\lambda\). Therefore from (4.5.15),

\[MTTF(N)=t(N\to 0;N)=\frac{1}{\lambda}\sum_{k=1}^{N}t_{d}(k;N)=\frac{1}{ \lambda}\sum_{k=1}^{N}\Psi\left[\mathbf{U}\mathbf{K}(N-k)\right].\]

Now let \(l=N-k\); then

\[MTTF(N)=\frac{1}{\lambda}\sum_{l=\mathrm{o}}^{N-1}\Psi\left[\mathbf{U} \mathbf{K}(l)\right].\] (4.5.30a) We actually have worked with something like this already, in Section 4.3.1. There, in (4.3.4b) we showed that (we have replaced \[N\] with \[l+1\] )

\[\mathbf{p}[\mathbf{K}(l+1)-\mathbf{I}]=\frac{1}{1-\rho}\left(1-\Psi\left[ \mathbf{U}^{l}\lambda\mathbf{V}\right]\right)\lambda\mathbf{p}\mathbf{V}.\]

But \(\mathbf{K}(l+1)-\mathbf{I}=\mathbf{U}\mathbf{K}(l)\), so if we postmultiply with \(\boldsymbol{\epsilon}^{\prime}\), we get

\[\Psi\left[\mathbf{U}\mathbf{K}(l)\right]=\frac{\rho}{1-\rho}\left(1-\lambda \Psi\left[\mathbf{U}^{l}\mathbf{V}\right]\right).\]

When this is placed in (4.5.30a), and we use the fact that [see (4.1.6f)]

\[\sum_{l=\mathrm{o}}^{N-1}\mathbf{U}^{l}=\mathbf{K}(\mathbf{I}-\mathbf{U}^{N}),\]

with \(\mathbf{K}=(\mathbf{I}-\mathbf{U})^{-1}\) [from (4.2.2a)], we get

\[MTTF(N)=\frac{1}{\lambda}\frac{\rho}{1-\rho}\left(N-\lambda\Psi\left[\sum_{l= \mathrm{o}}^{N-1}\mathbf{U}^{l}\mathbf{V}\right]\right)\]

\[=\frac{NT_{1}}{1-\rho}-\frac{\rho}{1-\rho}\Psi\left[\mathbf{K}(\mathbf{I}- \mathbf{U}^{N})\mathbf{V}\right].\]

Now, from its definition, we know that \(\mathbf{K}\mathbf{U}=\mathbf{K}-\mathbf{I}\), and by postmultiplying (4.2.3b) with \(\mathbf{U}\), we know that \(\mathbf{p}\mathbf{K}\mathbf{U}=[\lambda/(1-\rho)]\mathbf{p}\mathbf{V}\), so with some awkward manipulation, we get the following expression.

\[MTTF(N)=\frac{N-\rho}{1-\rho}T_{1}-\frac{\lambda}{1-\rho}\Psi\left[\mathbf{V} ^{2}\right]+\frac{\rho}{1-\rho}\Psi\left[\mathbf{K}\mathbf{U}^{N}\mathbf{V} \right]. \tag{4.5.30b}\]

This expression is deceptive in that it seems to be telling us that the MTTF depends on \(\Psi\left[\mathbf{V}^{2}\right]\), when it really does not, at least not for small \(N\). When \(N\) is small, the last term can be manipulated so that it cancels the middle term, as well as the dependence on \(1/(1-\rho)\), as can clearly be seen from the expressions we already derived for \(MTTF(1)\) and \(MTTF(2)\). However, it

<!-- Pages 304-304 -->

does tell us this much for \(\rho<1\). For then, \(\mathbf{U}^{N}\) gets to be negligibly small for large \(N\), and thus \(MTTF(N)\) grows as \(NT_{1}/(1-\rho)\). Anyway, either (4.5.30a) or (4.5.30b) can be used to calculate \(MTTF(N)\) in general.

From what we have seen in this section, there are unlimited variations one can pursue based on what has been done. We have already suggested a few. We elaborate further here. For instance, suppose that a system has \(N\) devices, and one has just failed, leaving behind \(k\) good ones. What is the \(MTTF\) then? The answer is \(t(k\to 0;N)\), from (4.5.15). But what if you, as the new manager have just arrived, and do not know when the last breakdown occurred; what is the \(MTTF\) then? You are the random observer, and the system was in state \(\boldsymbol{\pi_{\mathrm{r}}}(k)\) (see Corollary 4.5.2b) when you arrived. Thus the MTTF is the mean time to drop from \(k\) to \(k-1\), and thence to \(0\):

\[MTTF=\boldsymbol{\pi_{\mathrm{r}}}(k)\,\boldsymbol{\tau_{\mathrm{d}}^{\prime} }(k;\,N)+t(k-1\to 0;\,N).\]

Suppose, instead, that you must change your plans once you are down to your last device; what is the MTTF then? Just subtract \(t_{d}(1;N)\) from the above.

Now take a different viewpoint. What is the probability that the system will fail (down to your last device) before it ever gets back to full strength? Maybe you should quit now. This probability is given in Definition 4.5.17 and is

\[\boldsymbol{\pi_{\mathrm{r}}}(k)\,\mathbf{W_{d}}(k\to 1;N-1)\,\boldsymbol{ \epsilon^{\prime}}.\]

(Note the \(N-1\).) By definition, \(\mathbf{W_{d}}\) deals with _not exceeding_, while we are seeking the probability of _not reaching_. So we did find an additional use for the \(\mathbf{W_{d}}\) matrices.

The open system also has some application in this context. Suppose that instead of repairing devices, you go out and buy new ones when old ones break. There is an unlimited supply of these devices on the market, but it takes time to do this. If you work for a public university, the longest part of this task is getting the purchase order approved. Because of the uncertain delay, you try to have \(k\) devices on hand. The mean time until you run out of devices is given by the \(k\)-busy period, which for the M/G/1 system is [from (4.5.16b)]

\[\lim_{N\to\infty}t(k\to 0;N)=\frac{kT_{1}}{1-\rho}.\]

and so on and on and on.

We have seen an inkling of the power of LAQT in being able to separate the initial conditions from the transition period from the final result. Now what remains is for us to extend the procedure to include other, and more general systems, which we do in the following chapters.

<!-- Pages 305-305 -->

## Chapter 5 G/M/1 Queue

_Thou com'st in such a questionable shape._

Hamlet, Act I, Scene IV

_If we knew what we were doing, it wouldn't be called research, would it?_

Albert Einstein

In Chapter 4 we talked about a closed loop made up of two subsystems, \(S_{1}\) and \(S_{2}\), where each subsystem was equivalent to a matrix representation of some general distribution \(b_{i}(x)\). The notation for such a loop is \(G_{2}/G_{1}/1/\left/N\right.\), where the \(N\) stands for the number of customers in the loop. However, we only treated the case where \(G_{2}=M\) [i.e., \(b_{2}(x)\) is an exponential function]. In that case we found that an arriving customer would find \(n\) customers already in \(S_{1}\) with the same probability as he would leave \(n\) behind. Furthermore, we showed that except for the fact that \(d(N;N)=a(N;N)=0\), these probabilities are proportional to the random observer's probability of finding \(n\) customers there. We also argued that the "finite waiting room," M/G/1/\(N\) queue (i.e., where \(S_{1}\) could hold no more than \(N\) customers, thereby forcing all extra arrivals to disappear), yielded the same results as M/G/1/\(\left/N\right.\), by virtue of the memoryless property of \(S_{2}\). The behavior of the open M/G/1 system came easily (provided that the utilization parameter \(\rho\) was less than 1) by letting \(N\) become unboundedly large. In that case, given that \(S_{2}\) was the slower server, the probability that it would ever be idle went to zero. Then it became a "constant" source of customers to \(S_{1}\), with independent, exponentially distributed interarrival times, that is, a Poisson process. Finally, we showed that the three queue length probabilities, \(a(n)\), \(d(n)\), and \(r(n)\), are all equal.

In this chapter we turn things upside down by letting \(\rho\) be greater than 1. Now, \(S_{1}\) is the slower server, and in the limit as \(N\) goes to infinity, becomes a non-Poisson source of customers to \(S_{2}\), with interarrival times distributed according to \(b_{1}(x)\). We find that the limit, which yields the G/M/1 open queue (at \(S_{2}\)), does not come so easily, that the finite waiting room G/M/1/\(N\) does not give the same results as the closed G/M/1//\(N\) loop, nor do the arriving or departing customers see the same thing as our random observer. The formulas are sufficiently simple that we can hope to gain physical insight into the behavior of steady-state queues generally.

<!-- Pages 306-306 -->

This subject has been covered in many monographs. For instance, Kleinrock [14] gives a classic solution of the G/M/1 queue that is in the same form as our scalar solution. Cohen [15] covers many aspects of the subject, and Ross [13] provides an alternate approach using renewal theory. The formulas given here extend the results in [11] and [12].

### Steady-State Open ME/M/1 Queue

We make considerable use of the equations of Chapter 4. Therefore are forced to retain the definition of \(\rho\) as \(\lambda\bar{x}\), which could also be written as \(\bar{x}_{1}/\bar{x}_{2}\), because \(1/\lambda=\bar{x}_{2}\). Clearly, as we show presently, the utilization of \(S_{2}\) in an open G/M/1 queue is given by \(\bar{x}_{2}/\bar{x}_{1}\), which is \(1/\rho\). One must remember to replace \(\rho\) by \(1/\rho\) when comparing formulas given in this chapter to those given in the general literature. To emphasize this difference, we here use the symbol \(\varrho\) (\(\mathtt{v}\mathtt{r}\mathtt{r}\mathtt{r}\mathtt{o}\) in \(\mathtt{E}\mathtt{T}\mathtt{E}\mathtt{X}\)) as the _utilization parameter_. That is,

\[\varrho:=\frac{1}{\rho}=\frac{\bar{x}_{2}}{\bar{x}_{1}}.\]

We have to make some other notational changes; the first, referring to \(\{\,\cdot\,;\,\cdot\,\}\), we give now.

_Definition 5.1.1_.:

\(\{i;\,k;\,N\}\) _describes the state of the system, where N is the total number of customers in the system, \(k\) is the number of customers at \(S_{2}\)_(_therefore there are \(N-k\) customers at \(S_{1}\)_), and \(i\) is the phase in \(S_{1}\) that is busy_. We might say that \(i\in\Xi\) is an _internal state_ of the system, and that \(\{k;\,N\}\) is an _external state_ of the system. 

The only change in notation from Section 4.1.1 is that now \(k\) stands for the number of customers at \(S_{2}\), rather than \(S_{1}\). This the notation used throughout this chapter.

Rather than introduce a collection of new notations, we modify previous symbols. For instance, the \(\mathbf{d}(n;N)\) of Chapter 4 (the vector probability that a customer will leave \(n\) customers behind when departing \(S_{1}\)) is now written as \(\mathbf{d}_{1}(n;N)\), and we make three new definitions.

_Definition 5.1.2_.:

\(\mathbf{d}_{2}(k;N):=\) _steady-state vector probability that a customer will leave \(k\) customers behind when departing \(S_{2}\)_. Given that a customer has just left \(S_{2}\) in an ME/M/1/\(N\) loop with nothing else known (another viewpoint of the steady state), \([\mathbf{d}_{2}(k;N)]_{i}\) is the probability that \(k\) customers are still at \(S_{2}\), and the active customer at \(S_{1}\) is at phase \(i\). \(d_{2}(k;N):=\mathbf{d}_{2}(k;N)\boldsymbol{\epsilon}^{\prime}\) is the steady-state scalar probability that a customer will leave \(k\) customers behind when departing \(S_{2}\). 

We also say that this is the probability that the system will be in state \(\{i;\,k;\,N\}\) immediately after a departure from \(S_{2}\).

<!-- Pages 307-307 -->

**Definition 5.1.3**: \(\mathbf{a_{2}}(k;N):=\)steady-state vector probability that a customer, upon arriving at \(S_{2}\), will find k customers already there. \([\mathbf{a_{2}}(k;N)]_{i}\) is the probability that there are now \(k+1\) customers at \(S_{2}\), and the active customer in \(S_{1}\) is at phase \(i\). \(a_{2}(k;N):=\mathbf{a_{2}}(k;N)\boldsymbol{\epsilon^{\prime}}\) is the associated scalar probability. 

We also say that this is the probability that the system will be in state \(\{i\); \(k+1\); \(N\}\) immediately after an arrival to \(S_{2}\).

**Definition 5.1.4**: \(\boldsymbol{\pi_{2}}(k;N):=\)steady-state vector probability that there are k customers at \(S_{2}\) in an \(\mathrm{ME/M/1}//\mathit{N}\,loop\). A random observer will find a long-running system in state \(\{i;\,k;\,N\}\) with probability \([\boldsymbol{\pi_{2}}(k;N)]_{i}\). \(r_{2}(k;\,N):=\boldsymbol{\pi_{2}}(k;\,N)\boldsymbol{\epsilon^{\prime}}\) is the associated scalar probability. 

As long as we have a closed system (i.e., \(N\) is finite), an arrival to one queue corresponds exactly to a departure from the other queue, so for \(n+k=N\), we have the following theorem:

**Theorem 5.1.1** The steady-state vector probabilities for the \(G/M/1//N\) queue follow directly from Equations (4.1.6) and Theorem 4.1.4, and are given by:

\[\mathbf{a_{2}}(k;N)=\mathbf{d_{1}}(n-1;N)=c(N)\Psi[\mathbf{U}^{N\!\!-\!k\!-\!1} ]\mathbf{p}, \tag{5.1.1a}\] \[\mathbf{d_{2}}(k;\,\,N)=\mathbf{a_{1}}(n-1;N)=c(N)\mathbf{p}\,\mathbf{U}^{N\!\!-\! k\!-\!1},\] (5.1.1b) \[\mathbf{d_{2}}(N;\,\,N)=\mathbf{a_{2}}(N;N)=\mathbf{o}, \tag{5.1.1c}\]

where \(0\leq k<N\), and

\[1/c(N)=\left[1-r_{1}(N;N)\right]=\Psi[\mathbf

<!-- Pages 308-308 -->

sticky when \(\varrho<1\) (or when \(\rho>1\)) and we go to the open system (\(N\to\infty\)), for then we would like to think that \(S_{1}\) has somehow disappeared, and the arriving customers are of their own volition select their interarrival times from some nonexponential distribution. Conceptually, it is more useful to view \(S_{1}\) as being _upstream_ from \(S_{2}\), with an inexhaustible supply of customers trying to get through its gates, one at a time, of course. In any case the events at \(S_{1}\) have no inflence on what happens at \(S_{2}\).

It would seem that this notational change is unnecessary, and indeed it is, but only as long as we are dealing with a closed system. In Chapter 4, with \(\rho<1\), we let \(N\) go to infinity, holding \(n\) constant. In this chapter, with \(1/\rho=\varrho<1\), we want to let \(N\) go to infinity, holding \(k\) constant. This subtle difference is best handled by our change of notation. Note that under these conditions, with \(n\) fixed, \(\mathbf{d_{1}}(n;N)\), \(\mathbf{a_{1}}(n;N)\), \(r_{1}(n;N)\), and \(\boldsymbol{\pi_{1}}(n;N)\) all go to \(0\) as \(N\) increases to infinity, just as \(\mathbf{d_{1}}(N\!-\!n;N)\), and so on did when \(\rho\) was less than \(1\).

#### 5.1.1 Steady-State Probabilities of the G/M/1 Queue

We can see from (4.2.2a) and (4.2.2b) that \(\mathbf{K}\) exists whether \(\rho\) is greater than or less than \(1\) (it only lacks definition when \(\rho=1\), in which case neither the M/G/1 nor the G/M/1 queue has a steady-state solution). The problem is that when \(\rho>1\), the limit of \(\mathbf{K}(N)\) [Equation (4.2.4c)] does not exist! We must be more careful in taking the limit. Let \(\{s_{i}\}\) be the set of eigenvalues of \(\mathbf{A}\), where \(\{\mathbf{u_{i}}\}\), and \(\{\mathbf{v^{\prime}_{i}}\}\) are the sets of left and right eigenvectors of \(\mathbf{A}\), respectively. Define \(s\) to be the eigenvalue of smallest magnitude, with corresponding eigenvectors \(\mathbf{u}\) and \(\mathbf{v^{\prime}}\). That is,

\[|s|=\min_{i=1}^{m}|s_{i}|.\]

For simplicity, assume that the eigenvalues are distinct (although what follows only needs the fact (known from other sources) that \(s\) is unique, positive, and less than \(1\)). Then from the spectral decomposition theorem [Equation (1.3.8a)],

\[\mathbf{A}=\sum_{i=1}^{m}s_{i}\mathbf{v^{\prime}_{i}}\mathbf{u_{i}},\]

so (recall that \(\mathbf{U}\) is the inverse of \(\mathbf{A}\))

\[\mathbf{U}^{N}=\sum_{i=1}^{m}\left(\frac{1}{s_{i}}\right)^{N}\mathbf{v^{ \prime}_{i}}\mathbf{u_{i}}.\] (5.1.2a) Then it follows that \[s^{N}\mathbf{U}^{N}=\mathbf{v^{\prime}}\,\mathbf{u}+\sum_{i^{*}=1}^{m}\left( \frac{s}{s_{i}}\right)^{N}\mathbf{v^{\prime}_{i}}\,\mathbf{u_{i}},\] (5.1.2b) where \[i^{*}\] stands for all terms excluding the term that corresponds to \[s\]. The limit is now straightforward, because \[|s\,/\,s_{i}|\] is less than \[1\] for all \[i\], \[\lim_{N\to\infty}s^{N}\mathbf{U}^{N}=\mathbf{v^{\prime}}\mathbf{u}. \tag{5.1.2c}\]

<!-- Pages 311-311 -->

(5.1.5d) it is known as the _geometric parameter_ for the G/M/1 queue. The mean queue length \(\bar{q}_{2}\) and mean system time \(\mbox{\sf E}\hskip-0.5pt\mbox{\sf E}[T_{2}]\) are given below in Equations (5.1.7). \(\blacksquare\)

**Proof:** Note from (4.2.3a) that \(\lambda\mbox{\bf AV}\mathbf{\epsilon^{\prime}}=(1-\rho)\mbox{\bf K} \mathbf{\epsilon^{\prime}}\), so on premultiplying by \(\hat{\bf u}\) and rearranging,

\[\hat{\bf u}\mbox{\bf V}\mathbf{\epsilon^{\prime}}=\frac{1-\varrho}{(1 -s)\varrho\lambda}\cdot \tag{5.1.5e}\]

The rest follows directly. \(\hskip 0.0pt\mbox{\bf QED}\)

So the probabilities are geometrically distributed, just as in the M/M/1 queue, but with \(s\) instead of \(\varrho\). Also, \(r_{2}(0)\) does not satisfy the general expression but is what it should be, namely 1 minus the utilization \([\varrho]\) of \(S_{2}\).

This well-known result is simple in form but is deceptively complicated in that the dependence of \(s\) on \(\varrho\) is not easy to get in general. Only when \(b_{1}(x)\) is exponentially distributed does \(s=\varrho\). It is known from other sources that \(s\) satisfies the following implicit relation. We state it as a corollary to Theorem 5.1.2 and prove it by purely algebraic means.

**Corollary 5.1.2**: The eigenvalue \(s\) is the smallest positive root of the following implicit equation,

\[\Psi\left[(\mbox{\bf I}+(1-s)\lambda\mbox{\bf V})^{-1}\right]=B^{*}[\lambda(1- s)]=s,\] (5.1.6a) where \[B^{*}(\cdot)\] is the Laplace transform of \[b_{1}(x)\], the pdf of \[S_{1}\] (the interarrival time distribution). The associated eigenvector satisfies the equation \[\hat{\bf u}=\lambda\mbox{\bf p}\mbox{\bf V}\left(\mbox{\bf I}+\lambda(1-s) \mbox{\bf V}\right)^{-1}. \tag{5.1.6b}\]

\(\blacksquare\)

**Proof:** First we prove (5.1.6b). From its definition,

\[\hat{\bf u}\mbox{\bf A}=s\hat{\bf u}=\hat{\bf u}\left(\mbox{\bf I}+\frac{1}{ \lambda}\mbox{\bf B}-\mbox{\bf Q}\right)=\hat{\bf u}+\frac{1}{\lambda}\hat{ \bf u}\mbox{\bf B}-\mbox{\bf p}.\]

We have used the fact that \(\hat{\bf u}\mbox{\bf Q}=\hat{\bf u}\mathbf{\epsilon^{\prime}}\mbox{ \bf p}=\mbox{\bf p}\). Next separate all terms that contain \(\hat{\bf u}\) from those that do not.

\[\hat{\bf u}\left((1-s)\mbox{\bf I}+\frac{1}{\lambda}\mbox{\bf B}\right)= \mbox{\bf p}.\]

Now multiply both sides of the equation by \(\lambda\mbox{\bf V}\):

\[\hat{\bf u}\left[\mbox{\bf I}+\lambda(1-s)\mbox{\bf V}\right]=\lambda\mbox{ \bf p}\mbox{\bf V}. \tag{5.1.6c}\]

Multiplying both sides by the inverse of the matrix expression in large brackets yields (5.1.6b). Because \(\hat{\bf u}\mathbf{\epsilon^{\prime}}=1\), Equation (5.1.6a) follows

<!-- Pages 312-312 -->

after some manipulation, by multiplying (5.1.6b) on the right with the vector \(\boldsymbol{\epsilon^{\prime}}\), noting that

\[\lambda\mathbf{V}\left[\mathbf{I}+\lambda(1-s)\mathbf{V}\right]^{-1}=\frac{1}{1 -s}\left(\mathbf{I}-\left[\mathbf{I}+\lambda(1-s)\mathbf{V}\right]^{-1}\right).\]

Then, recalling (3.1.10), the matrix definition of the Laplace transform, the proof is completed. **QED**

It remains to verify that the probabilities sum to 1.

**Exercise 5.1.1:** Show that \(\sum_{k=0}^{\infty}r_{2}(k)=1\).

To find \(s\), one must either solve an eigenvalue problem, or find the smallest positive root of (5.1.6a). In either case, numerical techniques are usually required. Once \(s\) is known, (5.1.6b) gives us \(\hat{\mathbf{u}}\). As with many other objects we encounter in this book, \(\hat{\mathbf{u}}\) has more information in it than that for which it was derived. In particular, it contains information regarding the arrival of the next customer. We discuss this further in the next section, after deriving the departure probabilities.

**Exercise 5.1.2:** The vector probabilities must also satisfy a sum rule. If a random observer watches \(S_{1}\) without taking any notice of the number of customers at \(S_{2}\), she sees customers perpetually coming and going, or equivalently (if she doesn't distinguish one customer from another), a single customer leaving and immediately returning to \(S_{2}\), as described in Figure 3.5.3 with \(\alpha=1\). The steady-state vector for this process is given by Theorem 3.5.3a to be \(\boldsymbol{\pi_{\mathrm{r}}}\). Therefore, prove by algebraic manipulation that

\[\sum_{k=\mathrm{o}}^{\infty}\boldsymbol{\pi}_{2}(k)=\boldsymbol{\pi_{\mathrm{ r}}}=\frac{\mathbf{p}\mathbf{V}}{\mathbf{p}\,\mathbf{V}\boldsymbol{\epsilon^{ \prime}}}.\]

Use Theorem 5.1.2 and (5.1.5e).

We next find the mean queue length and system time. Because the \(r_{2}(k)\)s are of geometric form, it is just as easy to get the \(z\)-transform of \(\{r_{2}(k)\,|\,k\geq 0\}\) as it is to get \(\bar{q}_{2}\) directly. By definition,

\[Q_{2}(z)=\sum_{k=0}^{\infty}z^{k}\,r_{2}(k)=1-\varrho+\frac{(1-s)\varrho}{s} \sum_{k=1}^{\infty}(zs)^{k}=1-\varrho+\frac{(1-s)\varrho\,z}{1-zs}.\]

We rewrite this in the form

\[Q_{2}(z)=1+\frac{(z-1)\varrho}{1-zs}\;. \tag{5.1.7a}\]

<!-- Pages 313-313 -->

Obviously, \(Q_{2}(1)=1\), and the derivative evaluated at \(z=1\) yields the mean queue length,

\[\bar{q}_{2}=\left[\frac{d\,Q_{2}(z)}{dz}\right]_{z=1}=\frac{\varrho}{1-s}\;. \tag{5.1.7b}\]

As in Chapter 4 [Equation (4.2.6e)], we use _Little's formula_ to get the mean system time (in this case, the arrival rate to \(S_{2}\) is \(1/\bar{x}_{1}\), and \(\bar{x}_{2}\) is \(1/\lambda\)),

\[\operatorname{\mathbb{E}}[T_{2}]=\bar{x}_{1}\bar{q}_{2}=\frac{\bar{x}_{2}}{1-s }=\frac{1/\lambda}{1-s}\;. \tag{5.1.7c}\]

Again, this formula looks very similar to (2.1.7b) for the M/M/1 queue, except that \(s\) appears instead of \(\varrho\). \(\operatorname{\mathbb{E}}[T_{2}]\) becomes unbounded when \(s\) approaches \(1\). The graph of (5.1.7c) for the D/M/1 queue was given in Figure 1.1.2, together with various M/G/1 queues.

It should be comforting to know that \(s/\varrho\) goes to \(1\) as \(\varrho\) approaches \(1\) from below. We explore the relation between \(\varrho\) and \(s\) further in Section 5.1.3.

**Exercise 5.1.3:** Verify that (5.1.7a) and (5.1.7b) are indeed true.

#### 5.1.2 Arrival and Departure Probabilities

The hard work has already been done in preparing to take the limit as \(N\) goes to infinity of the arrival and departure probabilities. From Theorem 5.1.1 we have the following string of equalities.

\[\mathbf{a_{2}}(k;N)=\mathbf{d_{1}}(N\!-\!k\!-\!1;N)=\frac{r_{1}(N\!-\!k\!-\!1; N)}{1-r_{1}(N;N)}\mathbf{p}=\frac{r_{2}(k\!+\!1;N)}{1-r_{2}(0;N)}\mathbf{p}.\]

We already found the limits of both numerator and denominator for the last expression, and they are each finite [Equations (5.1.5c) and (5.1.5d)], so

\[\mathbf{a_{2}}(k):=\lim_{N\to\infty}\mathbf{a_{2}}(k;N)=\frac{1}{1-(1-\varrho )}[\varrho(1-s)]s^{k}\mathbf{p}=(1-s)s^{k}\mathbf{p}.\] (5.1.8a) The scalar probabilities obviously satisfy

\[a_{2}(k)=(1-s)s^{k}. \tag{5.1.8b}\]

We point out that (5.1.8a) and (5.1.8b) are valid for all \(k\), even \(k=0\), which is not the case for \(r_{2}(k)\) and \(\operatorname{\boldsymbol{\pi_{2}}}(k)\). Also, note that (not merely at \(k=0\)) \(a_{2}(k)\) does not equal \(r_{2}(k)\), and \(\mathbf{a_{2}}(k)\) is not even parallel to \(\operatorname{\boldsymbol{\pi_{2}}}(k)!\) Well, it is not all that bad. After all \(a_{2}(k)\) (\(k\neq 0\)) is proportional to \(r_{2}(k)\) [i.e., \(a_{2}(k)=sr_{2}(k)/\varrho\), for all \(k\) greater than \(0\)].

The \(\mathbf{d_{2}}(k)\)s can be found in a manner identical to that for \(\mathbf{a_{2}}(k)\). From (5.1.1b) and (4.1.13a),

\[\mathbf{d_{2}}(k;N)=\frac{1}{1-r_{2}(0;N)}\operatorname{\boldsymbol{\pi_{2}}} (k\!+\!1;N).\]

<!-- Pages 314-314 -->

The limit follows directly. The different formulas are collected in the following theorem.

**Theorem 5.1.3**: The steady-state probabilities of queue lengths as seen by customers arriving to, and departing from an open ME/M/1 queue are given for all \(k\geq 0\) by [repeating Equation (5.1.8a)]

\[\mathbf{a_{2}}(k)=(1-s)s^{k}\mathbf{p}, \tag{5.1.9a}\]

\[\mathbf{d_{2}}(k)=(1-s)s^{k}\ddot{\mathbf{u}}, \tag{5.1.9b}\]

and

\[d_{2}(k)=a_{2}(k)=(1-s)s^{k}. \tag{5.1.9c}\]

Equation (5.1.9a) is so simple that we can immediately write down the probability that an arriving customer will find \(k\) or more customers already in the queue. That is,

\[P_{o2}:=\operatorname{\mathbbm{Pr}}(K\geq k)=\sum_{\ell=k}^{\infty}a_{2}(\ell )=s^{k}. \tag{5.1.9d}\]

As in previous chapters, this is also referred to as the _overflow probability_.

Thus we have shown for this simple system that except for the M/M/1 queue, \(\mathbf{a_{2}}(k)\), \(\mathbf{d_{2}}(k)\), and \(\boldsymbol{\pi_{2}}(k)\) are distinctly different. They are similar, but nonetheless different.

The form of (5.1.9c) is so familiar by now that one can truly say "it is obvious that" the sum of the \(a_{2}(k)\)s is 1, and the mean queue length seen by both a departing and an arriving customer is \(s/(1-s)\). Although the difference seems minor, it is important to recognize that this quantity is not equal to the mean queue length as seen by our random observer, \(\bar{q}_{2}\) [Equation (5.1.7b)]. As with the \(a_{2}(k)\) and \(r_{2}(k)\), they differ by the factor \(s/\varrho\). It is (5.1.7b) that one uses in Little's formula to get the mean system time, as we did in (5.1.7c). We now use \(a_{2}(k)\) to find \(\operatorname{\mathbbm{E}}[T_{2}]\) from its definition. Given that \(S_{2}\) is an exponential server, there is no distinction between its mean time and its residual time, so the care we had to take in Section 4.3.1 is not necessary here. If there are \(k\) customers at \(S_{2}\) (including none) when a customer arrives, he will have to wait an average of \((k+1)\bar{x}_{2}\) units of time before leaving. The mean time averaged over all queue lengths is

\[\operatorname{\mathbbm{E}}[T_{2}]=\sum_{k=0}^{\infty}a_{2}(k)(k+1)\bar{x}_{2} =(1-s)\bar{x}_{2}\sum_{k=0}^{\infty}(k+1)s^{k}\]

\[=\frac{(1-s)\bar{x}_{2}}{s}\sum_{k=1}^{\infty}ks^{k}=\frac{\bar{x}_{2}}{1-s},\]

the same as (5.1.7c). Our purpose here was to prepare the reader to derive the system time distribution.

<!-- Pages 315-315 -->

**Exercise 5.1.4:** In Exercises 2.1.7 through 2.1.9 we examined how and when one might improve service for an M/M/1 queue when the arrival rate gets too big. Here we look at one more simple possibility. Recall that for System (B) when a customer arrives at the dispatching point he is randomly sent to one or the other of the two queues (two M/M/1 queues, each with one half the arrival rate), but in System (C) the customers queue up at the dispatcher, and are later sent to the first available server (an M/M/2 queue). Consider the following dispatching procedure. When a customer arrives at the dispatching point he is immediately sent to the queue least recently visited. That is, customer 1 goes to server 1, customer 2 goes to server 2, customer 3 goes to server 1, and so on. What each queue sees is the arrival of customers separated by _two_ exponential intervals. In other words, the arrival process is an Erlangian-2 renewal process. Call this double \(E_{2}/M/1\) queue System (E). Redo Exercises 2.1.7 and 2.1.9 using System (E) and compare with Systems (A) through (D). You should find that \(T_{E}\) falls between \(T_{B}\) and \(T_{C}\).

The time for a customer to go through an exponential server \(k+1\) times, or equivalently, of \(k+1\) customers going through one at a time, is distributed according to the Erlangian-(\(k+1\)) distribution \([E_{k+1}(x;\lambda)]\) whose pdf is given in (3.2.1a), and is \(\lambda(\lambda x)^{k}e^{-\lambda x}/(k!)\). The weighted average over all \(k\) is, then,

\[b_{2s}(x):=\sum_{k=0}^{\infty}a_{2}(k)E_{k+1}(x;\lambda)=(1-s)\lambda\sum_{k=0 }^{\infty}s^{k}\frac{(\lambda x)^{k}}{k!}e^{-\lambda x}\]

\[=(1-s)\lambda\left(\sum_{k=0}^{\infty}\frac{(\lambda sx)^{k}}{k!}\right)e^{- \lambda x},\]

or finally,

\[b_{2s}(x)=(1-s)\lambda e^{-(1-s)\lambda\,x}. \tag{5.1.10}\]

So the system time is exponentially distributed, with mean time equal to \(1/[(1-s)\lambda]\) (but we already knew \(\mbox{\sf E}[T_{2}]\)).

#### 5.1.3 Properties of Geometric Parameter \(s\)

Theorem 5.1.2 showed us that the behavior of the G/M/1 queue is dominated by the geometric parameter \(s\). Even \(\hat{\bf u}\) can be evaluated from (5.1.6b) if we know \(s\). The value of \(s\) can be found from any one of the three equations: (1) (5.1.6a); (2) (3.1.10); or (3) \(\hat{\bf u}{\bf A}=s\hat{\bf u}\), by a root-finding or other numerical technique. That is, for a given arrival process, with interarrival times generated by \(\{\mbox{\bf p}\,,\,\mbox{\bf B}\}\), and given \(\lambda\), \(s\) is uniquely determined by any of these equations. The properties of \(s\) are best understood by thinking of it as a function of \(\lambda\), or \(\rho\), or better, \(\varrho\). How one should calculate numerical values for \(s\) is a matter of taste and numerical analysis and is by and large outside the interests of

<!-- Pages 317-317 -->

This form is about as good as we can get for the purposes we have in mind. In particular, we can see that when \(\varrho=0\), we must have \(s=0\), and if \(s=1\), \(\varrho\) must be 1 also. This is true for every G/M/1 queue, _except_ for those for which the interarrival time distributons are _defective_, or equivalently, have an _initial impulse_, which we now discuss.

**Defective Distributions**

Distributions with an initial impulse are those for which \(R(0)<1\), or equivalently, \(B(0)>0\). When a customer finally gets to be served, he decides with probability \(p=B(0)\) that he does not need any service. Such distributions are not uncommon. For instance, in reliability theory, this is the probability that a device will be faulty even though it is brand new, an important problem to worry about. Any distribution that has this property has a pdf of the form

\[b(x)=p\delta(x)+(1-p)b_{a}(x),\] (5.1.12a) where \[b_{a}(x)\] is the pdf of those devices that function properly initially [i.e., \[\int b_{a}(x)\,dx=1\] ], and \[\delta(x)\] is the _Dirac delta function_, which has these properties: \[\int_{-a}^{b}\delta(x)\,dx=1\quad\text{ for every }\ a,\ b>0,\] or \[f(0)=\int_{-\infty}^{\infty}f(x)\delta(x)\,dx\] for all \[f(x)\] which are continuous at \[x=0\], or \[f(t)=\int_{-\infty}^{\infty}f(x)\delta(x-t)\,dx.\] It can also be viewed as the derivative of the _unit step function_, which satisfies \[\Delta(t)=\int_{-\infty}^{t}\delta(x)\,dx\] \[\Delta(t)=\left\{\begin{array}{ccc}0&\text{if}&t<0\\ \frac{1}{2}&\text{if}&t=0\\ 1&\text{if}&t>0\end{array}\right..\] Pictorially think of \[\delta(x)\] as a spike of infinite height with unit area and 0 width, or the limit of a family of very high but very narrow functions. One such example was given in Example 3.2.1 as the limit of the set of Erlangian-\[k\] distributions with the same mean. There are other ways to look at it.

Anyway, we can also write

\[B(x)=p+(1-p)B_{a}(x) \tag{5.1.12b}\]

and

\[R(x)=(1-p)R_{a}(x). \tag{5.1.12c}\]

<!-- Pages 319-319 -->

Notice that this is equivalent to a _bulk arrival process_ (or _batch arrival process_) which is geometrically distributed; that is, given that an arrival has occurred, \((1-p)p^{j-1}\) is the probability that \(j\geq 1\) customers have arrived together (in bulk).

As a final comment, if \(b_{a}(x)\) is exponential, \(b(x)\) is often referred to as a _generalized exponential_, or _degenerate hyperexponential_ distribution, and has been used as a test function for studying the performance of various systems (see e.g., [10]). It is convenient to use because it only depends on two parameters and can have arbitrarily large variance. But its singular behavior at \(x=0\) can lead to spurious results. For further discussion see "Distributions Coming from Singular \(\mathbf{B}\) or \(\mathbf{V}\)" following Figure 3.2.4.

##### Behavior of \(s\) As a Function of \(\varrho\)

In Chapter 4 we saw that the mean system time and mean queue length for an M/G/1 queue depend on the factor \(1/(1-\rho)\). This was simple enough to visualize, but from (5.1.7c) for G/M/1 queues, the mean system time depends on the factor \(1/(1-s)\). To visualize this we must first find how \(s\) varies with \(\varrho\), which we now propose to do.

What we have discovered so far can best be summarized by Figure 5.1.1, where \(s\) is plotted as a function of \(\varrho\). We are examining several distributions here, therefore we use the notation \(s(\varrho;X)\), to indicate the dependence of \(s\) on \(\varrho\) for the distribution symbolized by \(X\). For the M/M/1 queue \([X=M]\), \(s(\varrho;M)=\varrho\), corresponding to the straight line from \((0,0)\) to \((1,1)\). If there is an initial impulse \([X=M_{p}]\), then \(s(0)=p\). The \(M_{p}\)/M/1 queue with initial impulse \(p\) corresponds to the straight line from \((0,p)\) to \((1,1)\), or \(s(\varrho;M_{p})=p+(1-p)\varrho\).

For general interarrival time distributions \([X=G]\), \(s(\varrho;G)\) also increases monotonically until it reaches \((1,1)\). We know that the larger \(s\) is, the longer will be the system time, from (5.1.7c). We also know that the system time can be reduced by regulating arrivals, and the most regular arrival pattern is the one where the time between arrivals is constant. In other words, the _deterministic distribution_\([X=D]\), given by

\[b_{D}(x)=\delta(x-T)\quad\text{or}\quad B_{D}(x)=\Delta(x-T),\]

should yield the smallest \(s\) for a given \(\varrho\). Said yet another way, the D/M/1 queue has the shortest mean system time among all G/M/1 queues with the same \(\varrho\). Unfortunately, there is no finite-dimensional representation of \(B_{D}(x)\); therefore we have to resort to (3.1.10) to find the dependence of \(s\) on \(\varrho\). From that equation (remembering that \(\lambda T=1/\varrho\)),

\[s=\int_{0}^{\infty}e^{-\lambda(1-s)x}\delta(x-T)\,dx=e^{-(1-s)/\varrho}. \tag{5.1.14c}\]

Notice that \(s=1\) is a solution to this equation for all \(\varrho\), but as we stated previously, this root has no physical significance except when \(\varrho=1\) also. It turns out that one can draw the graph of the relation between \(s\) and \(\varrho\) by solving for \(\varrho\) (one cannot solve explicitly for \(s\)). The function \(\varrho=(s-1)/\log(s)\) yields

<!-- Pages 322-322 -->

and for \(x>0\)

\[b^{(k)}(x)=(1-p)b^{(k)}_{a}(x). \tag{5.1.17b}\]

Next note from its definition that \(\Psi\left[\mathbf{V}^{n}\right]=(1-p)\Psi_{a}\left[\mathbf{V_{a}}^{n}\right]\), so, using (3.1.8b) and (3.1.9), we can write for \(k,n\geq 0\)

\[b^{(k)}(0_{+})=-R^{(k+1)}(0_{+})=(1-p)b^{(k)}_{a}(0)=(-1)^{k}\,(1-p)\Psi_{a}[ \mathbf{B_{a}}^{k+1}], \tag{5.1.17c}\]

and (pick any pair)

\[\mathbf{E}[X^{n}]=n!\Psi\left[\mathbf{V}^{n}\right]=n!(1-p)\Psi_{a}\left[ \mathbf{V_{a}}^{n}\right]=(1-p)\mathbf{E}[X^{n}_{a}]. \tag{5.1.17d}\]

Now we show the utility of (5.1.15a) (and LAQT) for finding the derivatives of functions. As we do so often, we define an auxiliary function that seems to be more general than we need, and then come up with simpler expressions than we otherwise would. Let

\[G(k,\,l;\,\varrho):=(1-p)\Psi_{a}\left[\mathbf{V_{a}}^{k}[\varrho\,T\,\mathbf{ I}+(1-s)\mathbf{V_{a}}]^{-l}\right],\] (5.1.18a) for \[k,\ l\geq 1\]. We have suppressed the dependence on \[s\], because it, in turn, also depends on \[\varrho\]. Then from ( 5.1.15a ), \[g(s;\,\varrho)=G(1,1;\,\varrho)-1. \tag{5.1.19}\]

Now we are ready to take partial derivatives.

\[G_{s}(k,\,l;\,\varrho): =\frac{\partial}{\partial s}G(k,\,l;\,\varrho)\] \[=l(1-p)\Psi_{a}\left[\mathbf{V_{a}}^{k+1}[\,\varrho\,T\,\mathbf{ I}+(1-s)\mathbf{V_{a}}]^{-(l+1)}\right].\]

Thus

\[G_{s}(k,l;\,\varrho)=lG(k+1,\,l+1;\,\varrho).\] (5.1.20a) Similarly, we can show that \[G_{\varrho}(k,l;\,\varrho):=\frac{\partial}{\partial\varrho}G(k,l;\,\varrho)=- lTG(k,\,l+1;\,\varrho). \tag{5.1.20b}\]

We can use these equations to differentiate over and over again. For instance, applying (5.1.20b) twice, we get

\[G_{\varrho\varrho}(k,l;\,\varrho)=l(l+1)T^{2}G(k,\,l+2;\,\varrho),\]

and applying (5.1.20a) and (5.1.20b) once each, we get

\[G_{\varrho\,s}(k,l;\,\varrho)=G_{s\,\varrho}(k,l;\,\varrho)=-l^{2}\,TG(k+1,l+ 2;\varrho).\]

Notice that if we start with \(l\geq k\), then no matter how many partial derivatives we take of both kinds, we will always end up with an expression where the second argument of \(G\) is greater than, or equal to, the first argument. As

<!-- Pages 323-323 -->

long our object is to differentiate \(g(s;\varrho)\) (where \(k=l=1\)), this will always be the case.

Actually, we are only interested in the \(G\)'s when \(\varrho=0\) (\(s=p\)) and \(\varrho=1\) (\(s=1\)). Thus (use \(\mathbf{V_{a}=B_{a}}^{-1}\))

\[G(k,\,l;\,0)=(1-p)\Psi_{a}\left[\mathbf{V_{a}}^{k}[(1-p)\mathbf{V_{a}}]^{-l}\right]\]

\[=(1-p)^{-(l-1)}\Psi_{a}\left[\mathbf{B_{a}}^{l-k}\right]\] (5.1.21a) (we have assumed that \[l\geq k\] ) and \[G(k,l;\,1)=(1-p)T^{-l}\Psi_{a}\left[\mathbf{V_{a}}^{k}\right]=T^{-l}\Psi\left[ \mathbf{V}^{k}\right]. \tag{5.1.21b}\]

Notice that all the \(G\) functions, evaluated at \(\varrho=0\), depend only on the scalars, \(\Psi_{a}\left[\mathbf{B_{a}}^{j}\right]\) (for \(j\geq 0\)), which from (5.1.17c) tells us that they depend on \(R(x)\) and its derivatives at \(x=0\) only. Also notice from (5.1.21b) that the value of \(G\) at \(\varrho=1\) does not explicitly depend on the initial impulse, as represented by \(p\) and \(a\), and in fact, depends only on the moments of the interarrival time distribution. Although (5.1.21a) and (5.1.21b) only explicitly apply to ME distributions, (5.1.17c) and (5.1.17d) allow us to extend the equations to any distribution for which the appropriate objects exist:

\[G(k,\,l;\,1)=\frac{\mathbf{E}[X^{k}]}{k!\,T^{l}}. \tag{5.1.21c}\]

and

\[G(k,l;0)=\frac{(-1)^{l-k}}{(1-p)^{l}}R^{(l-k)}(0_{+}). \tag{5.1.21d}\]

Such relations could have been derived without the aid of the ME formulas, but the mathematical difficulties would have been enormous. For instance, \(l^{\prime}Hospital\)'s rule must be applied \(k+1\) times just to get the \(k\)th derivative. The reader should try it and see.

Okay, let us see what all this has done for us. Return to (5.1.16), and use (5.1.19) and (5.1.20), to get

\[s^{\prime}(\varrho;\,G):=\frac{ds}{d\varrho}=-\frac{G_{\varrho}(1,1;\varrho)} {G_{s}(1,1;\varrho)}=\frac{TG(1,2;\varrho)}{G(2,2;\varrho)}.\] (5.1.22a) For \[\varrho=1\], using (5.1.21b), we have (remember, \[\Psi\left[\mathbf{V}\right]=\mathbf{E}[X]=T\] ) \[s^{\prime}(1;\,G)=T\frac{\Psi\left[\mathbf{V}\right]}{T^{2}}\times\frac{T^{2}} {\Psi\left[\mathbf{V}^{2}\right]}=\frac{T^{2}}{\Psi\left[\mathbf{V}^{2} \right]}.\] (5.1.22b) But \[\Psi\left[\mathbf{V}^{2}\right]=\mathbf{E}[X^{2}]/2\], \[\mathbf{E}[X^{2}]=T^{2}+\sigma^{2}\], and \[C_{v}^{2}=\sigma^{2}/T^{2}\], so \[s^{\prime}(1;\,G)=\frac{2}{1+C_{v}^{2}}. \tag{5.1.22c}\]

<!-- Pages 324-324 -->

Given that \(s^{\prime}(1;M)=1\), (5.1.22c) tells us that any interarrival time distribution that has a coefficient of variation less than (greater than) \(1\) will have a slope greater (less) than \(1\), and thus its geometric parameter must be below (above) that for the M/M/1 queue as they both approach \((1,1)\). The largest slope attainable occurs for the deterministic distribution for which \(C_{v}^{2}=0\) and \(s^{\prime}(1;D)=2\); thus all other curves must lie above it (at least for \(\varrho\) near \(1\)). In a similar fashion we can show that (pick one)

\[s^{\prime}(0;\,G)=T\Psi_{a}\left[\mathbf{B_{a}}\right]=Tb_{a}(0)=\frac{Tb(0_{+ })}{1-p}=(1-p)T_{a}b_{a}(0). \tag{5.1.22d}\]

Although the above equations appear to depend on two factors (\(T\) and \(b(0)\)) they actually are related and produce only one independent parameter. In studying the behavior of G/M/1 queues one commonly varies the arrival rate of customers, or equivalently, the interarrival time, without varying the interarrival time distribution. In Definition 3.2.1 we discussed what it means to have two distributions with the _same shape_. We apply it to the expression \(T\Psi_{a}\left[\mathbf{B_{a}}\right]\). First define the matrix,

\[\mathbf{B_{ao}}:=T_{a}\mathbf{B_{a}},\]

with inverse \(\mathbf{V_{ao}}=(1/T_{a})\mathbf{V_{a}}\). Then, for instance, \(\Psi_{a}[\mathbf{V_{ao}}]=1\), and \(\mathbf{\left(\mathbf{p_{a}},\,\mathbf{B_{a}}\right)\sim\left(\mathbf{p_{a}}, \,\mathbf{B_{oa}}\right)}\), from which is follows that \(\mathbf{\left(\mathbf{p},\,\mathbf{B}\right)\sim\left(\mathbf{p},\,\mathbf{B_ {o}}\right)}\). In other words, the PDFs generated by these representations (\(F(x)\) and \(F_{\mathrm{o}}(x)\)) look alike, as would be expected for some renewal process where the arrival rate is changed. Then (5.1.22d) yields

\[s^{\prime}(0;\,G)=T\frac{1}{T_{a}}\Psi[\mathbf{B_{ao}}]=(1-p)\Psi[\mathbf{B_{ao }}]=(1-p)b_{ao}(0)=b_{\mathrm{o}}(0_{+}). \tag{5.1.22e}\]

We see from this that \(s^{\prime}(0;\,G)\) does not depend on \(T\).

We now see how \(s\) behaves by expanding it in a Taylor series around \(0\) and \(1\). But keep in mind that these expansions are valid only if all the derivatives of \(b(x)\) exist around \(x=0_{+}\). A Taylor series expansion near \(\varrho=0\) gives us

\[s(\varrho;\,G)\approx p+s^{\prime}(0;\,G)\varrho+\frac{1}{2}s^{\prime\prime}( 0;\,G)\varrho^{2}+\cdots\] (5.1.23a) and for \[\varrho\] near \[1\], \[s(\varrho;\,G)\approx 1-s^{\prime}(1;\,G)(1-\varrho)+\frac{1}{2}s^{\prime \prime}(1;\,G)(1-\varrho)^{2}+\cdots. \tag{5.1.23b}\]

Equation (5.1.23a) tells us that if

<!-- Pages 325-325 -->

but it does tell us that \(s(\varrho;D)\) is very flat near \(0\), and thus bounds all other \(s\) functions from below (at least for \(\varrho\) near \(0\)). The behavior of \(s\) near \(\varrho=1\) follows directly from (5.1.22c) and (5.1.23b). Easy manipulation yields

\[\frac{1-s}{1-\varrho}=\frac{2}{1+C_{v}^{2}}+\mathrm{O}[1-\varrho]. \tag{5.1.23d}\]

This tells us that as \(\varrho\) approaches \(1\), larger \(C_{v}^{2}\) means larger \(s\).

Note that the conditions required for \(s\) to be smaller than \(\varrho\) near \(0\), and the requirements that \(s\) be larger than \(\varrho\) near \(1\), are completely unrelated; thus it is possible to construct distribution functions whose geometric parameters cross the line \(s=\varrho\), at least once, even with \(p=0\). In fact, we discussed one such function in Section 3.2.3.1, a hyper-Erlangian with \(4\) states. This family of functions satisfies \(b(0)=0\), but can have any mean and any squared coefficient of variation \(C_{v}^{2}\geq 1/2\). See Example 5.5.2 for further discussion. The behavior of \(s(\varrho)\) for various values of \(C_{v}^{2}\) is explored in the following exercise.

**Exercise 5.1.5:** Calculate the geometric parameter \(s\) as a function of \(\varrho\), using \(T=1\) and \(C_{v}^{2}=1\), \(2\), \(5\), \(10\) for the two distributions given in Chapter 3, Equations (3.2.7) and (3.2.14) (the hyperexponential and the hyper-Erlangian). This can be done by numerically solving (5.1.6a) for enough values of \(\varrho\) to produce a smooth curve. Draw the two sets of four curves on the same graph, together with the line \(s=\varrho\). (The hyperexponential with \(C_{v}^{2}=1\) should give this.) Note that for the hyper-Erlangian, when \(C_{v}^{2}>1\), \(s(\varrho)\) crosses \(s=\varrho\), but for \(C_{v}^{2}=1\) it asymptotically approaches the line from below as \(\varrho\Rightarrow 1\) (i.e., it has the same slope at \(\varrho=1\)). This must be true because of (5.1.22c).

We have done everything we can to state and prove the following theorem, which summarizes this section.

**Theorem 5.1.4**: For any steady-state \(\mathrm{G}/\mathrm{M}/1\) queue, with utilization factor, \(\varrho=1/\rho=1/\lambda T\), and geometric parameter \(s(\varrho;\,G)\), given by Theorem 5.1.2, the following statements are true.

(a) \(s(\varrho;\,G)\) depends only on \(B(x)\) [or \(R(x)\)] and its derivatives near \(\varrho=0\).

(b) \(s(\varrho;\,G)\) depends only on the moments of \(b(x)\) near \(\varrho=1\).

(c) \(s(\varrho;G)\) is bounded from below by \(s(\varrho;D)\) for \(0\leq\varrho\leq 1\).

We have not actually proven (c) for all \(\varrho\). \(\blacksquare\)

This theorem has an important implication for dealing with approximations to density functions when applied to heavy traffic queues and reliability theory. Heavy traffic queues occur when \(\rho\), or in this chapter, \(\varrho\), is close to \(1\)

<!-- Pages 328-328 -->

stays close to 1 for smaller values of \(\varrho\).

The fact that "s is very close to 1" is in itself not very informative. The question is "How close?" After all, it is \(t:=1-s\) that yields the information needed. From Equations (5.1.7b) and (5.1.7c), it is seen that \(\bar{q}_{2}\) and \(\hbox{\sf E\kern-5.0pt\lower 0.43pt\hbox{\vrule height 6.665pt depth -0.43pt width 1px\hss} \vrule height 6.665pt depth -0.43pt width 1px\hss}[T_{2}]\) depend inversely on \(t\); that is, the smaller \(t\) is, the larger they are. Furthermore, the overflow probabilities, as given in (5.1.9d), are very dependent upon \(t\). Note that

\[\lim_{t\to\infty}(1+t)^{1/t}=e,\]

so we can write

\[P_{o2}=s^{k}=(1-t)^{k}=[(1-t)^{1/t}]^{kt}\approx e^{-kt}. \tag{5.1.25}\]

That is, unless \(kt>>1\) we can expect the queue to exceed length \(k\) often. If \(t\) is very small, then very large buffers are needed. The analysis of the behavior of \(t\) near \(\varrho=1\) is too involved to present here, but is given in detail in [Grein-Job-Lip99]. Let

\[\beta:=\frac{1}{1-\alpha}\]

Then they show that, near \(\varrho=1\),

\[t(\varrho)\Rightarrow C\,\varrho\,(1-\varrho)^{\beta},\ \ \ {\rm for}\ \ 1< \alpha<2, \tag{5.1.26a}\]

Figure 5.1.3: \(\varrho-t-\)**Diagram, both for the exact and the asymptotic equations for a PT/M/1 queue, where \(t:=1-s\), \(\alpha=1.3\) and \(\theta=0.5\).** From the inset, it is clear that the asymptotic Equation (5.1.26a) is an excellent approximation for \(\varrho\) as small as 0.8.

<!-- Pages 331-331 -->

### ME Representation of Departures

We now turn our attention to the behavior of customers leaving a service center. We already looked at this to some extent in Sections 2.1.6 and 4.2.5, in looking at the M/M/1 and M/G/1 queues. We do the same here for the G/M/1 queue, but first we look at arrivals to \(S_{2}\) conditioned by departures from \(S_{2}\). From the closed-loop point of view, arrivals to \(S_{2}\) are the same as departures from \(S_{1}\). There was no point in examining the equivalent question for the M/G/1 queue, because arrivals to the "G" queue (\(S_{1}\)) were governed according to the Poisson process, and thus no conditions could change that.

#### 5.2.1 Arrival Time Distribution Conditioned by a Departure

We saw in Theorem 5.1.3 that all the steady-state vector departure probabilities \([\mathbf{d_{2}}(n)]\) are proportional to the same vector \(\hat{\mathbf{u}}\). Thus at the moment a customer leaves \(S_{2}\), \(S_{1}\) will be found in that same state. We conclude, then, that the time until the next arrival to \(S_{2}\) is generated by the vector-matrix pair \(\boldsymbol{\langle}\,\hat{\mathbf{u}}\,,\,\mathbf{B}\boldsymbol{\rangle}\). We must say a few words to distinguish this process from the interarrival process to \(S_{2}\). The interarrival process refers to the distribution of times between arrivals to \(S_{2}\), or the time until the next arrival, given that a customer has just arrived. It is the same as the time between departures from \(S_{1}\), which is generated by \(\boldsymbol{\langle}\,\mathbf{p},\mathbf{B}\boldsymbol{\rangle}\). In this section we are interested in

Figure 5.1.5: G/M/1 primary buffer size \(\boldsymbol{\ell}\) needed as \(\boldsymbol{\varrho}\) approaches 1. The conditions are the same as those in Figure 5.1.4, i.e., \(\ell\) is multiplied by \(1-\varrho\) to yield finite values for their product. All the curves (excluding the one for the M/M/1 queue) are equal at \(\varrho\!=\!1\) because they have the same \(C_{v}^{2}\).

<!-- Pages 332-332 -->

the time to the next arrival, given that a customer has just departed \(S_{2}\) thus the change from \(\mathbf{p}\) to \(\hat{\mathbf{u}}\) as the initial, or startup, vector. For lack of a better symbol, we denote all properties of this process with the subscript \(\omega\). Thus \(X_{\omega}\) is the r.v. denoting the time until the next arrival, given that a customer has just departed \(S_{2}\), and \(b_{\omega}(x)\) is its density function.

Consistent with Theorems 3.1.1 and 4.2.5 we describe this latest process by the following theorem.

**Theorem 5.2.1** The arrival times for an open ME/M/1 queue, given that a customer has just left, is generated by the vector-matrix pair \(\boldsymbol{\langle}\,\hat{\mathbf{u}}\,,\,\mathbf{B}\boldsymbol{)}\) ( or \(\boldsymbol{\langle}\,\hat{\mathbf{u}}\,,\,\mathbf{V}\boldsymbol{)}\)), where \(\hat{\mathbf{u}}\) is given by Corollary 5.1.2, and \(\mathbf{B}\) is the service rate matrix for \(S_{1}\). It then follows that (where \(\Psi_{\omega}\left[\,\mathbf{X}\,\right]:=\hat{\mathbf{u}}\mathbf{X}\, \boldsymbol{\epsilon}^{\prime}\) for any \(\mathbf{X}\))

\[\mathbf{E}\!\left[X_{\omega}^{n}\right]=n!\Psi_{\omega}\left[\mathbf{V}^{n} \right], \tag{5.2.1a}\]

\[b_{\omega}(x)=\Psi_{\omega}\left[\mathbf{B}\exp(-x\mathbf{B})\right], \tag{5.2.1b}\]

and

\[B_{\omega}^{*}(s)=\Psi_{\omega}\left[(\mathbf{I}+s\mathbf{V})^{-1}\right]. \tag{5.2.1c}\]

The proof follows from the definition of \(\hat{\mathbf{u}}\) and Theorem 3.1.1.

Let us now examine this distribution further by calculating its mean and variance, and then see what we can do with its pdf. We can find \(\mathbf{E}\!\left[X_{\omega}\right]\) by multiplying (5.1.6c) on the right with \(\boldsymbol{\epsilon}^{\prime}\). This process yields

\[1+(1-s)\lambda\hat{\mathbf{u}}\mathbf{V}\boldsymbol{\epsilon}^{\prime}= \lambda\mathbf{p}\mathbf{V}\boldsymbol{\epsilon}^{\prime}=1+(1-s)\lambda \mathbf{E}\!\left[X_{\omega}\right]=\lambda\mathbf{E}\!\left[X_{1}\right]=1/ \varrho.\]

Upon solving for \(\mathbf{E}\!\left[X_{\omega}\right]\) we get

\[\mathbf{E}\!\left[X_{\omega}\right]=\frac{1-\varrho}{(1-s)\varrho\,\lambda}= \frac{1-\varrho}{1-s}\,\mathbf{E}\!\left[X_{1}\right]. \tag{5.2.2a}\]

In general, \(\mathbf{E}\!\left[X_{\omega}\right]\) is not equal to \(\mathbf{E}\!\left[X_{1}\right]\). Of course, for the M/M/1 queue \(s=\varrho\), so in that case, the two are equal. They are also equal in the limit as \(\varrho\to 0\) (i.e., in the no-load limit), if there is no initial impulse. For then \(s\) also becomes \(0\). The heavy load limit is not so easy to find, because now both \(s\) and \(\varrho\) go to \(1\), and we are left with the indeterminate, \(0/0\). We can take the limit by going back to (5.1.6b). Now, remember that \(\varrho\) goes to \(1\), \(\lambda\) and \(1/\mathbf{E}\!\left[X_{1}\right]\) become equal. Also, recall the definition of the mean residual vector \(\boldsymbol{\pi}_{\mathbf{r}}\) from (3.5.10b). What we get is

\[\lim_{\varrho\to 1}\hat{\mathbf{u}}=\mathbf{p}(\mathbf{I}+0\mathbf{V})^{-1} \frac{1}{\mathbf{E}\!\left[X_{1}\right]}\mathbf{V}=\frac{1}{\Psi\left[ \mathbf{V}\right]}\mathbf{p}\mathbf{V}=\boldsymbol{\pi}_{\mathbf{r}}. \tag{5.2.2b}\]

This is what a random observer sees upon visiting \(S_{1}\) without noting its previous behavior. We would expect this, because a customer departing \(S_{2}\) sort of randomly arrives at \(S_{1}\). We also know that for the M/G/1 queue, a random observer and an arriving customer see the same thing at \(S_{1}\). Why then, is this not true for the G/M/1 queue as well? First we show that the

<!-- Pages 336-336 -->

Note the appearance of the third moment of \(S_{1}\) in the expression. If \(S_{1}\) is an exponential server, then \(C_{1}^{2}=1\), and, so \(C_{\omega}^{2}=1\) as well, (of course).

#### 5.2.2 Distribution of Interdeparture Times

We spent considerable space in the preceding section discussing a process that does not seem to be of enormous interest to queueing practitioners. However, several of the formulas derived there are useful here, as we explore the behavior of customers departing the G/M/1 queue. We have already discussed this process twice before, in Sections 2.1.6 and 4.2.5, in conjunction with the M/M/1 and M/G/1 queues. The method presented here is similar to that already used in those sections; however, the results are considerably different and thus warrant a fresh analysis.

Let us follow the argument we used in Section 4.2.5 in examining Figure 5.2.2. We use the subscripts **2d** and _2d_ to denote the **d**e departure process from \(S_{2}\). For instance, \(b_{2d}(x;\,s)\) is the density function for the process. Our observer is now sitting just downstream from \(S_{2}\), watching customers go by. Assuming that \(C_{0}\) has just left, what can we tell her about customer \(C_{1}\)? Well, either he is at \(S_{2}\), with probability \(1-d_{2}(0)\), which from (5.1.9c) equals \(s\), or \(S_{2}\) is empty, and \(C_{1}\) is at \(S_{1}\), already in the process of being served there. The vector \(\hat{\mathbf{u}}\) gives her the probability of where in \(S_{1}\) he is at the moment \(C_{0}\) left

Figure 5.2.1: **Distribution of arrival times, conditioned by departures from an \(E_{2}/\mathbf{M/1}\) queue, for various values of \(\lambda\), the mean service rate of the lone exponential server in \(S_{2}\). The mean interarrival time for all cases is held fixed at \(T_{1}=1\). Thus \(\lambda=1/\varrho\). Note the multiple crossing, which is shown in detail in the inset graph. To within the numerical accuracy of our calculations, all the curves cross at \(x=0.5\).**

<!-- Pages 337-337 -->

\(S_{2}\). (Remember, _she_ is the observer, and \(he\) is \(C_{1}\).) Thus the startup vector for the interdeparture process is

\[\mathbf{p_{2d}}:=\left[(1-s)\hat{\mathbf{u}},\,s\right].\] (5.2.5a) In words, the process starts with \[C_{1}\] either being at phase \[i\] in \[S_{1}\] with probability \[(1-s)[\hat{\mathbf{u}}]_{i}\], or at \[S_{2}\] with probability \[s\]. Clearly, because \[\hat{\mathbf{u}\boldsymbol{\epsilon^{\prime}}}=1\], it follows that \[\mathbf{p_{2d}}\boldsymbol{\epsilon^{\prime}}=1\] also. Note that we have changed the ordering of our states from that in Chapter 4, by placing \[S_{1}\] first. Now the numbering of the states goes from \[1\] to \[m+1\], where the state corresponding to being in \[S_{2}\] is \[m+1\] rather than \[0\]. Figure 5.2.2 is descriptive enough for us to write down the completion rate and transition matrices for the process.

\[\mathbf{M_{2d}}=\left[\begin{array}{cc}\mathbf{M}&\mathbf{o^{\prime}}\\ \mathbf{o}&\lambda\end{array}\right]\]

and

\[\mathbf{P_{2d}}=\left[\begin{array}{cc}\mathbf{P}&\mathbf{q^{\prime}}\\ \mathbf{o}&0\end{array}\right],\]

where \(\mathbf{o}(\mathbf{o^{\prime}})\) is a row (column) vector with the same dimension as \(\mathbf{M}\) and \(\mathbf{P}\), namely, \(m\). Then in direct analogy with (4.2.17b), we can write down the process rate matrix.

\[\mathbf{B_{2d}}=\mathbf{M_{2d}}(\mathbf{I_{2d}}-\mathbf{P_{2d}})=\left[ \begin{array}{cc}\mathbf{B}&-\mathbf{B}\boldsymbol{\epsilon^{\prime}}\\ \mathbf{o}&\lambda\end{array}\right]. \tag{5.2.5b}\]

The process time matrix also follows easily:

\[\mathbf{V_{2d}}=\mathbf{B_{2d}^{-1}}=\left[\begin{array}{cc}\mathbf{V}& \frac{1}{\lambda}\boldsymbol{\epsilon^{\prime}}\\ \mathbf{o}&\frac{1}{\lambda}\end{array}\right]. \tag{5.2.5c}\]

We now know enough to state the following theorem concerning interdeparture times.

Figure 5.2.2: **Pictorial representation of the departure process from \(S_{2}\), in a G/M/1 open queue.** Dependence on the number of customers is implicitly given through the steady-state probabilities at departure times. Given that customer \(C_{0}\) has just left, \(C_{1}\) must enter \(S_{2}\), and be served before leaving \([\lambda]\), or if \(S_{2}\) is empty, \(C_{1}\) must finish being served by \(S_{1}\) [\(\left\{\hat{\mathbf{u}},\,\mathbf{B}\right\}\) ], and then go to \(S_{2}\) to be served. The probability that no one is at \(S_{2}\) at the moment of a departure \(d_{2}(0)\) is given by (5.1.9c).

<!-- Pages 338-338 -->

**Theorem 5.2.2**: The distribution of times between departures from a steady-state open G/M/1 queue is generated by the vector-matrix pair, \(\left\{\mathbf{p_{2d}}\,,\,\mathbf{B_{2d}}\right\}\), as given by Equations (5.2.5). The following equations must be true (where \(\Psi_{2d}\left[\,\mathbf{D}\,\right]:=\mathbf{p_{2d}}\,\mathbf{D}\,\boldsymbol{ \epsilon^{\prime}}_{2\mathbf{d}}\)),

\[\mathbf{E}\!\left[X_{2d}^{n}\right]=n!\Psi_{2d}\left[\left(\mathbf{V_{2d}} \right)^{n}\right], \tag{5.2.6a}\] \[b_{2d}(x)=\Psi_{2d}\left[\mathbf{B_{2d}}\exp(-x\mathbf{B_{2d}})\right],\] (5.2.6b) and \[B_{2d}^{*}(s)=\Psi_{2d}\left[\left(\mathbf{I}+s\mathbf{V_{2d}}\right)^{-1} \right]. \tag{5.2.6c}\]

The proof follows from Theorem 3.1.1. \(\blacksquare\)

Before calculating the mean interdeparture time, we use (5.2.5a) and (5.2.5c) to find the following row vector,

\[\mathbf{p_{2d}}\mathbf{V_{2d}}=\left[(1-s)\hat{\mathbf{u}}\mathbf{V},\;\frac{ 1}{\lambda}\right].\]

Because \(\mathbf{E}\!\left[X_{2d}\right]=\mathbf{p_{2d}}\,\mathbf{V_{2d}}\,\boldsymbol{ \epsilon^{\prime}_{2\mathbf{d}}}\), the mean is

\[\mathbf{E}\!\left[X_{2d}\right]=(1-s)\Psi_{\omega}\left[\mathbf{V}\right

<!-- Pages 340-340 -->

We use the now-familiar summation formula for the finite geometric series, and carry out some further algebra to get the following.

\[\mathbf{g}^{\prime}(n)=\mathbf{X}(\lambda^{n}\mathbf{I}-\mathbf{B}^{n})\boldsymbol {\epsilon}^{\prime}. \tag{5.2.8b}\]

We can almost exactly follow the steps leading up to (4.2.21b) to find the reliability matrix for this departure process, giving us

\[\mathbf{R_{2d}}(x):=\exp(-x\mathbf{B_{2d}})=\left[\begin{array}{cc}\exp(-x \mathbf{B})&\mathbf{X}[e^{-x\lambda}\mathbf{I}-\exp(-x\mathbf{B})]\boldsymbol {\epsilon}^{\prime}\\ \\ \mathbf{o}&e^{-x\lambda}\end{array}\right]\]

\[=\left[\begin{array}{cc}\mathbf{R_{1}}(x)&\mathbf{X}[e^{-x\lambda}\mathbf{ I}-\mathbf{R_{1}}(x)]\boldsymbol{\epsilon}^{\prime}\\ \\ \mathbf{o}&e^{-x\lambda}\end{array}\right]. \tag{5.2.8c}\]

To get \(b_{2d}(x;\,s)\), we first must find \(\mathbf{B_{2d}}\,\mathbf{R_{2d}}(x)\). This turns out to be

\[\mathbf{B_{2d}}\,\mathbf{R_{2d}}(x)=\left[\begin{array}{cc}\mathbf{R_{1}}(x )&\mathbf{X}[e^{-x\lambda}\mathbf{I}-\mathbf{B}\,\mathbf{R_{1}}(x)]\boldsymbol {\epsilon}^{\prime}\\ \\ \mathbf{o}&e^{-x\lambda}\end{array}\right]. \tag{5.2.9a}\]

Our next step is to evaluate \(\mathbf{B_{2d}}\,\mathbf{R_{2d}}(x)\,\boldsymbol{\epsilon}^{\prime}_{2d}\). Because \(\mathbf{X},\,\mathbf{B}\), and \(\mathbf{R_{1}}(x)\) all commute with each other, and \(\mathbf{X}-\mathbf{I}=\lambda\mathbf{X}\mathbf{V}\), this turns out to be the following column vector:

\[\mathbf{B_{2d}}\,\mathbf{R_{2d}}(x)\,\boldsymbol{\epsilon}^{\prime}_{2d}=\left[ \begin{array}{cc}\lambda\mathbf{X}[e^{-x\lambda}\mathbf{I}-\mathbf{B}\, \mathbf{R_{1}}(x)]\boldsymbol{\epsilon}^{\prime}\\ \\ \lambda\,e^{-x\lambda}\end{array}\right]. \tag{5.2.9b}\]

Finally, given that \(b_{2d}(x;\,s)=\Psi_{2d}\left[\mathbf{B_{2d}}\,\mathbf{R_{2d}}(x)\right]= \mathbf{p_{2d}}\mathbf{B_{2d}}\mathbf{R_{2d}}(x)\boldsymbol{\epsilon^{\prime} _{2d}}\), and \(\mathbf{p_{2d}}\) is given by (5.2.5a), we have the density function for the steady-state departure process:

\[b_{2d}(x;\,s)=\lambda e^{-\lambda x}\tilde{\mathbf{u}}\mathbf{X}(\mathbf{I}- s\lambda\mathbf{V})\,\boldsymbol{\epsilon}^{\prime}-(1-s)\lambda\tilde{\mathbf{u}} \,\mathbf{X}\,\mathbf{R_{1}}(x)\,\boldsymbol{\epsilon}^{\prime}. \tag{5.2.9c}\]

Although this expression looks rather complicated, it is expressed in terms of \(m\)-dimensional matrices, whereas the original representation is \((m+1)\)-dimensional. It can be used as a practical way to get the pdf for any specific examples, particularly if they are of small dimension. Also, note the striking similarity with its M/G/1 counterpart, \(b_{1d}(x)\) [called \(b_{d}(x)\) in (4.2.22a)]. These formulas have not been known until very recently, so not many researchers have worked with them. Therefore, we have no way of knowing if they can be manipulated into simpler or more interesting forms.

Whether \(b_{2d}(x)\) can be manipulated into a convenient form or not, we know its generator \(\boldsymbol{\langle}\,\mathbf{p_{2d}}\,,\,\mathbf{B_{2d}}\boldsymbol{\rangle}\), given by (5.2.5a) and (5.2.5b). Therefore, there is little effort to computing the function once the interarrival time distribution is given.

**Example 5.2.2:** We have calculated \(b_{2d}(x;s)\) for an \(E_{2}\)/M/1 queue, and

<!-- Pages 341-341 -->

plotted it in Figure 5.2.3, for several values of \(\varrho\), all less than 1. We already know that when \(\varrho\geq 1\) the interdeparture times must look like the service time distribution. Even when \(\varrho\) is close to, but less than 1, they look very much like the exponential function. Of course, when \(\varrho\) is small, \(b_{2d}\) looks like \(E_{2}(x)\), the interarrival time distribution. Notice the rapid change from one to the other when \(\varrho\) goes from 0.25 to 0.50. The reader might compare this figure with its M/\(E_{2}/1\) counterpart in Figure 4.2.3.

### Me/m/1/\(N\) and Me/m/1/\(N\) Queues

Now is the time for you to ask again what the difference is between one and two slashes. In Section 2.1.4 we discussed the question in detail for buffer overflow and customer loss in M/M/1-type queues. But in Chapter 4 we brushed the question aside, explaining that in an M/ME/1 queue, they yielded identical results. But for ME/M/1 queues, they do not. For definiteness, let us adhere to the conventions of this chapter. The first position (ME) refers to the service time distribution at \(S_{1}\), the second (M) refers to \(S_{2}\), and the third position refers to the maximum number of customers (1) at \(S_{2}\) who can be active at the same time. The fourth position in this notation refers to the amount of space available at \(S_{2}\), including the customers in service (finite waiting room,

Figure 5.2.3: Distribution of interdeparture times \(b_{2d}(x)\) of an \(E_{2}/\)M/1 queue, for \(\varrho=\) 0.10, 0.25, 0.40, 0.50, 0.75, and 0.95. When \(\varrho\) is small, the interdeparture time distribution looks like the interarrival time distribution \(E_{2}(x)\), and when \(\varrho\) is near (or greater than) 1, it looks like the service time distribution \(\lambda\exp(-\lambda x)\).

<!-- Pages 342-342 -->

or buffer). If that position has \(J\) there, then when \(J\) customers are at \(S_{2}\), new arrivals are turned away (discounted or killed) until someone leaves, at which time there are then only \(J-1\) customers there. If that position is blank, it is assumed to be infinite. The fifth position refers to the total number of customers in the system, \(k\) of whom are at \(S_{2}\) and the remaining \(n\) are at \(S_{1}\). If that space is blank, or nonexistent, then we have an open system, (or \(N\) is infinite).

Consider the following string, \(G_{1}/G_{2}/C/J/N\). All systems with \(J\geq N\) are equivalent. After all, it does not pay to have more space than there are customers. Similarly, all systems with \(C\geq\min[J,\,N]\) are the same. Somewhat less obvious is the equivalence of all systems with \(N>J\). We only need one more customer than there is buffer space, for if a customer is turned away because of a full waiting room, there is no difference between his returning immediately to \(S_{1}\) or being replaced by another customer. We can say that if the inequality string \(C<J<N\) is not satisfied, the violating integer can be replaced by \(\infty\) (or any integer greater than or equal to the next symbol in the sequence).

Although the \(G_{1}/G_{2}/1/N\) queue is usually classified as an open system, the equivalent (but closed) loop \(G_{1}/G_{2}/1/N/(N+1)\) may be easier to visualize. In this case, the last customer loops on \(S_{1}\) until room is made available at \(S_{2}\). However, even after space becomes available, he must still complete service at \(S_{1}\) before finally being admitted to \(S_{2}\). In the \(G_{1}/G_{2}/1/\left/N\right.\) (or \(G_{1}/G_{2}/1/N/N\)) case, when all \(N\) customers are at \(S_{2},\,S_{1}\) is idle until the customer in service finishes. Only then does \(S_{1}\) begin processing a customer to generate the next arrival. That is, in the former case \(S_{1}\) is already processing the next arrival to \(S_{2}\) when room becomes available, but in the latter case, processing at \(S_{1}\) begins at the moment a completion occurs at \(S_{2}\). Only when the residual distribution time for \(S_{1}\) is the same as the overall distribution time (i.e., when \(S_{1}\) is exponential) will the customer return to \(S_{2}\) at the right time to make both systems identical. The algebraic analysis in the next section makes this clear.

#### Steady-State Solution of the ME/M/1/\(N\) Queue

First let us define (the subscript \(\mathbf{f}\) stands for "finite buffer") the steady-state probability vector.

_Definition 5.3.1_.: \(\boldsymbol{\pi_{2f}}(k;\,N):=\) _steady-state probability vector that there are k customers at \(S_{2}\) in an ME/M/1/\(N\) system. There are at least \(N+1\) customers in this system. If a customer arrives at \(S_{2}\) and finds \(N\) other customers already there, he immediately returns to \(S_{1}\). A random observer, with probability \([\boldsymbol{\pi_{2f}}(k;N)]_{i}\), will find the system in state \(\{i;k;N\}\). As usual, \(r_{2f}(k;\,N):=\boldsymbol{\pi_{2f}}(k;\,N)\boldsymbol{\epsilon^{\prime}}\) is the associated scalar probability. 

The more traditional view is that there are an infinite number of customers waiting to be served by \(S_{1}\). A customer who completes service there and finds

<!-- Pages 343-343 -->

\(S_{2}\) to be full, immediately self-destructs. The two views are mathematically equivalent, but if nothing else, our view is more humane.

Except when \(k=N\), the balance equations for \(\boldsymbol{\pi_{2f}}(k;N)\) are identical to those for \(\boldsymbol{\pi_{2}}(k;N)\). Remember to replace the vector \(\boldsymbol{\pi}(n;N)\) with \(\boldsymbol{\pi_{2f}}(N\!-\!k;N)\) [see (5.1.1d)] when you examine the equations in Section 4.1.1. The equation for \(k=N\) differs from (4.1.3b). Now, even though there are \(N\) customers at \(S_{2},\;S_{1}\) is not idle. Therefore, the vector probability of leaving the state \(\{\,\cdot\,;N;\,N\}\) is proportional to \((\lambda\mathbf{I}+\mathbf{M})\); that is, something can happen in either \(S_{1}\) or \(S_{2}\). There are three ways to enter state \(\{\,\cdot\,;\,N;\,N\}\). One is to be in some state \(\{\,\cdot\,;\,N\!-\!1;\,N\}\), \([\boldsymbol{\pi_{2f}}(N\!-\!1;\,N)]\), and have a completion \([\mathbf{M}]\) that results in a departure from \(S_{1}\), \([\mathbf{M}\mathbf{q}^{\prime}]\), while simultaneously the next customer enters \(S_{1}\), \([\mathbf{p}]\). The second way is for there to be \(N\) customers at \(S_{2}\), \([\boldsymbol{\pi_{2f}}(N;\,N)]\), with an event again occurring in \(S_{1}\), \([\mathbf{M}]\), with that customer going to another phase in \(S_{1}\), \([\mathbf{P}]\). The third way is similar to the second, except that now the customer in \(S_{1}\) [the lonesome \((N+1)\)st customer] leaves \([\mathbf{q}^{\prime}]\), but because the buffer at \(S_{2}\) is full, he immediately returns to \(S_{1}\) and starts up again \([\mathbf{p}]\). In total, we have

\[\boldsymbol{\pi_{2f}}(N;\,N)(\lambda\mathbf{I}+\mathbf{M})=\boldsymbol{\pi_{2 f}}(N\!-\!1;\,N)\mathbf{M}\mathbf{q}^{\prime}\mathbf{p}+\boldsymbol{\pi_{2f}}(N; \,N)\mathbf{M}(\mathbf{P}+\mathbf{q}^{\prime}\mathbf{p}).\]

Upon regrouping terms, and recognizing yet once again that \(\mathbf{M}\mathbf{q}^{\prime}\mathbf{p}=\mathbf{B}\mathbf{Q}\), we get

\[\boldsymbol{\pi_{2f}}(N;\,N)(\lambda\mathbf{I}+\mathbf{B}-\mathbf{B}\mathbf{Q })=\boldsymbol{\pi_{2f}}(N\!-\!1;\,N)\mathbf{B}\mathbf{Q}.\] (5.3.1a) The equation equivalent to ( 4.1.3c ) gives \[\boldsymbol{\pi_{2f}}(0;\,N)\mathbf{B}=\boldsymbol{\pi_{2f}}(1;\,N)\lambda,\] (5.3.1b) which in a manner identical to Section 4.1.2 recursively leads to results equivalent to ( 4.1.5b ), \[\boldsymbol{\pi_{2f}}(k;\,N)\mathbf{U}=\boldsymbol{\pi_{2f}}(k\!-\!1;\,N), \hskip 14.226378pt2\leq\ k\leq N.\] (5.3.1c) But ( 5.3.1a ) is yet to be satisfied. Equation ( 5.3.1c ) with \[k=N\] must be made consistent with ( 5.3.1a ). Upon combining the two, we get \[\boldsymbol{\pi_{2f}}(N;N)(\lambda\mathbf{I}+\mathbf{B}-\mathbf{B}\mathbf{Q })=\boldsymbol{\pi_{2f}}(N;N)\mathbf{U}\mathbf{B}\mathbf{Q}.\] But from Lemma 4.1.1, \[\mathbf{U}\mathbf{B}\mathbf{Q}=\lambda\mathbf{Q}\], so we bring everything to the left side of the equation to get \[\boldsymbol{\pi_{2f}}(N;N)(\lambda\mathbf{I}+\mathbf{B}-\lambda\mathbf{Q}- \mathbf{B}\mathbf{Q})=[\boldsymbol{\pi_{2f}}(N;N)(\lambda\mathbf{I}+\mathbf{B} )](\mathbf{I}-\mathbf{Q})=\mathbf{o}\]

(\(\mathbf{o}\) is the null row vector). This is an eigenvector equation which says that the vector in brackets is a left eigenvector of \((\mathbf{I}-\mathbf{Q})\) with eigenvalue \(0\). Can this be satisfied? It had better be. Note that \(\mathbf{C}:=\mathbf{I}-\mathbf{Q}\) is idempotent, just like \(\mathbf{Q}\). That is, \(\mathbf{C}^{2}=\mathbf{C}\). (See Lemma 3.5.1.) Therefore, all of \(\mathbf{C}\)'s eigenvalues are either \(0\) or \(1\). Now, \(\mathbf{Q}\) is of rank \(1\), so it has only one eigenvalue with

<!-- Pages 344-344 -->

value \(1\). Therefore, \(\mathbf{C}\) is of rank \(m-1\) and has only one zero eigenvalue. The corresponding left and right eigenvector pair are our old companions \(\mathbf{p}\) and \(\boldsymbol{\epsilon}^{\prime}\). The vector in brackets must, then, be proportional to \(\mathbf{p}\). Write

\[\boldsymbol{\pi_{2f}}(N;N)(\lambda\mathbf{I}+\mathbf{B})=c\mathbf{p},\]

where \(c\) is an undetermined constant. Recall from the definition of \(\mathbf{A}\) [Equation (4.1.4a)], that \(\lambda\mathbf{I}+\mathbf{B}=\lambda(\mathbf{A}+\mathbf{Q})\). Also, multiply both sides of the equation by \(\mathbf{U}\) to get

\[\lambda\boldsymbol{\pi_{2f}}(N;N)(\mathbf{I}+\mathbf{Q}\mathbf{U})=c\mathbf{p} \mathbf{U},\]

but \(\boldsymbol{\pi_{2f}}(N;N)\mathbf{Q}\mathbf{U}=\boldsymbol{\pi_{2f}}(N;N) \boldsymbol{\epsilon}^{\prime}\,\mathbf{p}\mathbf{U}=c^{\prime}\mathbf{p} \mathbf{U}\), where \(c^{\prime}\) is another constant. We regroup, divide by \(\lambda\), and get

\[\boldsymbol{\pi_{2f}}(N;N)=g(N)\mathbf{p}\mathbf{U}, \tag{5.3.1d}\]

where \(g(N)\) is yet another constant, which we _do_ evaluate. This time we have noted its dependence on \(N\).

We can now combine (5.3.1b), (5.3.1c), and (5.3.1d) to get the explicit matrix geometric solution to the ME/M/1/\(N\) queue:

\[\boldsymbol{\pi_{2f}}(k;N)=g(N)\mathbf{p}\mathbf{U}^{N+1-k}\quad\text{for } \;1\leq k\leq N,\]

but for \(k=0\),

\[\boldsymbol{\pi_{2f}}(0;N)=g(N)\lambda\mathbf{p}\mathbf{U}^{N}\mathbf{V}.\]

The scalar probabilities are, by now, easy to write down. For \(k>0\),

\[r_{2f}(k;N):=\boldsymbol{\pi_{2f}}(k;N)\boldsymbol{\epsilon}^{\prime}=g(N) \Psi\left[\mathbf{U}^{N+1-k}\right]\]

and the probability that \(S_{2}\) is idle is given by

\[r_{2f}(0;N)=g(N)\lambda\Psi\left[\mathbf{U}^{N}\mathbf{V}\right].\]

These formulas seem to be very familiar [look at (4.1.6a) and (4.1.6b)], and we relate them to the ME/M/1/\(\left/(N+1\right)\) queue after we have found \(g(N)\). We calculate this constant by requiring that the sum of the \(r_{2f}(k;N)\)s be \(1\). Then \(g(N)\) satisfies the relation

\[\frac{1}{g(N)}=\Psi\left[\lambda\mathbf{U}^{N}\mathbf{V}\right]+\sum_{k=1}^{N }\Psi\left[\mathbf{U}^{N+1-k}\right]=\Psi\left[\mathbf{U}+\mathbf{U}^{2}+ \cdots+\mathbf{U}^{N}+\lambda\mathbf{U}^{N}\mathbf{V}\right].\]

We need only compare this with the definition of \(\mathbf{K}

<!-- Pages 348-348 -->

yields Equations (5.3.4), a simple result for such a complicated derivation. **QED**

As a last comment, we mention that the last term of (5.3.4c) is a very efficient expression for computing \(P_{2f}(N)\), but only when \(\varrho\) is not too close to \(1\). At \(\varrho=1\), \(\mathbf{U}\) has a unit eigenvalue, thus \(\mathbf{K}\) does not exist there. It is then more accurate to use the middle expression. Better yet, if the eigenvalues and eigenvectors of \(\mathbf{U}\) can be computed easily and accurately, one can perform the sum over scalars. That is, let \(m=\text{Dim}[\mathbf{U}]\) and let \(\{\nu_{i}\,|\,1\leq i\leq m\}\) be the eigenvalues of \(\mathbf{U}\), with right and left eigenvectors \(\{\mathbf{v}_{\mathbf{i}}^{\prime}\}\) and \(\{\mathbf{u}_{\mathbf{i}}\}\), respectively. By the spectral decomposition theorem (see Section 1.3.3.1), it follows that

\[\mathbf{S}:=\sum_{n=\text{o}}^{N}\mathbf{U}^{n}=\sum_{1=1}^{m}\left[\sum_{n= \text{o}}^{N}\nu_{i}^{n}\,\mathbf{v}_{\mathbf{i}}^{\prime}\,\mathbf{u}_{ \mathbf{i}}\right]=\sum_{i=\text{o}}^{m}\left[\frac{1-\nu_{i}^{N+1}}{1-\nu_{i} }\right]\mathbf{v}_{\mathbf{i}}^{\prime}\,\mathbf{u}_{\mathbf{i}}.\]

If one of the eigenvalues, say \(\nu_{1}\), equals \(1\), then replace the term for \(i=1\) in large brackets with \(N+1\). That is,

\[\mathbf{S}=(N+1)\mathbf{v}_{1}^{\prime}\,\mathbf{u}_{1}+\sum_{i=2}^{m}\left[ \frac{1-\nu_{i}^{N+1}}{1-\nu_{i}}\right]\mathbf{v}_{\mathbf{i}}^{\prime}\, \mathbf{u}_{\mathbf{i}}.\]

This equation is efficient and stable to roundoff errors, even for very large \(N\). we made use of this in preparing the graphs in the following example.

**Example 5.3.1:** Using (5.3.4c) and (5.3.4d), we have calculated the smallest value of \(N\) for which a \(G/M/1/N\) queue will have a \(P_{2f}\leq.01\) loss rate for seven different interarrival time distributions, and have presented them in Figures 5.3.1 and 5.3.2. Note that this is an integer function of \(\varrho\). Therefore it increases by unit steps, hence the jagged appearance. It begins to look smooth because the graph is in log scale, and the steps thus have step sizes of \(\log[1+1/(\text{buffer size})]\approx 1/(\text{buffer size})\). Three of the functions chosen were TPTs from Section 3.3.6.2, with \(T=8,\ 16,\ 32\) where \(\theta=0.5\), and \(\alpha=1.4\). The curve labeled \(M\) is that for the \(M/M/1/N\) queue. The other three curves are for the Erlangian-2 distribution, and two hyperexponential distributions with the same \(C_{v}^{2}=4.75\) as the TPT with \(T=8\). Even though they have the same mean and variance, the three curves differ quite substantially. In fact, the curve for the \(H_{2}/M/1\) system with \(p_{1}=.0001\) looks a lot more like the one for the \(M/M/1\) system until \(\varrho\) approaches \(1\), showing once again that \(C_{v}^{2}\) is not necessarily the most important parameter.

Although the buffer size needed for \(1\%\) (\(P_{2f}=.01\)) loss grows very large as \(\varrho\) approaches \(1\) (remember that the buffer size is on a log scale), the inset for Figure 5.3.1 shows that it is finite at \(\varrho=1\) for all the distributions. In general, the curves \(do\) blow up, but at \(\varrho=1/(1-P_{2f})=\varrho_{m}\), for then the arrival rate of those customers who _are_ accepted equals the service rate, finally overwhelming \(S_{2}\). [See the discussions surrounding (2.1.10b) and (5.3.4).] The blowup is clearly demonstrated in the inset of Figure 5.3.1. In Figure 5.3.2 the buffer size is multiplied by \((\varrho_{m}-\varrho)\) for the same seven queues, and plotted for \(1\leq\varrho\leq\varrho_{m}=1/.99\). Here we see that the product goes to \(0\) at \(\varrho=\varrho_{m}\). This tells us that the buffer size blows up as \(1/(\varrho_{m}-\varrho)^{a}\), where \(a<1\).

<!-- Pages 349-349 -->

### 5.4 Steady-State ME/M/C-Type Queues

We are now prepared to give more properties to \(S_{2}\). It still has a one-dimensional internal representation, but we allow its service rate to vary with its queue length \(k\). This has the obvious application to systems in which several (\(C\)) exponential servers are fed by a single queue. Another potentially important application is in the study of complex networks. In this case, one server is singled out to be \(S_{1}\), the nonexponential server, and the rest of the network is approximated by \(S_{2}\), with suitably chosen flow rates \(\lambda(k)\) to represent customer flow. Thus one can combine the power of the product-form solutions in constructing (maybe) reasonable \(\lambda\)'s with the correct representation of one nonexponential server. This technique has been tried but not enough is known as yet to decide under what conditions it will give realistic results.

In Section 2.1.5 we discussed load-dependent exponential servers. We viewed a subsystem in either of two ways. Either there were multiple servers available to handle more than one customer at a time, or a single server worked faster when more customers were present. Because exponential subsystems have only one internal state, the two views are mathematically equivalent. For instance, if there is one customer present, let the probability rate of com

Figure 5.3.1: Buffer size needed for customer loss to be less than 1%, as a function of \(\varrho\), for seven interarrival time distributions with various \(C_{v}^{2}\). Three of the curves have TPT interarrival time distributions with \(T=8\), \(16\), \(32\) terms. The two curves labeled \(H_{2}\), \(p_{1}=\cdots\) have the same \(C_{v}^{2}=4.75\) as the one for \(T=8\), but are very different in shape. All curves are finite at \(\varrho=1\), but they do blow up at \(\varrho=1/(1-.01)\), as shown by the inset figure, whose \(x\)-axis extends beyond the blowup point.

<!-- Pages 350-350 -->

pletion be \(\lambda\), and if two are present, let the probability rate be \(2\lambda\). There is no way to tell if two servers are each processing a customer at the rate of \(\lambda\), or one server is working twice as fast.

Actually, there is a way to tell the difference: by _marking_ the customers. In the first case, if a customer is in service when a second arrives and begins service, there is a distinct possibility that the second will finish before the first (in fact, the probability is \(0.5\) for exponential servers). In the second case, the FCFS ordering is always maintained. If the customers are marked according to their order of arrival, an observer can tell the difference, because the two-server option will allow customers to leave in a different order from which they arrived. We have been and will continue to take the view that all customers are alike, and unmarkable. To do otherwise would greatly increase the amount of information required, even of exponential subsystems.

In many applications, the customers present share the single server on equal terms. For instance, a customer may be given a small amount of service and whether or not he is finished, the next customer is given an equal amount. After all customers present have been given a share, the first one is given another increment of service, and so on in _round-robin_ fashion. If the time accorded each in turn is very small compared to the mean service time then we have _processor sharing_. There is a related queueing known as _time slicing_ in which each _potential_ customer is given an increment of time, whether or not he uses it (e.g., a rotary switch on a multiplexed cable).

<!-- Pages 351-351 -->

Only the processor sharing discipline fits easily into our scheme of things. Conceptually we have multiple servers that are load dependent. If there is one customer present, then he gets the whole server. If two customers are present, then each one gets his own server, but the servers go at half speed. Once again, if the server is exponential then there is no easy way to tell the difference between this and the simple FCFS queue.

#### 5.4.1 Steady-State ME/M/X/ \(/n\) Loops

If a subsystem has multiple internal states (i.e., is nonexponential), the three views described in the preceding paragraphs are distinctly different. Modifying the service (actually, completion) rates corresponds to changing \(\mathbf{M}\) as a function of queue length but leaving \((\mathbf{I}-\mathbf{P})\) alone. Serving two customers at a time requires keeping track of both customers, for even when one of them leaves, the other is still in some phase of service. The latter view (for _processor sharing_ as well as _multiple servers_) is reserved for Chapter 6, because it requires an increase in complexity of our formalism.

Given that \(S_{2}\) has only one phase, the two views are still equivalent. Also, recall that solution of the M/G/1 and G/M/1 queues depends almost completely on the matrix

\[\mathbf{A}=\mathbf{I}+\frac{1}{\lambda}\mathbf{B}-\mathbf{Q}.\]

We see that \(\lambda\) and \(\mathbf{B}=\mathbf{M}(\mathbf{I}-\mathbf{P})\) always appear together. Therefore, changing \(\lambda\) (modifying \(S_{2}\)), or modifying \(\mathbf{M}\) by a constant factor, yields the same result. Here we assume that \(\mathbf{M}\) is fixed. The difference amounts to deciding whether the load dependence is a function of the number of customers at \(S_{1}\), \([n]\), or the number of customers at \(S_{2}\), \([k]\). In a closed loop it does not make any mathematical difference, because \(n+k=N\), but if we look at the same system for many values of \(N\), there is an algorithmic difference. There is also a difference from a modeling viewpoint. For instance, if we are interested in the behavior at \(S_{1}\), and the load factor depends on \(n\), we can think of this as an arrival rate that varies according to the number of customers already at \(S_{1}\). In the literature this is known as a queue with _discouraged arrivals_ (although arrivals could also be _encouraged_). For instance, Gupta et al, [10], have modelled a multiserver system with join-the-shortest-queue scheduling discipline as an arrival rate that decreases with queue length. On the other hand, stories emanated from the Soviet Union of queues that were joined by passersby because they thought that there must be "something to buy," the longer the queue the more likely that there was merchandise. We do not pursue this view further here.

Let us take the view that \(S_{2}\) has a service rate which depends on its queue length, and as in Chapter 2, call it \(\lambda(k)\). For now, we make no further assumptions concerning the values of \(\lambda(k)\). Therefore, following the notational comments at the end of Section 2.1.5, we look at ME/M/\(\mathbf{X}//N\) loops. The steady-state _balance equations_ can be taken directly from Equations (4.1.3) by replacing \(\lambda\) with \(\lambda(k)\), where \(k\) corresponds to the queue number in the matching \(\boldsymbol{\pi_{2}}\). The reader can check this by comparing the steady-state tran

<!-- Pages 352-352 -->

sition diagram in Figure 5.4.1 with Figure 4.1.2. Using the notation of this chapter, we have

\[\lambda(N)\boldsymbol{\pi_{2}}(N;N)=\boldsymbol{\pi_{2}}(N\!-\!1;N)\mathbf{BQ}, \tag{5.4.1a}\] \[\boldsymbol{\pi_{2}}(0;N)\mathbf{M}=\boldsymbol{\pi_{2}}(1;N)\lambda(1)+ \boldsymbol{\pi_{2}}(0;N)\mathbf{MP}, \tag{5.4.1b}\]

and for \(0<k<N\),

\[\boldsymbol{\pi_{2}}(k;N)[\mathbf{B}+\lambda(k)\mathbf{I}]=\boldsymbol{\pi_{2 }}(k\!-\!1;N)\mathbf{BQ}+\boldsymbol{\pi_{2}}(k\!+\!1;N)\lambda(k\!+\!1). \tag{5.4.1c}\]

(Remember that we still maintain the notation \(\mathbf{B}\!=\!\mathbf{V}^{-1}=\mathbf{M}[\mathbf{I}\!-\!\mathbf{P}]\).) \(\boldsymbol{\pi_{2}}(k;N)\) and associated \(r_{2}(k;N)\) retain Definition 5.1.4, including the standard notational assumption that

\[\boldsymbol{\pi_{2}}(N;N):=r_{2}(N;N)\mathbf{p}. \tag{5.4.1d}\]

Following the procedure we used in Chapter 4, we would like to solve fo \(\boldsymbol{\pi_{2}}(k;N)\) in terms of \(r_{2}(N;N)\), but (5.4.1a) does not allow us to do that directly because \(\mathbf{BQ}\) does not have an inverse. So we must start at the other end. Equation (5.4.1c) can be rewritten as

\[\boldsymbol{\pi_{2}}(0;N)\mathbf{M}[\mathbf{I}-\mathbf{P}]=\boldsymbol{\pi_{2 }}(1;N)\lambda(1),\]

or

\[\boldsymbol{\pi_{2}}(0;N)=\boldsymbol{\pi_{2}}(1;N)\mathbf{U}(0),\] (5.4.2a) where \[\mathbf{U}(0):=\lambda(1)\mathbf{V}. \tag{5.4.2b}\]

Next we look at (5.4.1c) for \(k=1\), while making use of (5.4.2a),

\[\boldsymbol{\pi_{2}}(1;N)

<!-- Pages 353-353 -->

and

\[\mathbf{BQ}=\lambda(k\!+\!1)\mathbf{A}(k)\mathbf{Q}\quad\text{and}\quad\mathbf{U} (k)\mathbf{BQ}=\lambda(k\!+\!1)\mathbf{Q}, \tag{5.4.4b}\]

exactly analogous to Lemma 4.1.1, for which this is a generalization.

**Proof:** Given that \(\mathbf{I}\boldsymbol{\epsilon^{\prime}}=\mathbf{Q}\boldsymbol{\epsilon^{\prime }}=\boldsymbol{\epsilon^{\prime}}\), all follows directly from the definition of \(\mathbf{A}(k)\) and \(\mathbf{U}(k)\) in (5.4.3). **QED**

Now assume that (it is certainly true for \(j=0\) and \(1\))

\[\boldsymbol{\pi_{2}}(j;N)=\boldsymbol{\pi_{2}}(j+1;N)\mathbf{U}(j)\quad\text{ for}\;\;j=0,\,1,\,\ldots,\,k-1, \tag{5.4.5}\]

and use it in (5.4.1c) to get

\[\boldsymbol{\pi_{2}}(k;N)[\mathbf{B}+\lambda(k)\mathbf{I}] =\boldsymbol{\pi_{2}}(k;N)\mathbf{U}(k\!-\!1)\mathbf{BQ}+ \boldsymbol{\pi_{2}}(k\!+\!

<!-- Pages 355-355 -->

find a recursive procedure that is efficient in both space and time, in studying \(\text{ME}/\text{M}/X//N\) loops for a sequence of values of \(N\).

The algorithm we are about to present is not necessarily the most efficient, but it shows how the matrices fit together. Define the auxiliary matrices for any \(n\geq 0\),

\[\mathbf{X}(n,n):=\mathbf{I},\] (5.4.7a) and for \[k<n\] \[\mathbf{X}(k,n):=\mathbf{U}(n-1)\mathbf{U}(n-2)\cdots\mathbf{U}(k)=\mathbf{U}( n-1)\mathbf{X}(k,n-1). \tag{5.4.7b}\]

This can be helpful in dealing with various objects. For instance, (5.4.6a) can be rewritten as

\[\mathbf{K}(N)=\sum_{k=0}^{N}\mathbf{X}(k,N). \tag{5.4.7c}\]

Then the vector and scalar probabilities, \(\boldsymbol{\pi_{2}}(k;N)\) and \(r_{2}(k;N)\), can be computed in the following way.

**Corollary 5.4.2** (Algorithm) To compute the vector and scalar queue-length probabilities of an \(\text{ME}/\text{M}/X//N\) loop for all \(N=1,2,\cdots,N_{\text{max}}\), do the following.

\(\cdot\) \(\mathbf{X}(0,0)=\mathbf{I}\)

\(\cdot\) \(\mathbf{K}(0)=\mathbf{I}\)

\(\cdot\) \(\text{FOR}\ N=1\ \text{TO}\ N_{\text{max}}\)

\(\cdot\) \(\mathbf{X}(N,N)=\mathbf{I}\)

\(\cdot\) \(\mathbf{K}(N)=\mathbf{I}+\mathbf{U}(N\!-\!1)\mathbf{K}(N\!-\!1)\)

\(\cdot\) \(r_{2}(N;N)=1/\Psi\left[\mathbf{K}(N)\right]\)

\(\cdot\) \(\text{FOR}\ k=0\ \text{TO}\ N-1\)

\(\cdot\) \(\mathbf{X}(k,N)=\mathbf{U}(N\!-\!1)\mathbf{X}(k,N\!-\!1)\)

\(\cdot\) \(\boldsymbol{\pi_{2}}(k;N)=r_{2}(N;N)\mathbf{p}\mathbf{X}(k,N)\)

\(\cdot\) \(r_{2}(k;N)=\boldsymbol{\pi_{2}}(k;N)\boldsymbol{\epsilon}^{\prime}=r_{2}(N;N) \Psi\left[\mathbf{X}(k,N)\right]\)

\(\cdot\) \(\text{END FOR}(k)\)

\(\cdot\) \(\text{END FOR}(N)\)

The mean queue length and other performance characteristics can be found by computing them directly. \(\blacksquare\)

There are no further insights we can gain without becoming more specific about the properties of \(\lambda(k)\). Letting \(\lambda(k)=k\lambda\) will not tell us much unless we do the calculations. If we let \(N\) become infinite, we can say very little unless

\[\lambda_{\infty}:=\lim_{N\to\infty}\lambda(N)<\infty,\]

and \(\rho:=\bar{x}_{1}\lambda_{\infty}<1\). In that case we would revert back to the steady-state \(\text{M}/\text{ME}/1\) open queue of Section 4.2, with arrival rate \(\lambda_{\infty}\). If the inequality is the other way around, (i.e., if \(\rho>1\)), we have a problem. We do not even know how to start without more information. However, we can, and in the next section, do solve those systems for which the load-dependent service rates are constant above a certain queue length.

<!-- Pages 356-356 -->

#### 5.4.2 Steady-State ME/M/\(C\) Queue

Let us assume that \(N>C>1\), and

\[\lambda(k)=\lambda(C)\quad\text{for}\;\;k\geq C. \tag{5.4.8}\]

What the values of \(\lambda(1)\), \(\lambda(2)\),\(\ldots\), and \(\lambda(C)\) actually are does not seem to be helpful for finding simpler solutions, so we leave them unspecified. Then by our own definition at the end of Section 2.1.5, this is an ME/M/\(C//N\)-type loop, but we do not emphasize that here. However, in Chapter 6, when we examine the M/ME/\(C//N\) loop, the generalization is significant, and is examined in detail.

Given our assumption, we see that (5.4.3) becomes

\[\mathbf{A}(k)=\frac{\lambda(C)}{\lambda(C)}\left[\mathbf{I}+\frac{1}{\lambda( C)}\mathbf{B}-\mathbf{Q}\right]=\mathbf{A}(C)\quad\text{for\,all}\;\;k\geq C.\] (5.4.9a) Then, \[\mathbf{U}(k)=\mathbf{U}(C)\quad\text{for all}\;\;k\geq C.\] (5.4.9b) This matrix plays a dominant role

<!-- Pages 359-359 -->

\[r_{2}(k|C)=g(C)\mathbf{\hat{u}_{c}}\mathbf{X}(k,C)\boldsymbol{\epsilon^{\prime}} \quad\text{for}\;\;0\leq k<C. \tag{5.4.17b}\]

When \(C=1\), these equations reduce to those in Theorem 5.1.2. We summarize the above with the following theorem.

**Theorem 5.4.3:** The steady-state probability vectors for the ME/M/\(C\) queue are given by Equations (5.4.15) to (5.4.17), where \(s_{c}\) is the smallest eigenvalue in magnitude of the matrix from (5.4.9a),

\[\mathbf{A_{c}}=\mathbf{I}+\frac{1}{\lambda_{c}}\mathbf{B}-\mathbf{Q},\]

with left eigenvector \(\mathbf{\hat{u}_{c}}\) normalized so that \(\mathbf{\hat{u}_{c}}\boldsymbol{\epsilon^{\prime}}=1\). It follows that \(s_{c}\) also satisfies the equation

\[s_{c}=B^{*}[\lambda_{c}(1-s_{c})].\]

The matrices \(\{\mathbf{A}(k)\,|\,0\leq k<C\}\) and their inverses \(\{\,\mathbf{U}(k)\,\}\), are given by (5.4.3). The matrices \(\{\,\mathbf{X}(k,\,C)\,|\,0\leq k<C\,\}\) are given by (5.4.7b), and \(\mathbf{K}(C)\) is defined by (5.4.11b). \(\blacksquare\)

The geometric parameter \(s_{c}\) has identical properties to the geometric parameter we discussed in Section 5.1.3 in relation to the ME/M/1 queue. The only distinction is using \(\lambda_{c}\) in the construction of \(\mathbf{A_{c}}\).

The reader should look closely at Equations (5.4.16) and (5.4.17) to see their similarity with Theorem 5.1.2, for \(C=1\). For \(k\geq C\), all the probability vectors are proportional to \(\mathbf{\hat{u}_{c}}\), and their magnitudes are geometrically distributed with ratio \(s_{c}\). However, for \(k<C\) they take on a different form, which is easy enough to calculate in specific cases, but about which little can be said in general.

**Exercise 5.4.1:** Let \(C=2\), and let \(\lambda_{2}=2\lambda\). Calculate the steady-state probabilities and the mean queue length of an \(E_{2}\)/M/2 queue, for \(\rho_{2}=\) 0.1, 0.3, 0.5, 0.7, 0.9, and 0.95. Compare the queue lengths with those for the M/M/2 queue for the same \(\rho_{2}\).

The accomplishments of this section correspond to what a random observer will see when viewing a system that has been in existence for a long time. We must go to the next section to find out what arriving and departing customers would see.

#### Arrival and Departure Points

What we do here exactly parallels what we did in Section 4.1.3 for load-independent loops. The generalization is direct, but we give new definitions to correspond to our focus on \(S_{2}\). We deal with ME/M/\(X\)/\(N\) loops first, and then specialize at the end to look at the ME/M/\(C\) queue.

<!-- Pages 360-360 -->

**Definition 5.4.2**: \(\mathbf{w_{2}}(k;N):=\) _steady-state vector probability of finding k customers at \(S_{2}\), and \(N-k\) customers at \(S_{1}\), between events. \([\mathbf{w_{2}}(k;N)]_{i}\) is the probability that the \(i\)th phase in \(S_{1}\) is busy (and there are \(k\) customers at \(S_{2}\)). \(\mathbf{w_{2}}(N;N)\) is defined to be proportional to \(\mathbf{p}\)._

Just as we did with the steady-state balance equations (5.4.1), we can write the balance equations for \(\mathbf{w_{2}}(k;\,N)\) directly, by replacing \(\lambda\) wherever it appears in Equations (4.1.3) by the appropriate \(\lambda(k)\). The reader might look again at Figure 5.4.1 before going on. The balance equations can be written directly from a generalization of Equations (4.1.9).

\[\mathbf{w_{2}}(N;\,N)=\mathbf{w_{2}}(N\!-\!1;N)[\lambda(N\!-\!1)\mathbf{I}+ \mathbf{M}]^{-1}\,\mathbf{B}\mathbf{Q}.\] (5.4.18a) For \[1\leq k\leq N-1\], \[\mathbf{w_{2}}(k;\,N)[\lambda(k)\mathbf{I}+\mathbf{M}]^{-1}[ \lambda(k)\mathbf{I}+\mathbf{B}]=\mathbf{w_{2}}(k\!-\!1;N)[\mathbf{M}+ \lambda(k\!-\!1)\mathbf{I}]^{-1}\mathbf{B}

<!-- Pages 361-361 -->

Arrivals at \(S_{2}\) result in an increase of its queue length, corresponding to (4) and (6) above. Keeping Definitions 5.1.2 to 5.1.4, we have [from term (6)]

\[\mathbf{a_{2}}(0;\,N)=G(N)\mathbf{w_{2}}(0;\,N)\mathbf{q^{\prime}p}\]

and [from term (4)]

\[\mathbf{a_{2}}(k;N)=G(N)\mathbf{w_{2}}(k;N)[\lambda(k)\mathbf{I}+\mathbf{M}] ^{-1}\mathbf{BQ}\qquad\text{for}\ \ 1\leq k\leq N-1.\]

There is no term for \(k=N\), because a customer cannot arrive at \(S_{2}\) and find that everyone (including himself) is already there. The \(G(N)\) is the normalizing constant to make the sum of the probabilities add up to \(1\). Next, using (5.4.19), we replace \(\mathbf{w_{2}}(k;\,N)\) with \(\boldsymbol{\pi_{2}}(k;\,N)\) to get

\[\mathbf{a_{2}}(0;N)=C(N)G(N)\,\boldsymbol{\pi_{2}}(0;\,N)\mathbf{BQ}\]

and

\[\mathbf{a_{2}}(k;\,N)=C(N)G(N)\boldsymbol{\pi_{2}}(k;\,N)\mathbf{BQ}\quad \text{for}\ \ 1\leq k\leq N\!-\!1.\]

These equations look rather uninteresting, being no different than the equivalent ones for load-independent systems. But we are dealing with steady-state phenomena, so \(\boldsymbol{\pi_{2}}\left(k;N\right)=\boldsymbol{\pi_{2}}(k\!+\!1;\,N)\mathbf{ U}(k)\) from (5.4.5). Furthermore, from Lemma 5.4.1\(\mathbf{B}\,\boldsymbol{\epsilon^{\prime}}=\lambda(k\!+\!1)\mathbf{A}(k) \boldsymbol{\epsilon^{\prime}}\), so

\[\boldsymbol{\pi_{2}}(k;\,N)\mathbf{BQ}=\lambda(k\!+\!1)\boldsymbol{\pi_{2}}(k ;\,N)\mathbf{A}(k)\mathbf{Q}=\lambda(k\

<!-- Pages 363-363 -->

The limiting expressions for these entities are just a little tricky. Let us define

\[\varrho_{c}:=1/\rho_{c}\]

and assume that \(\varrho_{c}<1\). First look at departures. Using (5.4.22a), (5.4.23), and (5.4.16a), we have

\[\mathbf{d_{2}}(k\,|\,C) =\lim_{N\to\infty}\frac{\lambda_{c}}{\Lambda(N)}\boldsymbol{\pi_ {2}}(k\!+\!1;N\,|\,C)\] \[=\lambda_{c}\,\bar{x}_{1}\,\boldsymbol{\pi_{2}}(k\!+\!1\,|\,C) =\frac{1}{\varrho_{c}}g(C)\,s_{c}^{k+1-C}\,\mathbf{\hat{u}_{c}

<!-- Pages 365-365 -->

Why do we bother defining this matrix yet again, when it is of such simple form? We answer that in the next chapter it is not so simple, even though the concept is the same.

First we must define the upside-down version of Definition 4.5.8.

_Definition 5.5.2_

\(\boldsymbol{\tau^{\prime}_{2u}}(k):=\) _mean first-passage time vector from \(k\) to \(k+1\). \([\boldsymbol{\tau^{\prime}_{2u}}(k)]_{i}\)_ is the mean time for the queue at \(S_{2}\) to reach \(k+1\) for the first time, given that the system started in state \(\{i\); \(k\}\). 

We can write down the equations for \(\boldsymbol{\tau^{\prime}_{2u}}(k)\) directly from its equivalent in Chapter 4. Thus (4.5.11a) and (4.5.11b) convert to

\[\boldsymbol{\tau^{\prime}_{2u}}(0)=\mathbf{V}\boldsymbol{\epsilon}^{\prime}\] (5.5.2a) and \[\boldsymbol{\tau^{\prime}_{2u}}(k)=\frac{1}{\lambda}\,\mathbf{U}\boldsymbol{ \epsilon}^{\prime}+\mathbf{U}\boldsymbol{\tau^{\prime}_{2u}}(k\!-\!1),\] (5.5.2b) where \[\mathbf{U}\] is defined by ( 4.1.4 ). The solution of these equations comes directly from ( 4.5.12 ): \[\boldsymbol{\tau^{\prime}_{2u}}(k)=\frac{1}{\lambda}\mathbf{U}\mathbf{K}(k)\, \boldsymbol{\epsilon}^{\prime}=\frac{1}{\lambda}[\mathbf{K}(k\!+\!1)-\mathbf{ I}]\boldsymbol{\epsilon}^{\prime},\] (5.5.2c) where \[\mathbf{K}(k)\] is the normalization matrix for the M/ME/1 / \[k\] queue, defined in ( 4.1.6 ).

Now we are ready to set up the formulas for time of queue growth, or are we? To do this, we must know the state the system is in originally. That is, we must know the initial vector \(\mathbf{p_{i}}\). If the queue (at \(S_{2}\)) is empty, what does that tell us about the system (i.e., what state is \(S_{1}\) in)? The initial vector certainly cannot be \(\mathbf{p}\), because that would imply that a customer just left \(S_{1}\), which in turn means that the same customer has just arrived at \(S_{2}\), contradicting our assumption that \(S_{2}\) is empty. If \(\varrho\) (which you recall is \(1/\lambda\bar{x}_{1}\)) is less than 1, there are two possibilities of immediate interest. We could assume that a customer has just departed \(S_{2}\) in a system that has been running for a long time. This corresponds to

\[\mathbf{p_{i}}=\frac{\mathbf{d_{2}}(0)}{d_{2}(0)}=\hat{\mathbf{u}}.\]

Then the mean time until the first arrival to the empty queue conditioned by a departure (also known as the mean idle time, or time between busy periods), is

\[t_{I}:=\mathbf{p_{i}}\boldsymbol{\tau^{\prime}_{2u}}(0)=\hat{\mathbf{u}} \mathbf{V}\boldsymbol{\epsilon}^{\prime}=\frac{1-\varrho}{1-s}\bar{x}_{1}\ \ \ \ \ (\varrho,\ s<1).\] (5.5.3a) We got the last part from ( 5.1.5e) and remembered that \[\rho=1/\varrho\]. As an aside, this formula gives us some idea of what the difference between \[s\] and \[\varrho\] means. If we are looking at an M/M/1 queue, then \[\varrho=s\], and the mean time until the next arrival is \[\bar{x}_{1}\], as expected. For other systems, we might look at Figure

<!-- Pages 366-366 -->

5.1.1 for insight. If \(s\) is greater (less) than \(\varrho\), we would expect to wait longer (less) than \(\bar{x}_{1}\) for the first customer to arrive.

The other possibility is to ask what a random observer would see. This corresponds to

\[\mathbf{p_{i}}=\frac{\boldsymbol{\pi_{2}}(0)}{r_{2}(0)}=\frac{\hat{\mathbf{u}} \mathbf{V}}{\hat{\mathbf{u}}\,\mathbf{V}\boldsymbol{\epsilon^{\prime}}}.\]

Thus the mean time for the first customer to arrive, as seen by a random observer, is [call it \(t_{r}(0)\)]

\[t_{r}(0):=\mathbf{p_{i}}\boldsymbol{\tau^{\prime}_{2\mathbf{u}}}(0)=\frac{ \hat{\mathbf{u}}\mathbf{V}^{2}\boldsymbol{\epsilon^{\prime}}}{\hat{\mathbf{u}} \mathbf{V}\boldsymbol{\epsilon^{\prime}}}.\]

We can actually get an interesting expression for this by solving for

\[\hat{\mathbf{u}}\mathbf{V}=\frac{1}{\lambda(1-s)}[\lambda\mathbf{p}\mathbf{V} -\hat{\mathbf{u}}]\hskip 28.452756pt(\varrho<1), \tag{5.5.3b}\]

and

\[\frac{\hat{\mathbf{u}}\mathbf{V}}{\hat{\mathbf{u}}\mathbf{V}\boldsymbol{ \epsilon^{\prime}}}=\frac{\varrho}{1-\varrho}[\lambda\mathbf{p}\mathbf{V}- \hat{\mathbf{u}}]. \tag{5.5.3c}\]

We put this all together to get

\[t_{r}(0)=\frac{\Psi\left[\mathbf{V}^{2}\right]}{(1-\varrho)\bar{x}_{1}}-\frac {1}{(1-s)\lambda}.\]

It is difficult to see what is going on here, because near \(\varrho=1\) both terms are unboundedly large, so their difference can be anything. Actually, their difference is finite. We leave it as an exercise to show [using (5.1.22b), (5.1.22c), and (5.1.23b)] that (we are 99.44% sure)

\[\lim_{\varrho\to 1_{-}}t_{r}(0)=\bar{x}_{1}\frac{1+C_{v}^{2}}{2}\left(1\ -\frac{s^{\prime\prime}(1)}{2}\cdot\frac{1+C_{v}^{2}}{2}\right).\]

Even when \(\varrho=1_{-}\), this expression is not simple, particularly when one notes, from (5.1.24a), that \(s^{\prime\prime}(1)\) is quite complicated. Only when we consider the M/M/1 queue does this simplify, for then \(s^{\prime\prime}(1)=0\) and \(C_{v}^{2}=1\), so \(t_{r}(0)=\bar{x}_{1}\). One should compare these results with the _residual times_ as given in (3.5.12d). There are, of course, any number of other possibilities that one could consider in setting up \(\mathbf{p_{i}}\), all of which would require more information about the history of the system. Now, if \(\varrho>1\), even though (5.5.2a) is still valid, we have nothing to go on for preparing the initial vector. In this case there is no such thing as the steady state, and after a "long period of time," the probability that no one will be at \(S_{2}\) is 0. Therefore, any initial condition must be based on some transient events. We must be given some special information ("\(S_{1}\) just woke up," or something).

Once there is someone at \(S_{2}\) (\(k>0\)), we can say something even if \(\varrho>1\). We can talk about the state of the system immediately after a customer arrives, and in fact this is the most important situation. After all, every increase in queue length is the result of an arrival (at \(S_{2}\)), so after the first increase,

<!-- Pages 367-367 -->

all subsequent increases begin their epochs with the initial vector \(\mathbf{p}\) (at \(S_{1}\)). The other two cases we described for \(k=0\) are still applicable. The initial vector for the time to rise from \(k\) to \(k+1\), conditioned on a departure, is

\[\mathbf{p_{i}}=\frac{\mathbf{d_{2}}(k)}{d_{2}(k)}=\hat{\mathbf{u}},\]

the same as for the empty queue. Similarly, the random observer, from (5.1.5b) and (5.1.5d), will see the same initial vector as a departing customer! Only when the queue is empty will she see something different. An arriving customer, however, will always see something different. (Speaking from a purely physical point of view, the arriving customer will see nothing special, because the initial vector refers to \(S_{1}\), the subsystem he left behind.) Thus we see that there are cases when departing customers, arriving customers, and random observers all see different behavior.

We could continue piling variations upon variations, but let us merely consider the mean time for the queue at \(S_{2}\) to grow to \(k\), given that the first customer has just arrived. Let us call this \(t_{2}(1\to k)\). Then [using the obvious convention that \(t_{2}(1\to 1)=0\)]

\[t_{2}(1\to k)=\sum_{l=1}^{k-1}\mathbf{p\prime_{2u}^{\prime}}(l)=\frac{1}{ \lambda}\sum_{l=1}^{k-1}\Psi\left[\mathbf{U}\mathbf{K}(l)\right].\]

This formula is easy enough to compute, based on what we know from Chapter 4; however, we indicate how the queue grows for large \(k\). We know that for \(\varrho>1\), \(\mathbf{K}(l)\) approaches a limit for large \(l\). Specifically [from (4.2.3)]

\[T:=\lim_{l\to\infty}\mathbf{p\prime_{2u}^{\prime}}(l)=\frac{1}{\lambda}\Psi \left[\mathbf{U}\mathbf{K}\right]=\frac{1}{\lambda}\Psi\left[(\mathbf{I}- \mathbf{U})^{-1}-\mathbf{I}\right]\]

\[=\frac{1}{\lambda}\left[\frac{1}{1-1/\varrho}-1\right]=\frac{1/\lambda}{ \varrho-1}\quad\text{for}\ \ \varrho>1.\]

The expression is independent of everything except \(\varrho\) and \(\lambda\), and tells us that once the queue grows large enough, it will continue to grow linearly with time. Each incremental increase will take the same amount of time (on average, of course). Because \(T\) is the mean time for the queue to grow by \(1\), its reciprocal can be considered to be the rate at which the queue grows. This leads to

\[\frac{1}{T}=\lambda\varrho-\lambda=\frac{1}{\bar{x}_{1}}-\lambda\quad\text{ for}\ \ \varrho>1.\]

We have the perfectly reasonable result that the rate of queue growth is equal to the rate of arrivals minus the rate of departures from \(S_{2}\). In other words, the queue-length growth curves for all ME/M/1 queues approach straight lines, and have the same slope. You should compare this result with that for the M/M/1 queue [Equation (2.3.2a)] to see that, in fact, the two are asymptotically equal. Keep in mind, however, that this is true only for \(\varrho>1\)! When \(\varrho<1\), asymptotic behavior is completely different. We must be very

<!-- Pages 368-368 -->

careful when conceptually replacing _probability flow rates_ with _physical flow rates_. This is meaningful only in very heavy traffic.

For \(\varrho<1\), the normalization matrix \(\mathbf{K}(l)\) does not approach a limit but, rather, grows geometrically as \((1/s)^{l}\). We saw this in deriving the steady-state solution for the ME/M/1 queue. For large \(l\), and from (5.1.3),

\[\lambda\mathbf{p}\mathbf{r}_{\mathbf{2u}}^{\prime}(l)\approx\Psi\left[ \mathbf{U}\mathbf{F}\right]\left(\frac{1}{s}\right)^{l}=\frac{(\mathbf{u} \boldsymbol{\epsilon^{\prime}})(\mathbf{p}\mathbf{v}^{\prime})}{\varrho(1-s) }\left(\frac{1}{s}\right)^{l}\quad(\text{for}\ \ \varrho<1).\]

Now, let us define

\[\mathbf{D}(\sigma):=[\mathbf{I}+\sigma\mathbf{V}]^{-1}.\]

[We have actually used this useful matrix before, in (4.2.8b). It is the generator of the Laplace transform of \(b(x)\).] Then it can be shown, when \(\sigma=\lambda\left(1-s\right)\), that

\[\hat{\mathbf{u}} =\lambda\mathbf{p}\mathbf{V}\,\mathbf{D}(\sigma), \tag{5.5.4a}\] \[\mathbf{v}^{\prime} =c\lambda\mathbf{V}\,\mathbf{D}(\sigma)\boldsymbol{\epsilon^{ \prime}}, \tag{5.5.4b}\]

and

\[c=(\mathbf{u}\boldsymbol{\epsilon^{\prime}})(\mathbf{p}\mathbf{v}^{\prime})= \frac{1}{\Psi\left[(\lambda\mathbf{V}\mathbf{D})^{2}\right]}=\frac{(1-s)^{2}} {1-2s+\Psi\left[\mathbf{D}^{2}\right]}. \tag{5.5.4c}\]

From Equations (4.4.1), \(c\) can also be written as

\[\frac{1}{c}=\frac{1}{1-s}\left[1-\lambda\int_{\mathrm{o}}^{\infty}xe^{-\sigma x }b(x)\,dx\right]. \tag{5.5.4d}\]

We put this all together, coming up with a form that is valid for G/M/1 queues:

\[\mathbf{p}\mathbf{r}_{\mathbf{2u}}^{\prime}(l)\approx\frac{\bar{x}_{1}}{1- \lambda\int_{0}^{\infty}xe^{-\lambda(1-s)x}b(x)dx}\left(\frac{1}{s}\right)^{l},\ \ \ \ \varrho<1.\]

Compare this equation with (2.3.2a) for the M/M/1 queue. Both formulas are of geometric form, therefore we know from the arguments given in deriving (2.3.4a) that the queue length grows logarithmically with time. However, the rates of growth vary enormously, depending on what distribution function is generating the arrival process.

**Example 5.5.1:** We have combined the data from Figure 4.5.4, for the M/M/1 and M/\(E_{2}/1\) queues with that for \(t_{2}(1\to n)\) for the \(E_{2}\)/M/1 queue, and plotted them in Figure 5.5.1. Even without the extra curves, the two figures are different. First of all, the \(x\)- and \(y\)-axes are interchanged. Second, the Chapter 4 curves give the mean time to grow from 0 to \(n\), but here all curves give the time to go from 1 to \(n\). Looking at this figure, when \(\rho\) (or \(\varrho\)) is much greater than 1, all three queues give virtually the same growth curve. This agrees with our previous argument that \(1/T\), the asymptotic growth rate, depends only on the difference between the arrival and the service rates. However, when \(\rho\) (or \(\varrho\)) is less than 1, the time for growth is exponential (or

<!-- Pages 371-371 -->

This vector is also independent of \(k\), but unlike its first-passage matrix, we can solve for it directly, to get,

\[\boldsymbol{\tau^{\prime}_{2d}}:=\left[\lambda\mathbf{I}-\mathbf{H_{2d}}\, \mathbf{B}\,\mathbf{Q}\right]^{-1}\boldsymbol{\epsilon^{\prime}}. \tag{5.5.7b}\]

This can be rewritten in another form with the use of Lemma 4.2.1:

\[\boldsymbol{\tau^{\prime}_{2d}}:=\frac{1}{\lambda}\left[\mathbf{I}+\frac{1}{ \lambda-\Psi\left[\mathbf{H_{2d}}\,\mathbf{B}\right]}\mathbf{H_{2d}}\,\mathbf{ B}\,\mathbf{Q}\right]\boldsymbol{\epsilon^{\prime}}, \tag{5.5.7c}\]

so if we can find \(\mathbf{H_{2d}}\), then we get \(\boldsymbol{\tau^{\prime}_{2d}}\).

#### Mean Time for a Busy Period

The mean time for the queue to drop by one, given that a customer has just arrived is, using (5.5.7c),

\[t_{2d}:=\mathbf{p}\,\boldsymbol{\tau^{\prime}_{2d}} =\frac{1}{\lambda}\left[1+\frac{\Psi\left[\mathbf{H_{2d}}\, \mathbf{B}\right]}{\lambda-\Psi\left[\mathbf{H_{2d}}\,\mathbf{B}\right]}\right]\] \[=\frac{1}{\lambda-\Psi\left[\mathbf{H_{2d}}\,\mathbf{B}\right]} \quad\text{for}\ \ \varrho<1. \tag{5.5.7d}\]

This is also the mean time for the _busy period_, but it is valid only when \(\varrho<1\). Otherwise the busy period may never end. Even though \(\mathbf{H_{2d}}\) is meaningful for all \(\varrho\), when \(\varrho\geq 1\), the term \(\Psi\left[\mathbf{H_{2d}}\,\mathbf{B}\right]\geq\lambda\), so (5.5.7d) is infinite or negative.

Note that (2.3.7d) gives an alternate expression for the mean busy period. In order for the two to be equal, we must have

\[\Psi\left[\mathbf{H_{2d}}\,\mathbf{B}\right]=\lambda\,s.\] (5.5.8a) This leads to the most interesting result that the mean busy period and the mean system time for a G/M/1 queue are equal! Compare ( 5.5.7d) with ( 5.1.7c ) to get \[\operatorname{\mathbbm{E}}[T_{2}]=t_{2d}=\frac{1/\lambda}{1-s}\;.\] (5.5.8b) Equation ( 5.5.8a ) can also be used to simplify ( 5.5.7c ).

#### Exercise 5.5.2:

Prove that (5.5.8) is true by using (2.3.7d), and noting that \(t_{I}\) is given by (5.5.3a). That is, take

\[\lim_{m,N\to\infty}R_{b}(m)=\frac{t_{d}}{t_{d}+t_{I}}.\]

For single server queues, this limit is the fraction of time the server is busy, which for G/M/1 queues is \(\varrho\). Also, \(t_{d}\) is the mean service time, namely, \(1/\lambda\).

<!-- Pages 372-372 -->

To take a closer look at the differences between M/G/1 and G/M/1 queues, we have calculated the mean time for the busy periods for several different distributions and plotted them in Figures 5.5.2 and 5.5.3.

**Example 5.5.2:** Recall that all M/G/1 queues have the same mean time

for their busy periods, so they are all represented by the same curve, labeled M/M/1 in Figures 5.5.2 and 5.5.3. Yet the figures show that different ME/M/1 queues vary all over the place. There is some order for the examples chosen here. From (5.1.23d), as \(\varrho\) approaches 1, bigger \(C_{v}^{2}\) for the interarrival time distribution, goes with larger mean system time. This not true for all \(\varrho\). In fact, the hyper-Erlangian function discussed in Section 3.2.3.1 [\(E_{2}(x)\)] yields a mean system time that is below that for the M/M/1 queue when \(\varrho\) is small, and crosses it as \(\varrho\) increases and first crosses and then joins the \(H_{2}\)/M/1 curve with the same \(C_{v}^{2}\) as \(\varrho\) approaches 1.

The figures certainly show that the arrival pattern is critically important when studying busy periods, and system times. Recall from Theorem 5.1.4 that the behavior of \(s\) near \(\varrho=0\) depends on \(b^{(\ell)}(0)\), the interarrival time distribution and its derivatives at \(x=0\), and not on its moments. In particular, if \(b(0)=0\) (this includes all Erlangian and hyper-Erlangian

Figure 5.5.2: Mean time of a busy period for various ME/M/1 queues, as a function of \(\varrho\). These curves also represent the mean system times, because the two are equal. All M/G/1 queues have the same mean busy period (but different mean system times), so all are equal to the curve labeled M/M/1. As \(\varrho\to 1\), the busy periods rank themselves according to \(C_{v}^{2}\). The hyper-perxponential and the hyper-Erlangian functions have \(C_{v}^{2}=5.0388\), and the Erlangians have \(C_{v}^{2}=1/n\), for \(n=2\), 10, 20, and 30. The D/M/1 queue bounds all these curves from below, and is virtually indistinguishable from the \(E_{30}\)/M/1.

<!-- Pages 373-373 -->

functions) then the mean time for a busy period (and the mean system time) has 0 slope at \(\varrho=0\) (as in Figure 5.5.2). When multiplied by \((1-\varrho)\) (as in figure 5.5.3) the resulting curves have negative slopes at \(\varrho=0\).

As our last subject in this chapter, we discuss the _k-busy period_. If we knew the state the system was in at the beginning, the first-passage time for the queue at \(S_{2}\) to drop by 1 is simply \(\mathbf{p_{i}}\boldsymbol{r_{2d}}\). At that moment, the system is in state \(\mathbf{p_{i}}\mathbf{H_{2d}}\), so the mean first-passage time to drop by one more is simply \(\mathbf{p_{i}}\mathbf{H_{2d}}\boldsymbol{r_{2d}}^{\prime}\), and the time to drop by two is the sum of the two terms. In general, then, the time it takes for an ME/M/1 queue to drop by \(k\) is given by the expression

\[\sum_{l=0}^{k-1}\mathbf{p_{i}}(\mathbf{H_{2d}})^{l}\,\boldsymbol{r_{2d}}^{ \prime}.\]

As with the M/G/1 queue, if there were \(k\) customers in the queue in the first place, this is the time for the \(k\)-busy period, conditioned by \(\mathbf{p_{i}}\). If the queue was longer than \(k\) at the start, this would still be the time for the queue to decrease by \(k\) for the first time.

It is hoped that the reader is sufficiently skilled by now to be able to set up the equations for the probabilities of queue growth, the \(\mathbf{W_{x}}\), where \(\mathbf{x}\) is one of \(\mathbf{2u}\), \(\mathbf{2m}\), or \(\mathbf{2d}\). Therefore, we leave those items as exercises.

Figure 5.5.3: Mean time of a busy period multiplied by \(\boldsymbol{(1-\varrho)}\), for the same ME/M/1 queues as given in Figure 5.5.2. Note that only the M/M/1 queue yields a straight (and horizontal) line. All the \(E_{k}/\)M/1 queues have negative slope at \(\varrho=0\). This is also true of all interarrival time distributions that have \(b(0)=0\), including those with \(C_{v}^{2}>1\), as shown by the curve for the \(\mathit{HE}_{2}(x)\) distribution. Note that only the M/M/1 queue yields a horizontal straight line, and all curves (for interarrival time distributions with \(C_{v}^{2}<\infty\)) are finite at \(\varrho=1\).

<!-- Pages 374-374 -->

## Chapter 3 M/G/CTYPE SYSTEMS

_Having two bathrooms ruined the capacity to cooperate._

Margaret Mead

The title of this chapter implies that there is more here than M/G/C queues. The straightforward extension of Chapter 4 allows one to have \(C\) identical servers serving up to \(C\) customers independently and simultaneously. But when we set up those equations we find that they apply to a more general class of systems where the active customers can actually interfere with each other while being served. This can be used as a basis for studying clusters of workstations that must share resources such as a communications channel or central disc. We call such a system a _generalized_**M/G/C//N queue**_, where \(N\) is the total number of customers in the system. Interestingly enough, when \(N=C\) then the steady-state soution is the same as for the single class _Jackson network_[16], but when \(N>C\) the well-known _product form_ solutions are no longer valid, and one must resort to the matrix techniques described here.

### 3.1 Introduction

In previous chapters when dealing with nonexponential distributions, we always assumed that only one customer was active at a time at \(S_{1}\). We did look at multiple servers, but only if \(S_{i}\) was exponential, introducing the idea of a load-dependent server (Sections 2.1.5 and 5.4). In doing this, it was not necessary to distinguish between:

1. A subsystem containing a single server that works twice as fast on one customer when a second one is present;

2. A subsystem that has two active servers, one for each customer.

In fact, the only way the two cases can be distinguished is by marking the customers so as to tell if they left in the same order in which they arrived. This has become of interest in recent years, and is called the _resequencing problem_. LAQT has been used successfully in analyzing the departure process of an M/M/\(C\) queue where customers must leave in the same order in which they arrived [14]. Because we have made our customers indistinguishable, we have not bothered to consider this at all, nor can we consider it here without expanding our state space.

<!-- Pages 375-375 -->

We cannot get away so easily when dealing with nonexponential servers. Case 1 has had few realistic applications, but it can be used in studying queues with, for instance, _discouraged arrivals_ or _restricted processor sharing_*. It is modeled by multiplying the completion rate matrix \(\mathbf{M}\) by a constant factor when a second customer arrives, leaving the dimension and internal state description of \(S_{1}\) otherwise unchanged. This turns out to be formally identical to the description of ME/M/\(C\)//\(N\) loops in Section 4.4, except that the load-dependence factor depends on the number of customers at \(S_{1}\) instead of the number at \(S_{2}\). We discuss this further when we look at processor sharing.

Footnote *: This has been done recently by Feng Zhang [20] in examining computer systems where a restricted number of jobs can share the CPU

The second case is much more complicated. When a second customer arrives, as always, he begins service by going to phase \(i\) with probability \(p_{i}\), but the first customer is already in service and is at some other phase. Furthermore, when one of the customers leaves, the other customer is still in service, in some phase determined by the system's past. Put differently, a departing customer does not leave behind the empty state. We must therefore set up a formalism that keeps track of where both customers are. This is normally done by building a _direct product space_, the most common convention being the _Kronecker product_. However, if the service times for the two customers are identically distributed and they are not marked, one can use a _Reduced-Product_ (RP) _space_. The direct product spaces have dimension \(m^{C}\) for \(C\) iid customers, but the RP space has dimension

\[D_{RP}(m,\,C)=\left(\begin{array}{c}C+m-1\\ C\end{array}\right).\]

This amounts to a reduction of dimensions by a factor that approaches \(C!\).

We have to introduce new symbols and concepts here, hence it is best to start with the simplest extension possible. Therefore, in the following section we set up the formalism, and find the steady-state solution of a system where \(S_{1}\) has exactly two identical ME servers (i.e., the M/ME/2//\(N\) loop). In doing this, we have selected a three-phase ME server as an example. In Section 6.3 we extend this to \(C\) servers, for by then it will be easier for the reader to follow the notation.

After that, we show that the formulas are actually applicable to a more general class of systems, which we call "generalized M/G/\(C\)//\(N\) systems." With little more than a change of notation and a slight generalization of some parameters, we show that we are suddenly dealing with a network of queues. When \(N\leq C\), our generalized network is equivalent to the single-class _Jackson network_, and we spend some time discussing the connection. We then extend the model further to allow \(S_{2}\) to be a load-dependent server, as we did in Section 5.4. This is potentially an important extension, because it is the correct treatment of _times sharing systems_ with _population-size constraints_ (i.e., when \(N>C\)).

When doing all this, we find that the equations are still algebraically manipulable but too complex to reduce to simple formulas. Thus we describe in

<!-- Pages 376-376 -->

detail algorithms that allow the user to get computational results for particular systems. Our formalism reduces the dimensions of all relevant matrices to their bare minima. (At present, at least, it is impossible to do it with smaller matrices.) Even so, problems can quickly become intractable if \(C\) and/or \(m\) become too large, so we discuss the computational complexity of the algorithms.

In Section 6.4 we study the open M/G/\(C\) system in the usual way by letting \(N\) become unboundedly large. The reverse game, which considers systems where \(S_{1}\), even at full capacity, is slower than \(S_{2}\) (i.e., the generalization of \(\rho>1\)), leads to a _semi-Markov arrival process_ to \(S_{2}\). This is treated in Section 6.5.2, but a full discussion of semi-Markov processes is postponed until Chapter 8. In the rest of Section 6.5 we look at some transient phenomena, including those related to the busy periods. Some of these are potentially important in studying the reliability of systems and rush-hour traffic.

Because of time and space limitations, we have foregone the pleasure of fully developing the formulas for departure and arrival times, even though it should prove quite interesting, with several new insights. Its treatment can be found in a series of papers by Ahmed Mohamed and his thesis [12].

We mention that much of this chapter is an outgrowth of material in Aby Tehranipour's PhD thesis [10] and related publications. Recent applications and extensions have been carried out by Ahmed Mohamed [12] and Feng Zhang [14].

### 6.2 Steady-State M/Me/2//_N_ Loop

Consider the queueing system in Figure 6.2.1. It is identical to Figure 4.1.1 except that now \(S_{1}\) contains two identical ME servers. Previously, each subsystem contained one ME server, so there was no real distinction between \(S_{1}\) and a server. Thus the statement, "The subsystem is in state \(i\)," meant the same as the statement, "The active customer is at phase \(i\)." Now that \(S_{1}\) contains two servers, and each server is made up of \(m\) phases, we must describe where both customers are if there are two or more customers at \(S_{1}\). Definition 6.2.2 makes this clear.

#### 6.2.1 Definitions

The process is as follows. No more than two customers can be active in subsystem \(S_{1}\) at any one time, one being in each of the servers. When a customer completes service at either server, he leaves \(S_{1}\) and joins the queue at \(S_{2}\) (still exponential), while at the same time another customer (if one is available) takes his place at the momentarily idle server. Any other customer who was active in \(S_{1}\) at the time the first one finished continues unperturbed. Each of the servers is described by the same objects introduced in Chapter 3: **p**, \(\mathbf{q^{\prime}}\), \(\mathbf{\epsilon^{\prime}}\), **P**, **M**, **B**, and **V**. As before, \(N\) is the number of customers in the system, and \(n\) is the number of customers at \(S_{1}\), including the ones who are being served. Then we have the following definition.

<!-- Pages 378-378 -->

state \(\{i;\,n;\,N\}\)," with the understanding that \(i\in\Xi_{2}\) if \(n\geq 2\) (i.e., \(i=\{i_{1},\,i_{2}\}\)). 

There is an alternative state space definition that is equivalent to this. Instead of listing the phases that are active, we can enumerate the number of customers at each phase. This requires an \(m\)-vector of nonnegative integers whose sum is 2. Although this convention seems more verbose, it proves to be more useful when we consider systems in which \(C>2\) or when we go to the generalized system. For now, we use the definition as given.

Next we define the probability vectors, and their associated scalars, needed for the work of this chapter. We use the obvious notation \(\boldsymbol{\epsilon^{\prime}_{k}}\) for the \(D(k)\)-dimension column vector of all 1's. We also use \(\mathbf{I_{k}}\) for the identity matrix of dimension \(D(k)\).

**Definition 6.2.3**: \([\boldsymbol{\pi_{1}}(1;N)]_{i}:=\) _probability that only one customer is at \(S_{1}\) (with \(N-1\) at \(S_{2}\)), and the system is in internal state \(i\in\Xi_{1}\) (i.e., the customer is at phase \(i\) in either server in \(S_{1}\)). \(\boldsymbol{\pi_{1}}(1;N)\) is a vector with \(D(1)\) components. \(r(1;N)=\boldsymbol{\pi_{1}}(1;N)\,\boldsymbol{\epsilon^{\prime}_{1}}\) is the associated scalar probability. _

**Definition 6.2.4**: \([\boldsymbol{\pi_{2}}(n;N)]_{i}:=\) _probability that there are \(n\geq 2\) customers at \(S_{1}\)\((\)with \(N-n\) at \(S_{2}\)), and the system is in internal state \(i=\{i_{1},\,i_{2}\}\in\Xi_{2}\) (i.e., the two active customers are at phases \(i_{1}\) and \(i_{2}\) one in each of the two servers in \(S_{1}\)). \(\boldsymbol{\pi_{2}}(n;N)\) is a \(D(2)\)-vector, and \(r(n;N)=\boldsymbol{\pi_{2}}(n;N)\,\boldsymbol{\epsilon^{\prime}_{2}}\) is the associated scalar probability. _

Note that the subscript \(k\) on \(\boldsymbol{\pi_{k}}(n;\,N)\) stands for the number of customers active in \(S_{1}\). Thus our convention differs from the one we used in Chapter 5. Strictly speaking, the subscripts are unnecessary because they correlate with the first integer in the argument (\(k=n\) for \(n\leq 2\), and \(k=2\) for \(n\geq 2\)); however, they denote objects of different dimensions, therefore we include them both for emphasis. According to this convention, in this chapter we use the subscript \(k\) to denote any object that applies only to space \(\Xi_{k}\) or, if it is an object connecting two spaces (nonsquare matrices), \(k\) will correspond to the higher-numbered space.

Although we wish to avoid sounding too abstract, we must say something about the connection between our _state space_\(\Xi_{k}\), and the vector spaces on which our matrices operate. We have defined \(\Xi_{k}\) to be a set with \(D(k)\) elements. We could think of each element as being a _unit vector_ in a \(D(k)\)-dimensional vector space. Consider the set of row vectors with \(D(k)\) components. Then each state \(i\in\Xi_{k}\) corresponds to one such vector with a 1 in one position, and a 0 in all the other positions. These states form a complete basis for the \(D(k)\) dimensional vector space, because every vector in that space can be written as a linear combination of the _basis states_, or _basis vectors_. This is such a natural correspondence that we can usually get away without

<!-- Pages 379-379 -->

having to make a distinction between the set and the vector space its members generate. Remember, though, that \(i\) stands for several things itself when \(k>1\).

Consistent with the above, we proceed to rename several of our previously known operators. First, the completion-rate matrix for states in \(\Xi_{1}\), \(\mathbf{M_{1}}:=\mathbf{M}\), is a diagonal matrix whose \((ii)\)th element \([\mathbf{M_{1}}]_{ii}\), is the probability rate of leaving state \(i\in\Xi_{1}\) by way of a completion inside \(S_{1}\). The transition matrix for \(\Xi_{1}\) is \(\mathbf{P_{1}}:=\mathbf{P}\), and \(\mathbf{V_{1}}=\mathbf{B_{1}}^{-1}:=\mathbf{V}\). We proved in Section 3.5.4, in the discussion surrounding Lemma 3.5.2, that an exponential server with feedback is equivalent to an exponential server without feedback, but with service rate reduced to \((1-\theta)\mu\), where \(\theta\) is the feedback probability. This implies that we can assume without loss of generality that \([\mathbf{P_{1}}]_{ii}=0\).+ We do that here, because it simplifies our examples. However, in Section 6.3.2 we allow \(P_{ii}\) to be nonzero. There is no need to relabel \(\mathbf{Q}\), \(\mathbf{p}\), and \(\mathbf{q^{\prime}}\), but we must define a new set of operators that operate on vectors in \(\Xi_{2}\). First we define the completion rate matrix.

Footnote †: Note: If we had not assumed that \([\mathbf{P_{1}}]_{ii}:=0\), we would have had to consider the additional possibility that \(i=j\).

**Definition 6.2.5**: \(\mathbf{M_{2}}\) _is a diagonal matrix whose \((ii)\)th element is the probability rate of leaving the state \(i\in\Xi_{2}\) by way of a completion in \(S_{1}\). By our definition of this system, \([\mathbf{M_{2}}]_{ii}=\mu_{i_{1}}+\mu_{i_{2}}\)._

The following is another \(\Xi_{2}\)-space object, the transition matrix.

**Definition 6.2.6**: \([\mathbf{P_{2}}]_{ij}:=\) _probability of going to state \(j\in\Xi_{2}\) upon a completion in \(S_{1}\), given that the system is in internal state \(i\in\Xi_{2}\). \(\mathbf{P_{2}}\) is a (nonisometric) transition matrix for states in \(\Xi_{2}\), (i.e., \(\mathbf{P_{2}}\,\boldsymbol{\ell_{2}^{\prime}}\neq\boldsymbol{\ell_{2}^{ \prime}}\))._

Assume that \([\mathbf{P_{1}}]_{ii}=0\), and recall that only one customer can change his phase at a time. Then the elements of \(\mathbf{P_{1}}\) are related to \(\mathbf{P_{2}}\) in the following way.

\[[\mathbf{P_{2}}]_{ij}=0\quad\text{unless}\quad\{i_{1},\,i_{2}\}\cap\{j_{1},\, j_{2}\}\]

contains exactly one element.+ Let the common element be called \(h\). Call the other member of the \(i\)-pair, \(\gamma\), and the other member of the \(j\)-pair, \(\nu\). Then, if there is exactly one element in common,

Footnote †: Note: If we had not assumed that \([\mathbf{P_{1}}]_{ii}:=0\), we would have had to consider the additional possibility that \(i=j\).

\[[\mathbf{P_{2}}]_{ij}=[\mathbf{P_{1}}]_{\gamma\nu}\frac{\mu_{\gamma}}{[\mathbf{ M_{2}}]_{ii}},\quad\,i_{1}\neq i_{2},\]

and

\[[\mathbf{P_{2}}]_{ij}=[\mathbf{P_{1}}]_{\gamma\nu},\quad\,i_{1}=i_{2}.\]

The reason for this is as follows. If \(i_{1}\neq i_{2}\), because only one active customer can move at a time, the probability that it is the customer at phase \(\gamma\) is

<!-- Pages 389-389 -->

probability that the active customers in \(S_{1}\) are collectively in state \(i\in\Xi_{k}\). We adhere to the notation \(k=n\) if \(n\leq C\), and \(k=C\) otherwise. \(r(n;N)=\boldsymbol{\pi_{k}}(n;N)\,\boldsymbol{\epsilon_{k}^{\prime}}\) is the associated scalar probability. 

Note that the relationship between \(k\) and \(n\) implies that \(\boldsymbol{\pi_{k}}(n;N)\) depends on \(C\) as well. So we probably should use the notation \(\boldsymbol{\pi_{k}}(n;N\,|\,C)\). However, in any application it is assumed that \(C\) (the maximum number of customers that can be active at any time), will not change. Therefore, \(\boldsymbol{\pi_{k}}\)'s dependence is left implicit. But the reader must keep in mind that \(\boldsymbol{\pi_{k}}(n;N)\) for one value of \(C\) is different from the comparable component when applied to a system with a different \(C\).

_Definition 6.3.4_

\(\left[\mathbf{R_{k}}\right]_{ij}:=\) _probability that a customer, who upon entering \(S_{1}\) and finding it in internal state \(i\in\Xi_{k-1}\), will go to the server and phase that puts the system in state \(j\in\Xi_{k}\). \(\mathbf{R_{k}}\) is a \(D(k-1)\times D(k)\)-dimensional matrix with the property that \(\mathbf{R_{k}}\,\boldsymbol{\epsilon_{k}^{\prime}}=\boldsymbol{\epsilon_{k-1 }}\). We could let \(\mathbf{p=R_{1}}\) if we so choose. 

For descriptive purposes we think of the index \(i\) as representing the set \(\{i_{1},\,i_{2},\,\ldots,\,i_{l},\,\ldots,\,i_{k}\}\) (which by Definition 6.3.1 it really is), with the same for \(j\). Then we can say that the matrix element \(\left[\mathbf{R_{k}}\right]_{ij}\) is \(0\) unless

\[i\cap j=i,\quad\text{where}\quad i\in\Xi_{k-1}\;\;\text{and}\;\;j\in\Xi_{k}.\]

Remember, by their definition, the set \(j\) has one more member than the set \(i\), so there must be exactly one distinct member of \(j\) (possibly appearing more than once in the set) which is not in \(i\) in order for \(\left[\mathbf{R_{k}}\right]_{ij}\) to have a nonzero value. Then, as a direct generalization of the discussion following Definition 6.2.7, call that one element \(\nu\), and

\[\left[\mathbf{R_{k}}\right]_{ij}=p_{\nu}\quad\text{if}\;\;i\,\cap\,j=i. \tag{6.3.2a}\]

_Definition 6.3.5_

\(\left[\mathbf{Q_{k}}\right]_{ij}:=\) _probability that a customer, upon leaving \(S_{1}\) when the system was in state \(i\in\Xi_{k}\), leaves the system in state \(j\in\Xi_{k-1}\) after he exits._

This matrix is of dimension \(D(k)\times D(k-1)\). If we chose, we could have let \(\mathbf{q^{\prime}}=\mathbf{Q_{1}}\). 

Here \(\left[\mathbf{Q_{k}}\right]_{ij}:=0\), unless \(i\,\cap\,j=j\). We now have a little generalization problem. Let \(\nu\) be the left-over element. It is possible that in the set, \(i=\{i_{1},\,i_{2},\,\cdots,\,i_{k}\}\), \(i_{l}=\nu\) appears more than once; then any one of those customers could complete service and leave. So let \(\alpha_{\nu}\) be the number of times \(\nu\) appears in the set \(i\); then for \(i\in\Xi_{k}\) and \(j\in\Xi_{k-1}\),

\[\left[\mathbf{Q_{k}}\right]_{ij}:=\frac{\alpha_{\nu}\mu_{\nu}\mathbf{q}_{\nu} }{[\mathbf{M_{k}}]_{ii}}\quad\text{for}\;\;i\,\cap\,j=j. \tag{6.3.2b}\]

Go back to Definition 6.2.8, and verify that this formula actually matches both conditions there, for \(k=2\).

Our last definition of this set is the transition matrix of space \(\Xi_{k}\).

<!-- Pages 392-392 -->

In general, we define the \(D(k)\times D(k)\)-dimensional matrices,

\[{\bf U}_{\bf k}(N\,|\,C):=\lambda[{\bf B}_{\bf k}+\lambda{\bf I}_{\bf k}-{\bf R}_{ \bf k+1}\,{\bf U}_{\bf k+1}(N\,|\,C)\,{\bf M}_{\bf k+1}\,{\bf Q}_{\bf k+1}]^{-1}. \tag{6.3.7b}\]

Then we can write

\[{\bf\pi_{k}}(k;N)={\bf\pi_{k-1}}(k-1;N){\bf R}_{\bf k}{\bf U}_{\bf k}(N\,|\,C) \quad\mbox{for}\ \ 1\leq k<C. \tag{6.3.8}\]

Clearly, the matrices \({\bf U}_{\bf k}(N\,|\,C)\) are very different from the matrices, \({\bf U}_{\bf e}(n)\). Take note of the subtle notational differences. This actually parallels much of Section 5.4.2.

Before collecting the foregoing formulas in a theorem, we wish to state and prove the following lemma concerning the matrices \({\bf U}_{\bf k}(N\,|\,C)\) and \({\bf U}_{\bf e}(n)\), which is directly related to Lemma 5.4.1.

**Lemma 6.3.1:** Let \({\bf U}_{\bf c}(n)\) be defined by (6.3.6a) and (6.3.6c). Then

\[{\bf U}_{\bf c}(n)\,{\bf B}_{\bf c}\,\mathbf{\epsilon}^{\prime}_{\bf e }=\lambda\mathbf{\epsilon}^{\prime}_{\bf e}\quad\mbox{for}\ \ n\geq C. \tag{6.3.9a}\]

Furthermore, let \({\bf U}_{\bf k}(N\,|\,C)\) be defined by Equations (6.3.7). Then

\[{\bf U}_{\bf k}(N\,|\,C){\bf B}_{\bf k}\,\mathbf{\epsilon}^{\prime}_ {\bf k}=\lambda\mathbf{\epsilon}^{\prime}_{\bf k}\quad\mbox{for}\ \ 1\leq k\leq C. \tag{6.3.9b}\]

\(\blacksquare\)

**Proof:** First note, by postmultiplying (6.3.6a) with \({\bf B}_{\bf c}\,\mathbf{\epsilon}^{\prime}_{\bf e}\), that

\[{\bf U}_{\bf c}(0){\bf B}_{\bf c}\,\mathbf{\epsilon}^{\prime}_{\bf e }=\lambda\mathbf{\epsilon}^{\prime}_{\bf e}.\]

Next, define

\[{\bf A}_{\bf c}(n):=[{\bf U}_{\bf c}(n)]^{-1}\]

and assume that (6.3.9a) is true for \(0\leq n<l\); then from (6.

<!-- Pages 393-393 -->

Compare with Lemma 4.1.1. Also, we see that two new sets of isometric matrices have been created, because \([\lambda\mathbf{V_{k}}\,\mathbf{A_{k}}(N\,|\,C)]\boldsymbol{\epsilon_{k}^{ \prime}}=\boldsymbol{\epsilon_{k}^{\prime}}\), and so on. We could have defined the \(\mathbf{U}(N\,|\,C)\) matrices to include the \(\mathbf{R_{k}}\), but the new objects would not be square matrices. By defining them the way we did, the matrices \(\mathbf{R_{k}}\) and \(\mathbf{Q_{k}}\), for \(1\leq k\leq C\), remain as the only matrices that connect objects of different spaces.

At last we can write the solution vectors in terms of the single scalar, \(r(0;N)\). We state them in the form of a theoremi. (Compare with the ME/M/C queue in Theorem 5.4.2).

**Theorem 6.3.2:** The steady-state probability vectors of closed \(\mathrm{M}/\mathrm{ME}/C//N\) loops (\(C>1\)) are given below. First define the auxiliary vectors, starting with \(\mathbf{x_{o}}(N\,|\,C):=\mathbf{p}\) and \(\mathbf{x_{1}}(N\,|\,C):=\mathbf{p}\mathbf{U_{1}}(N\,|\,C)\), using (6.3.7b), For \(2\leq k\leq C\),

\[\mathbf{x_{k}}(N\,|\,C):= \mathbf{p}\mathbf{U_{1}}(N\,|\,C)\mathbf{R_{2}}\,\mathbf{U_{2}}( N\,|\,C)\,\cdots\,\mathbf{R_{k}}\,\mathbf{U_{k}}(N\,|\,C)\] \[= \mathbf{x_{k-1}}(N\,|\,C)\mathbf{R_{k}}\mathbf{U_{k}}(N\,|\,C).\] (6.3.10a) Then starting with \(\mathbf{x_{c}}(C;N):=\mathbf{x_{c}}(N\,|\,C)\), and using (6.3.6c), define for \[C<n\leq N\], \[\mathbf{x_{c}}(n;N):= \mathbf{x_{c}}(N\,|\,C)\,\mathbf{U_{c}}(

<!-- Pages 397-397 -->

#### 6.3.2 Alternate Representation of M/ME/C//N Systems

We mentioned in the preceding section that an alternative definition of our state spaces was available, and in fact more useful in the long run. The one we gave, however, was more concise and simpler to start with. Observe that if we have \(k\leq C\) customers in \(S_{1}\), where the \(C\) servers are identical, and the \(k\) customers are indistinguishable, we only have to know how many customers are at each phase. Consider the following set.

_Definition 6.3.7_.

For \(1\leq k\leq C\),

\[\Xi_{k}:=\{i=\langle\alpha_{1},\alpha_{2},\ldots,\alpha_{m}\rangle\,|\,0\leq \alpha_{l}\leq k,\,\text{and}\,\sum_{l=1}^{m}\alpha_{l}=k\}.\]

\(\Xi_{k}\) _is the set of all internal states of \(S_{1}\) when there are \(k\) active customers there._ Each ordered \(m\)-tuple represents a state in which \(k\leq C\) customers are active in a subsystem \(S_{1}\), which has \(C\) identical servers in it. There are \(\alpha_{1}\) customers at phase 1, \(\alpha_{2}\) customers at phase 2, and so on, each in a different server. They never get in each other's way, because there are at least as many servers as there are customers. If there are more than \(C\) customers at \(S_{1}\), the excess numbers must queue up outside. 

Our claim is that this definition is equivalent to Definition 6.3.1, in that there is a one-to-one mapping of the states in the two sets onto each other. We show this most easily by the following example. Suppose that \(m=5\) and that \(k=4\); then a typical state using Definition 6.3.1 would be

\[\{2,2,4,5\}\ \ \ \ \ (i_{1}=i_{2}=2,\,i_{3}=4,\,\text{and}\,i_{4}=5).\]

This means that one of the customers is at phase 2 of one of the servers, another customer is also at phase 2, but in another server, a third customer is at phase 4 in yet another server, and the fourth customer is at phase 5. Therefore, there are no customers at phase 1 (\(\alpha_{1}=0\)) in any of the servers, there are two customers at phase 2 in two of the servers (\(\alpha_{2}=2\)), one at phase 4 (\(\alpha_{4}=1\)), and one at phase 5 (\(\alpha_{5}=1\)). That is, the following two ordered sequences give us the same information and are therefore equivalent:

\[\{2,2,4,5\}\equiv\langle 0,2,0,1,1\rangle.\]

Definitions 6.3.2 to 6.3.6 are all the same, but the various matrix elements can be computed differently. For instance, Definition 6.3.2 can be changed to read: Let \(i=\langle\alpha_{1},\alpha_{2},\ldots,\alpha_{m}\rangle\in\Xi_{k}\); then

\[[\mathbf{M_{k}}]_{ii}=\alpha_{1}\mu_{1}+\alpha_{2}\mu_{2}+\cdots+\alpha_{m} \mu_{m}=\sum_{\nu=1}^{m}\alpha_{\nu}\mu_{\nu}.\]

Note that each of the objects, \(i=\langle\alpha_{1},\alpha_{2},\ldots,\alpha_{m}\rangle\) can be thought of as a vector with \(m\) components [not to be confused with our row or column

<!-- Pages 398-398 -->

vectors of dimension \(D(k)\)]. Thus subtraction of any two vectors, even from different spaces, is well defined, because they all have the same number of components. But to keep our notation clear, we write the following instead of \((i-j)\). Suppose that we have \(i\in\Xi_{k_{1}}\) with components \(\alpha_{l}\), and \(j\in\Xi_{k_{2}}\) with components \(\beta_{l}\); then we write

\[[\langle i\rangle-\langle j\rangle]_{l}:=\nu_{l}:=\alpha_{l}-\beta_{l},\]

where the following sums are true,

\[\sum_{l=1}^{m}\nu_{l}=\sum_{l=1}^{m}\alpha_{l}-\sum_{l=1}^{m}\beta_{l}=k_{1}- k_{2}.\]

We do not want to get too elaborate with our notation, but we need some definiteness to calculate the other matrix elements.

Look at Definition 6.3.4. \([\mathbf{R_{k}}]_{ij}\) is zero unless all but one of the components of \([\langle j\rangle-\langle i\rangle]\) is zero, in which case the nonzero element would have the value \(1\). Let \(\nu\) be the component that is not \(0\); then \([\mathbf{R_{k}}]_{ij}\) is given by (6.3.2a), the same as before.

Next look at Definition 6.3.5. \([\mathbf{Q_{k}}]_{ij}\) is zero unless all but one of the components of \([\langle i\rangle-\langle j\rangle]\) is zero, in which case the nonzero element would have the value \(1\). Let \(\nu\) be the component that is not \(0\); then \([\mathbf{Q_{k}}]_{ij}\) is given by (6.3.2b), where \(\alpha_{\nu}\) is component \(\nu\) of \(\langle i\rangle\). This is exactly the same as before.

Finally, look at Definition 6.3.6. As with the others, \([\mathbf{P_{k}}]_{ij}:=0\), unless \([\langle i\rangle-\langle j\rangle]\) has exactly two nonzero elements, one with the value \(1\) and the other with the value \(-1\). This is nothing more than stating that only one customer can move at a time, and he can only go to one new phase. Let \(\gamma\) be the member of \([\langle i\rangle-\langle j\rangle]\) which is \(1\) (that is, the phase the customer left), and let \(\nu\) be the member of \([\langle i\rangle-\langle j\rangle]\) which is \(-1\) (that is the phase to which he went). Also, let \(\alpha_{\gamma}\) be the \(\gamma\)th component of \(\langle i\rangle\), then just as we did for the two previous matrices, \([\mathbf{P_{k}}]_{ij}\) is given by (6.3.2c). Once again this is identical to what we had before, including the meaning of \(\alpha_{\nu}\). We can also include the possibility that \([\mathbf{P}]_{ii}\neq 0\). Let the discussion above be true for \(\langle i\rangle\neq\langle j\rangle\). Then for \([\langle i\rangle=\langle j\rangle]\), we have

\[[\mathbf{P_{k}}]_{ii}=\frac{1}{[\mathbf{M_{k}}]_{ii}}\sum_{\gamma=1}^{m}[ \mathbf{P_{1}}]_{\gamma\gamma}\alpha_{\gamma}\,\mu_{\gamma}.\]

Note that if all the diagonal elements of \(\mathbf{P_{1}}\) are zero, so are all the diagonal elements of \(\mathbf{P_{k}}\).

#### 6.3.3 Generalized M/ME/C//_N_ System

What, you may ask, have we gained by the notational change in the previous section? Well, first of all, it is easier to program. Second, we see that in all expressions for the components of matrix elements, \(\alpha_{\nu}\) and \(\mu_{\nu}\) always appear together as a product. Now let us define load-dependent completion rates for each of the phases in a server.

<!-- Pages 399-399 -->

**Definition 6.3.8**: \(\mu_{\nu}(l)=\) _probability rate that one of the customers at phase \(\nu\) will complete, given that there are \(l\) customers at that phase. Note that there is no distinction between having \(k\) identical servers, and only one server whose phases are load dependent._

How interesting. We can either think of \(S_{1}\) as a subsystem with \(C\) identical servers, each with \(m\) phases, or as one server with \(m\) phases, where each phase has a completion rate that depends on the number of customers in \(S_{1}\) who are at that phase.

Now comes the generalization. Why must \(\mu_{\nu}(l)\) be equal to \(l\cdot\mu_{\nu}\), where \(\nu\) is one of the \(m\) phases? If we want to study an M/ME/\(C//N\) loop, it must, but if we let \(\mu_{\nu}(l)\) be anything greater than 0, the equations we have derived remain unchanged! Given this new freedom, what have we got? This is described by the following. The word _loop_ has such a limited connotation that we are changing to the word _system_, which sounds much broader in scope. Also, the distinction between _server_ and _phase_ has become confused, so we now use the word _server_ or _stage_, and drop _phase_, in order to conform to the terminology associated with Jackson networks. The reader is thus entitled to think of the internal components of \(S_{1}\) as real things.

**Definition 6.3.9**: _Generalized M/ME/C//N system \(:=\) a two-subsystem loop in which \(S_{2}\) is an exponential server (perhaps load dependent), and \(S_{1}\) is a network of load-dependent exponential servers satisfying the following rules. No more than \(C\) customers can be active inside \(S_{1}\) at a time. If there are more than \(C\) customers at \(S_{1}\) the excess numbers queue up outside. If there are fewer than \(C\) customers present, an arriving customer enters immediately. When a customer leaves, a new one, if available, enters. A customer upon entering \(S_{1}\) goes directly to server \(\nu\) with probability \([\mathbf{p}]_{\nu}\). The probability rate of leaving a server is \(\mu_{\nu}(l)\), where \(l\) is the number of customers at server \(\nu\). If a completion occurs at \(\nu\), then with probability \([\mathbf{P_{1}}]_{\nu\gamma}\) a customer goes to server \(\gamma\), and with probability \([\mathbf{q}]_{\nu}\) leaves \(S_{1}\)._

We summarize this with a theorem.

**Theorem 6.3.3**: _The steady-state vectors for a generalized M/ME/\(C//N\) system, with \(N>C\), are given by Theorem 6.3.2 with the matrices \(\mathbf{M_{k}}\), \(\mathbf{P_{k}}\), \(\mathbf{R_{k}}\), and \(\mathbf{Q_{k}}\) modified as follows. For \(1\leq k\leq C\), let_

\[\langle i\rangle=\langle\alpha_{1},\alpha_{2

<!-- Pages 400-400 -->

satisfied, then

\[[{\bf P_{k}}]_{ij}=[{\bf P_{1}}]_{\gamma\nu}\frac{\mu_{\gamma}(\alpha_{\gamma})}{[{ \bf M_{k}}]_{ii}}\quad\mbox{for}\;\;i\neq j \tag{6.3.14b}\]

and

\[[{\bf P_{k}}]_{ii}=\frac{1}{[{\bf M_{k}}]_{ii}}\sum_{\gamma=1}^{m}[{\bf P_{1}}]_ {\gamma\gamma}\;\mu_{\gamma}(\alpha_{\gamma}). \tag{6.3.14c}\]

\([{\bf R_{k}}]_{ij}\), for \(i\in\Xi_{k-1}\), \(j\in\Xi_{k}\), is zero unless \([\langle j\rangle-\langle i\rangle]\) has one 1 (at position \(\nu\)) and the rest are 0. If this is satisfied, then

\[[{\bf R_{k}}]_{ij}=p_{\nu}. \tag{6.3.14d}\]

\([{\bf Q_{k}}]_{ij}\), for \(i\in\Xi_{k}\), \(j\in\Xi_{k-1}\), is zero unless \([\langle i\rangle-\langle j\rangle]\) has one 1 (at position \(\nu\)) and the rest are all 0. If this is satisfied, then

\[[{\bf Q_{k}}]_{ij}:=\frac{\mu_{\nu}(\alpha_{\nu})q_{\nu}}{[{\bf M_{k}}]_{ii}}. \tag{6.3.14e}\]

If \(\mu_{\nu}(l)=l\cdot\mu_{\nu}\) for all \(0\leq l\leq C\) and all \(1\leq\nu\leq m\), this reduces to an M/ME/\(C//N\) loop. \(\blacksquare\)

Observe that if one or more of the servers is load independent [i.e., if \(\mu_{\nu}(l)=\mu_{\nu}\) for all \(l\)], queueing delays can actually occur inside \(S_{1}\). The description just given, except for the queueing up outside \(S_{1}\), is identical to that for Jackson networks. We discuss that in the next section.

With the system described in this way, we can see how _processor sharing_ queues fit in. Recall from the beginning of Section 5.4 that, using this discipline, some or all the customers at \(S_{1}\) get equal access to a single server. Suppose there are \(k\) customers sharing the server, then each one must be tracked according to his progress in \(S_{1}\). However, each customer can only get \((1/k)\)th the resources. Now if no more than \(C\) customers are permitted to share at a time, then we have an M/G/\(C//N\) system with the following specifications. The matrices, \({\bf M_{k}}\), \({\bf P_{k}}\), \({\bf R_{k}}\), and \({\bf Q_{k}}\), \(k=1,2,\ldots,C\), are given by Theorem 6.3.3, where \(\mu_{\nu}(l)=l\,\mu_{\nu}\), (i.e., the system is not a generalized one). Equations (6.3.6c) and (6.3.7b) are modified by replacing \({\bf M_{k}}\) and \({\bf B_{k}}\), with \((1/k){\bf M_{k}}\) and \((1/k){\bf B_{k}}\), respectively. If \(S_{1}\) is made up of, say, \(C_{1}\) identical general servers, where \(1\leq C_{1}<C\), then (6.3.6c) and (6.3.7b) are only modified for \(k>C_{1}\), in which case, use \((C_{1}/k)\) instead of \((1/k)\).

For \({\bf U_{c}}(n)\), (6.3.6c) tells us that these substitutions are equivalent to replacing \(\lambda\) with \(\lambda\,C/C_{1}\). The same cannot be said for \({\bf U_{k}}(N\,|\,C)\), because \({\bf B_{k}}\) and \({\bf M_{k+1}}\) appear together in (6.3.7b). All this leaves us with a little unsolved mystery. We know that the steady-state solution of an unconstrained network where the general servers use processor sharing is the same as a network with exponential servers. Therefore, if \(C\geq N\), our steady-state formulas should collapse to the M/M/\(C_{1}//N\) loop. It would be nice if we could explicitly show that our matrices have this property.

<!-- Pages 401-401 -->

We end this subject with the following summary statement. The _unrestricted_ processor sharing queue \([C\geq N]\) is simpler than the M/G/1 queue, but _restricted processor sharing_\([C<N]\), is harder, at least for steady state conditions.

#### 6.3.4 Relation to Jackson Networks

It cannot be emphasized too strongly that the generalized M/ME/\(C\)//\(N\) system can be applied to arbitrarily large networks, limited by their computational difficulty, containing the Jackson networks as a proper subset. In case you are not quite sure what Jackson networks are, you may consider the following theorem as their definition.

**Theorem 6.3.4:** The steady-state solution of a single-class Jackson network with \(m+1\) load-dependent servers and \(C\) customers is the same as that for a generalized M/ME/\(C\)//\(C\) system (\(N=C\)), where ME has an \(m\)-dimensional representation. The \((m+1)\)st server is at \(S_{2}\). Let \(y_{\nu}\) be the \(\nu\)th component of \(\mathbf{y}:=\mathbf{p}(\mathbf{I_{1}}-\mathbf{P_{1}})^{-1}=\mathbf{p}\mathbf{V_ {1}}\mathbf{M_{1}}\), normalized so that \(\mathbf{y}\,\boldsymbol{\epsilon}^{\prime}=1\). Then, the steady-state solution vectors for both are given by

\[[\pi_{\mathbf{k}}(k;C)]_{i}=g(C)X_{1}(\alpha_{1})\cdots X_{m}(\alpha_{m})\left( \frac{1}{\lambda}\right)^{C-k},\] (6.3.15a) where \[\langle i\rangle=\langle\alpha_{1},\alpha_{2},\ldots,\alpha_{\nu},\ldots,\alpha _{m}\rangle\in\Xi_{k},\ \ X_{\nu}(0):=1\], and \[X_{\nu}(l):=\frac{y_{\nu}^{l}}{\mu_{\nu}(1)\mu_{\nu}(2)\cdots\mu_{\nu}(l)}=X_{ \nu}(l-1)\frac{y_{\nu}}{\mu_{\nu}(l)}\cdot \tag{6.3.15b}\]

\(g(C)\) is a normalization constant, fixed to make the probabilities sum to 1. As written here, \(S_{2}\) is load independent. That limitation is not necessary. \(\blacksquare\)

If \(\nu\) is a load-independent server, then \(X_{\nu}(l)=(y_{\nu}/\mu_{\nu})^{l}=[(\mathbf{p}\mathbf{V_{1}})_{\nu}]^{l}\), but if \(\mu_{\nu}(l)=l\,\mu_{\nu}\), (6.3.15b) becomes

\[X_{\nu}(l)=\frac{1}{l!}\left(\frac{y_{\nu}}{\mu_{\nu}}\right)^{l}=\frac{1}{l! }\left[(\mathbf{p_{1}}\mathbf{V_{1}})_{\nu}\right]^{l}.\]

This corresponds to a _delay_ stage (discussed below). We used objects similar to \(X_{\nu}(l)\) in discussing load-dependent servers in Section 2.1.5; however, the notation used there was somewhat different.

The _product-form solution_ for Jackson networks (as given above) is already well known and simpler to set up than our matrix formulation. You can see now why we never bothered to look at algorithms for calculating the solutions in the earlier discussions. However, the product solution _is_ _not_ _valid_ for systems for which \(N>C\), that is, when there are _constraints_ on the number of customers who can be simultaneously active in \(S_{1}\). In that case, our procedure cannot be avoided. There is a standard approximation that is

<!-- Pages 402-402 -->

used in modeling networks, but it is not known how accurate it is in general. We give an example of this in the next section. For details about applying Jackson networks to computer performance see, e.g., [14] or [15].

As a last comment in this section, observe that it is the constraint on population activity that causes our problems to grow to "matrix" proportions. That, in turn, subtly depends on the dimensionality function \(D(k)\). Further discussion in this direction is outside the scope of this book, except to note that population constraints are special cases of _blocking_ (e.g., activity at one node may prevent activity at another node), which also lies outside this book. See, for example, [10]

#### 6.3.5 Time-Sharing Systems with Population Constraints

The last generalization we can make to our loop without greatly increasing the mathematical complexity of our model was already alluded to in the preceding section. We can make \(S_{2}\) into a load-dependent server. This slight change turns out to give a potentially powerful tool for studying the behavior of time-sharing systems, as well as other systems with population constraints. Furthermore, the computational complexity is not changed. First we look at the changes that we must make to the formulas, and then we look at an application.

We only need to look at those formulas containing \(\lambda\), which is now \(\lambda(l)\), for \(l=1,2,\ldots\). Therefore, the matrices \(\mathbf{M_{k}}\), \(\mathbf{P_{k}}\), \(\mathbf{R_{k}}\), and \(\mathbf{Q_{k}}\) are unchanged. Only the matrices \(\mathbf{U_{k}}(N\,|\,C)\) and \(\mathbf{U_{c}}(n)\) must be modified. What we have to do is combine what we did in Section 5.4.1 with what we have here. The reader may go through the complete derivation alone; we only make some observations. Start with the balance equations (6.3.5) and replace each \(\lambda\) with \(\lambda(Ni\!-\!n)\), where \(n\) is the first argument in \(\pi_{\mathbf{c}}(n;\,N)\), and so on. Remember, \(n\) is the number of customers at \(S_{1}\), but \(\lambda(\cdot)\) depends on the number of customers at \(S_{2}\). This leads to the following modified solutions [compare with (6.3.6a) and (6.3.6c)].

\[\mathbf{U_{c}}(0)=\lambda(1)\mathbf{V_{c}},\] (6.3.16a) and for \[l\geq 1\] \[\mathbf{U_{c}}(l)=\lambda(l\!+\!1)[\mathbf{B_{c}}+\lambda(l)\mathbf{I_{c}}- \mathbf{U_{c}}(l\!-\!1)\mathbf{M_{c}}\,\mathbf{Q_{c}}\,\mathbf{R_{c}}]^{-1}. \tag{6.3.16b}\]

Also, (6.3.7a) remains unchanged, and (6.3.7b) changes to

\[\mathbf{U_{k}}(N\,|\,C):=\] \[\lambda(N\!-\!k\!+\!1)[\mathbf{B_{k}}+\lambda(N\!-\!k)\mathbf{I_{k}}- \mathbf{R_{k\!+\!1}}\mathbf{U_{k\!+\!1}}(N\,|\,C)\mathbf{M_{k\!+\!1}}\mathbf{ Q_{k\!+\!1}}]^{-1}. \tag{6.3.16c}\]

For \(N\leq C\), Theorem 6.3.4 is changed by replacing the \(\lambda\) term in (6.3.15a) with \(1/[\lambda(1)\lambda(2)\cdots\lambda(C-k)]\), the \(\lambda\) equivalent of (6.3.15b). That is it. Nothing else changes. A close look at (6.3.6b) shows that \(\mathbf{U_{c}}(l)\) really depends on the number of customers at \(S_{2}\) (remember, we started at the top), just as \(\lambda(l)\) does, so that is all that we have to change. Tehranipour [16],

<!-- Pages 403-403 -->

[TehranipourvdLLip89] was the first one to recognize this. Let us see what that allows us to do. Consider a system with \(N\) customers. When a customer is at \(S_{2}\), he spends some time thinking about what to do, and after a mean time of \(Z\) (exponentially distributed) joins the queue at \(S_{1}\). After a mean time of \(R(N)\) he leaves \(S_{1}\) and returns to \(S_{2}\), starting the process over again. \(Z\) is known as the _think time_, and \(R(N)\) is called the _response time_ for the process. The probability rate for him to leave \(S_{2}\), given that he is there thinking, is \(1/Z\). If there are \(\ell\) (independently) thinking customers at \(S_{2}\), the probability rate for any one of them to leave is simply \(\ell Z\). In other words, \(S_{2}\) is a load-dependent server with service rate

\[\lambda(\ell)=\frac{\ell}{Z}.\]

That is why a server with this kind of behavior is often called a _think stage_. It also shows up as the description of failures in the _machine minding model_. Here, any number of machines are running simultaneously and independently of each other, and the rate at which they break down is proportional to the number running. It is also referred to as a _delay stage_, because customers can pause somewhere (not counting their waiting in a queue) independently of each other.

The view we take here is that of computer users who sit at their terminals and think (no comments, please), or type, and every once in a while hit the "return" key, which sends their prepared _transactions_ to an external computer network, which they share. It is assumed that they do nothing while they wait for the computer system's response. Drinking coffee or talking to a friend does not count as doing anything, nor does any activity, however productive, that is not related to system usage. This is then a _time-sharing stage_ (TS) in a _time-sharing computer system_. Let \(L(N)\) be the r.v. denoting the number of customers who are at \(S_{2}\) at any time, in a network with \(N\) customers. From Little's formula (1.1.2) we see that \(\mbox{\sf E}\hskip-2.0pt\mbox{\sf E}[L(N)]\) is related to the mean rate at which transactions are processed [call it the _throughput_, with the symbol \(\Lambda(N)\)] by

\[\mbox{\sf E}\hskip-2.0pt\mbox{\sf E}[L(N)]=\Lambda(N)Z,\]

given that \(Z\) is the mean time each customer spends at \(S_{2}\) between transaction submittals. On the other hand, the mean number of transactions that are being processed (or waiting to be processed) at any time must be equal to \(N-\mbox{\sf E}\hskip-2.0pt\mbox{\sf E}[L(N)]\), and is related to the same throughput by the following version of Little's formula,

\[N-\mbox{\sf E}\hskip-2.0pt\mbox{\sf E}[L(N)]=\Lambda(N)R(N),\]

given that \(R(N)\) is the mean time a transaction spends at \(S_{1}\). If we add the two equations above together and solve for \(R(N)\), we get the _fundamental formula for TS systems_ which we state as a theorem.

**Theorem 6.3.5:** Consider a _time-sharing system_ as described above. Then the mean response time is given by:

\[R(N)=\frac{N}{\Lambda(N)}-Z. \tag{6.3.17}\]

<!-- Pages 404-404 -->

This equation is as general as Little's formula and tells us some general things about TS systems. (Be careful, though. There are numerous counterexamples that show up just when you least expect.) For instance, when \(N\) becomes very large (i.e., when too many users try to access the same computer system simultaneously), \(S_{1}\) saturates, so the throughput reaches a limiting value,

\[\Lambda:=\lim_{N\to\infty}\Lambda(N).\]

Then we see, for large \(N\),

\[R(N)\approx\frac{1}{\Lambda}N-Z.\]

If \(\Lambda(N)-\Lambda=\operatorname{O}(1/N)\) for large \(N\), then this equation must be modified.

See [10] for details and examples. \(\blacksquare\)

In other words, \(R(N)\) approaches a straight line whose slope is \(1/\Lambda\) and whose \(y\)-intercept is \(-Z\). At the other extreme, \(R(1)\) is the amount of time it should take, on average, for a single transaction to be processed if there is no interference from other tasks. Without too much difficulty, a reasonably good performance modeler should be able to find a satisfactory value for \(R(1)\), \(\Lambda\), and \(Z\). Then all one has to do to get a decent understanding of the performance of the particular time-sharing system is to draw a smooth curve that starts at the point \([1,R(1)]\) and asymptotically approaches the line \(x/\Lambda-Z\). Figure 6.3.1 shows several possible ways to do this. Clearly, if we really know what those three parameters are, we know the ballpark we are playing in, but do we know the game we are playing? As you can see, the different curves can differ by a factor of 10 or more in the intermediate region. Clearly, under-utilized systems (\(N=1\)) almost always perform well (users don't have to compete for resources), and overloaded systems are usually quite unsatisfactory, what planners want to know is: "How many users can a system support in a satisfactory manner?" So the name of the game is finding the right middle.

As long as there are no constraints on the number of transactions that can be processed simultaneously (i.e., when \(N\leq C\)), Jackson networks can be used quite effectively for performance modeling. However, it is well known that most systems will actually reduce their throughput if too many transactions are present, in a phenomenon known as _thrashing_. Briefly, if the amount of main memory (or cache memory) is insufficient to hold all active transactions simultaneously, then as each task is given its slice of time to use the central processor (CPU), it must first reclaim its memory space. The more jobs active, the more time is spent reclaiming main memory. To counter this, well-run computer systems will restrict the number of tasks, or transactions (our customers) who can be active simultaneously. That is, they impose a _population size constraint_, our parameter \(C\).

Common techniques for dealing with constraints of this kind, called _decomposition_, [14] or _aggregation_, or simply the _natural approximation_, [15] effectively "short-circuit" \(S_{1}\) so that \(k\) customers

<!-- Pages 405-405 -->

return as soon as they leave. The rate at which they go around the loop is \(\Lambda(k)\), \(k=\)1, 2,..., \(C\). Then \(S_{1}\) is replaced by a load-dependent server with service rates as follows.

\[\mu(n)=\Lambda(n)\quad\text{for}\;\;n\leq C\]

and

\[\mu(n)=\Lambda(C)\quad\text{for}\;\;n\geq C.\]

We have seen a simple version of this in Section 4.4. The technique is so compelling that many practitioners think it is exact, which it is for those systems where Jackson networks are exact. But it is _not_ exact for systems with population constraints! (This is why the author became involved in LAQT in the first place.)

**Example 6.3.1:** We have calculated response times for an M\(/H_{2}/C//N\) loop, using the exact solution as given by Theorem 6.3.2 or Theorem 6.3.3, and its natural approximation. The calculations of \(R(N)\) and \(R_{a}(N)\) (\(a\) for approximation) versus \(N\), for \(C=1,2\), and 3, are given in Figure 6.3.2. As

Figure 6.3.1: Response time curves for a family of time-sharing systems with the same value for minimal load \(R(1)\), think-time \(Z\), and asymptotic throughput \(\Lambda\). All are bounded from below by the horizontal line, \(y=R(1)\), and the asymptote \(y=x/\Lambda-Z\). The intersection of those two lines occurs at \(N^{*}=\Lambda[Z+R(1)]\). \(N^{*}\) is often taken as the number of customers that the TS system can support, but the response times for the different systems can vary enormously at that point.

<!-- Pages 406-406 -->

one would expect, the asymptotic slope decreases with increasing \(C\), because \(\Lambda(C)\) increases with \(C\). Note that the natural approximation always gives the right asymptotic slope and correct value for \(R(1)\) (i.e., it is in the right ballpark), but it can be off by more than a factor of 2 where results are most important, in the intermediate region (it is playing the wrong game). In this case it always yields an overly optimistic result [i.e., \(R_{a}(N)<R(N)\)]. We do not really know if this would hold true for all systems. 

Although the decomposition method is used regularly, it is not known in general how good (or bad) an approximation it is, partly because system parameters change so rapidly due to technological improvements that most researchers have not had the time to carry out the exact calculations as described here. This is a pity, because LAQT can be used to explore the behavior of even more complicated queueing systems by, for instance, doing an aggregate approximation to \(S_{2}\), while leaving \(S_{1}\) as is. In this way one could study the interaction of two arbitrarily complicated subnetworks. Of course, we would not know how accurate that approximation is, but at the moment, we know almost nothing about such systems. Exact solution of such networks exist and fall under the more general name of _Quasi Birth-Death_ (QBD)

Figure 6.3.2: Response-time curves for a time-sharing system, where the computer subsystem (\(S_{1}\)) is taken to be \(C\) identical servers with hyperexponential distributions. The mean service time for each is \(R(1)=0.6\) seconds, with squared coefficient of variation of \(C_{v}^{2}=9.0\). The think time is \(Z=10.0\) seconds. Three different values for \(C\) (1, 2, and 3) were used. The curves marked \(R(N\,|\,C)\) are the exact calculations, and the curves marked \(R_{a}(N|C)\) come from the natural, decomposition, aggregation (whatever) approximation. For all \(C\) and for all \(N\), the approximation lies below the correct value.

<!-- Pages 407-407 -->

processes_. However, a full-blown calculation of that magnitude would require using matrices of the size \(D_{1}(C_{1})\times D_{2}(C_{2})\). One can see from our discussion on computational complexity at the end of Section 6.3.1 that it could easily become intractable.

### Open Generalized M/G/_C_ Queue

The matrices \(\mathbf{M_{k}}\), \(\mathbf{P_{k}}\), \(\mathbf{Q_{k}}\), \(\mathbf{R_{k}}\), \(\mathbf{B_{k}}\), and \(\mathbf{V_{k}}\), for \(k=1,2,\ldots,C\), which we tediously described and showed how to build from \(\mathbf{M_{1}}\), \(\mathbf{P_{1}}\), and \(\mathbf{p}\) (and the load-dependence factors) in the preceding section, are the only building blocks we need for the rest of this chapter. If that already seems like too much, rest assured that we could not do it with less. We need that much information just to describe such complicated systems.

The procedure for "opening" our loop is the same as always. If the maximal service rate of \(S_{1}\) is greater than \(\lambda\), then as \(N\) becomes larger, the probability that \(S_{2}\) will be idle goes to 0. "But what _is_ the maximal rate?" you ask. The answer must wait until the next section. For now we assume that the appropriate conditions are satisfied, in which case \(S_{2}\) behaves as a Poisson source of customers to \(S_{1}\). It would be expected that the limit as \(N\) goes to infinity of \(\mathbf{U_{c}}(N)\) exists, and from (6.3.6c), satisfies the equation

\[\mathbf{U_{c}}:=\lim_{N\to\infty}\mathbf{U_{c}}(N)=\lambda\left[\lambda \mathbf{I_{c}}+\mathbf{B_{c}}-\mathbf{U_{c}}\mathbf{M_{c}}\mathbf{Q_{c}} \mathbf{R_{c}}\right]^{-1}. \tag{6.4.1}\]

We ran across a formula like this in Equations (5.5.6). There is no known explicit expression for \(\mathbf{U_{c}}\) except when \(C=1\). In that case we are dealing with the M/ME/1 queue, and we know that \(\mathbf{U_{1}}\) is \(\mathbf{U}\) of Equations (4.1.4). One way to find the numerical value for a matrix that satisfies the equation is to iterate on \(\mathbf{U_{c}}\). That is, keep calculating \(\mathbf{U_{c}}(C)\), \(\mathbf{U_{c}}(C+1)\), \(\mathbf{U_{c}}(C+2)\), and so on, until no changes are perceived. There are faster methods available if one is not interested in the sequence of finite systems [Wallace69]. Anyway, suppose that \(\mathbf{U_{c}}\) is known.Then

\[\mathbf{U_{c}}(\infty\,|\,C):=\lim_{N\to\infty}\mathbf{U_{c}}(N\,|\,C)= \mathbf{U_{c}}\]

and calculate \(\mathbf{U_{1}}(\infty\,|\,C)\), \(\mathbf{U_{2}}(\infty\,|\,C)\), \(\ldots\), and \(\mathbf{U_{c-1}}(\infty\,|\,C)\) using (6.3.7b). That is,

\[\mathbf{U_{k}}(\infty\,|\,C):=

<!-- Pages 409-409 -->

and

\[\mathbf{p_{ik}}=\frac{1}{r(k;N)}\boldsymbol{\pi_{k}}(k;N)\quad\text{for}\;\;n=k \leq C. \tag{6.5.1b}\]

The subscript \(\mathbf{ik}\) stands for: \(\mathbf{k}\)-space vector for the initial composite state. The \(\boldsymbol{\pi}\) vectors come from Theorem 6.3.2 for the closed system and (6.4.4) for the open system. Obviously, \(\mathbf{p_{ik}}\,\boldsymbol{\epsilon^{\prime}_{k}}=1\). See Section 4.5.2 for a discussion of what is meant by this vector.

Next define the family of \(D(k)\)-dimensional row vectors,

\[\mathbf{p_{k}}:=\mathbf{p}\mathbf{R_{2}}\mathbf{R_{3}}\cdots\mathbf{R_{k}} \quad\text{for}\;\;2\leq k\leq C.\lx@paragraphsign\] (6.5.2a) Because \[\mathbf{R_{k}}\,\boldsymbol{\epsilon^{\prime}_{k}}=\boldsymbol{\epsilon^{ \prime}_{k-1}}\], we see that \[\mathbf{p_{k}}\,\boldsymbol{\epsilon^{\prime}_{k}}=1\] for all \[k\]. Suppose now that the system was initially idle and suddenly \[n\] customers showed up en masse. Or suppose that the customers were already there, but \[S_{1}\] was inoperative and then suddenly started up. The initial vector in this case is given by \[\mathbf{p_{ik}}=\mathbf{p_{k}}\quad\text{for}\;\;n=k\leq C,\] (6.5.2b) \[\mathbf{p_{ik}}=\mathbf{p_{c}}\quad\text{for}\;\;n\geq C,\] (6.5.2c) In the latter case there would be \[n-C\] customers still waiting outside \[S_{1}\]. Physically, we see that the first customer enters and puts \[S_{1}\] in composite state \[\mathbf{p}\in\Xi_{1}\]. Then the second customer enters and takes the subsystem from that state to \[\mathbf{p}\mathbf{R_{2}}\], and so on. How simple.

Next, let us suppose that the subsystem is initially in state \[i\in\Xi_{k}\]. How long will it take before someone leaves? Assume that the entryway to the queue at \[S_{1}\] is shut off so that no new customers can enter. Let us give the symbol a formal definition.

_Definition 6.5.1_:

\([\boldsymbol{\pi^{\prime}_{k}}]_{i}:=\)_mean time until a customer leaves \(S_{1}\), given that the subsystem was in state \(i\in\Xi_{k}\) (\(k\leq C\)) and no new customers enter. \(\boldsymbol{\tau^{\prime}_{k}}\) is a \(D(k)\)-dimensional column vector. This describes a collective process, in that any one of the \(k\) customers could leave, and we do not know, or care, which. _

The \(n=1\) equivalent was discussed in Section 3.1.1, where we showed in (3.1.2b) that it was equal to \(\mathbf{V}\,\boldsymbol{\epsilon^{\prime}}\). We give an extension of that derivation here. The vector equation is as follows. If there are \(k\) customers in \(S_{1}\), then

\[\boldsymbol{\tau^{\prime}_{k}}=\mathbf{M}_{k}^{-1}\,\boldsymbol{\epsilon^{ \prime}_{k}}+\mathbf{P_{k}}\,\boldsymbol{\tau^{\prime}_{k}}.\]

In words, the mean time until someone leaves \([\boldsymbol{\tau^{\prime}_{k}}]\) is equal to the sum of two terms; the time until something happens \([1/(\mathbf{M}_{k})_{ii}=(\mathbf{M}_{k}^{-1}\,\boldsymbol{\epsilon^{\prime} _{k}})_{i}]\), and if the event did not result in a departure, the system goes to another state \([\mathbf{P_{k}}]\) and a customer leaves from there. Notice the words we used: "the system goes to another state." We could have said, instead, that "one of the \(k\) customers moves from one phase to another, thereby changing the state of \(S_{1}\)."

<!-- Pages 413-413 -->

so its pdf can be found from the convolution of the pdfs of the \(Z_{\ell}(C)\)s (not so easy). \(\blacksquare\)

This may be getting a bit obscure and abstract, so let us interject the simplest of examples. Suppose that ME is exponential (i.e., \(m=1\)), and there are exactly \(C\) customers at \(S_{1}\). Then \(D(k)=1\) for all \(k\), \(\mathbf{M_{k}}=\mathbf{B_{k}}\Rightarrow k\,\mu\), and just about everything else becomes \(1\). Then

\[\mathbf{E}[Z_{1}]=\frac{1}{C\,\mu}\]

and in general, we get the well-known formula for the order statistics for exponential distributions, namely

\[\mathbf{E}[Z_{k}]=\frac{1}{(C-k+1)\mu}.\]

Remember, this is the mean time between departures. The mean time for departures themselves are the partial sums of the interdeparture times. Recall that \(\mathbf{E}[X_{(0)}(C)]:=0\); then

\[\mathbf{E}[X_{(k)}(C)]=\mathbf{E}[X_{(k-1)}(C)]+\frac{1}{(C-k+1)\mu}=\frac{1}{ \mu}\sum_{\ell=c-k+1}^{c}\frac{1}{\ell}.\]

In particular, the time for the last customer to leave is

\[\mathbf{E}[X_{(c)}(C)]=\frac{1}{\mu}H(C):=\frac{1}{\mu}\sum_{\ell=1}^{c}\frac {1}{\ell},\]

where \(H(C)\) is known as the _harmonic series_. Remember, these last formulas are valid only for the M/M/\(C\) queue.

**Draining of Generalized ME/ \(C\) Subsystems**

We return to our generalized subsystem, and suppose that \(n>C\). Then when a customer leaves, another immediately takes his place, putting the system in the state

\[\mathbf{Y_{c}R_{c}}=\mathbf{V_{c}M_{c}Q_{c}R_{c}}.\]

The element \([\mathbf{Y_{c}R_{c}}]_{ij}\) can be interpreted in the following way. "Given that the system is in state \(i\in\Xi_{c}\), with more customers in the queue, a customer finally leaves \([\mathbf{Y_{c}}]\), and immediately thereafter another customer enters \([\mathbf{R_{c}}]\), putting the system in state \(j\in\Xi_{c}\)." This object is a singular, isometric, square matrix of dimension \(D(C)\times D(C)\). We first ran across the \(C=1\) version of this in Chapter 3, namely, \(\mathbf{Y_{1}R_{1}}=\boldsymbol{\epsilon^{\prime}p}=\mathbf{Q}\) (as always, not to be confused with \(\mathbf{Q_{1}}=\mathbf{q^{\prime}}\), or _Q_).

The formulas for the interdeparture times from a generalized G/C are very similar to those for order statistics, but we must distinguish between \(n>C\) and \(n<C\), where \(n\) is the number of customers remaining. We start with the following.

<!-- Pages 414-414 -->

**Definition 6.5.5**.: Let \(Z_{\ell}(N|C)\) be the r.v. denoting the time between the departures of customers \(\ell-1\) and \(\ell\). Initially there are \(N\) customers at the system, and no more than \(C\) customers can be active at one time. The number of customers remaining immediately after departure \(\ell\) (and no new arrivals) is \(n=N-\ell\). 

Initially the system is in some composite state \(\mathbf{p_{ic}}\) with \(N>C\) customers. Then the mean time for the first departure is, using (6.5.3),

\[\mathbf{E}[Z_{1}(N|C)]=\mathbf{p_{ic}}\mathbf{V_{c}}\boldsymbol{\epsilon^{ \prime}_{c}}=\mathbf{p_{ic}}\boldsymbol{\tau^{\prime}_{c}}.\]

The second customer leaves the following amount of time later,

\[\mathbf{E}[Z_{2}(N|C)]=\mathbf{p_{ic}}\mathbf{Y_{c}}\mathbf{R_{c}}\boldsymbol{ \tau^{\prime}_{c}}.\]

In general, as long as \(\ell<N-C\) (there are customers still waiting to enter \(S_{1}\)),

\[\mathbf{E}[Z_{\ell}(N|C)]=\mathbf{p_{ic}}[\mathbf{Y_{c}}\mathbf{R_{c}}]^{\ell -1}\,\boldsymbol{\tau^{\prime}_{c}}.\] (6.5.6a) When finally \[\ell=N-C\] there are \[C\] customers remaining. Then (let \[j=N-C+k+1\] ) \[\mathbf{E}[Z_{j}(N|C)]=\mathbf{p_{ic}}[\mathbf{Y_{c}}\mathbf{R_{c}}]^{N-C} \mathbf{Y_{c}}(c-k)\boldsymbol{\tau^{\prime}_{c-k}}\quad 0\leq k<C,\] (6.5.6b) starting with \[k=0\] ( \[C\] customers remain), \[\mathbf{E}[Z_{N\!-\!C\!+\!1}(N|C)]=\mathbf{p_{ic}}[\mathbf{Y_{c}}\mathbf{R_{c} }]^{N\!-\!C}\boldsymbol{\tau^{\prime}_{c}},\] and ending with \[k=C-1\], \[\mathbf{E}[Z_{N}(N|C)]=\mathbf{p_{ic}}[\mathbf{Y_{c}}\mathbf{R_{c}}]^{N\!-\!C} \mathbf{Y_{c}}(1)\boldsymbol{\tau^{\prime}_{1}}.\]

We see that every interdeparture time depends on the inner product of a "final vector" \([\boldsymbol{\tau^{\prime}_{k}}]\) and an "initial vector" [everything else]. The final vectors depend only on the number of active customers, but the initial vectors (and thus, the interdeparture times themselves) depend on \(N,\,C\), the number of customers still remaining, and the state the system was in when the whole process began \([\mathbf{p_{ic}}]\). The mean times are all different, but if \(N>>C\), then \([\mathbf{Y_{c}}\mathbf{R_{c}}]^{\ell}\to\boldsymbol{\epsilon^{\prime}_{c}} \boldsymbol{\pi_{c}}\) [see (6.5.9b) below, and the discussion around it], and the successive interdeparture times approach a constant \([\boldsymbol{\pi_{c}}\boldsymbol{\tau^{\prime}_{c}}]\), until there are fewer than \(C\) customers remaining. But even so the interdeparture times are correlated. This is discussed fully in Chapter 8.

Let us summarize this with a theorem about the time for a queue to drain.

**Theorem 6.5.2**.: Consider a generalized subsystem \(S_{1}\) in which a maximum of \(C\) customers can be active simultaneously. Suppose that there are \(N\) customers at \(S_{1}\), with no new arrivals possible, and at the moment the process begins, the subsystem is in state \(\mathbf{p_{ik}}\). The process

<!-- Pages 415-415 -->

ends when all customers are gone. Let \(T_{N}\) be the r.v. denoting the time for the queue to drain. Then from Equations (6.5.6)

\[\mathbb{E}[T_{N}]=\sum_{\ell=1}^{N}\mathbb{E}[Z_{\ell}(N|C)]. \tag{6.5.7a}\]

If \(N=k\leq C\) this reduces to

\[\mathbb{E}[T_{k}]=\mathbf{p_{ik}\,\tau_{k}^{\prime}}+\mathbf{p_{ik}\,Y_{k}\, \tau_{k-1}^{\prime}}+\mathbf{p_{ik}\,Y_{k}(}k-2)\,\tau_{k-2}^{\prime}\]

\[+\cdots+\mathbf{p_{ik}\,Y_{k}(}1)\,\tau_{1}^{\prime}. \tag{6.5.7b}\]

In general, for \(N=l+C,\,\,\,l>0\),

\[\mathbb{E}[T_{N}]=\mathbf{p_{ic}\,}\left[\sum_{j=0}^{l}(\mathbf{Y_{c}R_{c}})^{ j}\right]\tau_{c}^{\prime} \tag{6.5.7c}\]

\[+\mathbf{p_{ic}}(\mathbf{Y_{c}\,R_{c}})^{l}\mathbf{Y_{c}\,}\left[\mathbf{Y_{c} \,\tau_{c-1}^{\prime}}+\mathbf{Y_{c}(}C-2)\,\tau_{c-2}^{\prime}+\cdots+ \mathbf{Y_{c}(}1)\,\tau_{1}^{\prime}\right].\]

The separate terms are the mean times for each successive customer to leave after the previous one has left. \(\boldsymbol{\tau_{k}}\) is given by (6.5.3) and \(\mathbf{Y_{k}}\) is given by Equations (6.5.4). \(\blacksquare\)

It is left to the reader to devise a simple recursive algorithm for evaluating Equations (6.5.7). Perhaps we should think of Theorem 6.5.1 as a corollary to Theorem 6.5.2. Some examples where _time to drain_ can be important are the following. This idea was recently used by Mohamed [15].

1. A multiprogramming computer system has been in operation all day, and everyone except the operator has gone home. The operator cannot go home until all jobs are done, including those in the waiting queue. \(C\) is the maximum degree of multiprogramming, and \(n\) is the number of jobs in the system. Then \(\mathbf{p_{ik}}\) is given by (6.5.1), and \(T_{n}\) is the mean time until the operator can go home.

2. A multiprogramming computer system has been in operation for a long time, and the operating systems people must bring it down for some reason or other. They can shut off the queue of waiting jobs but must let those in progress continue until they finish. \(C\) is the maximum degree of multiprogramming, \(\mathbf{p_{ik}}\) is given by (6.5.1), and \(n\) is the number of jobs in the system when the queue is turned off. If \(n=k\leq C\), then \(T_{k}\) is the mean time until they can bring down the system. If \(n>C\), then \(T_{c}\) is the mean time, but use (6.5.1a) with \(n\) (not \(C\)) for \(\mathbf{p_{ic}}\).

3. We have \(n\geq C\) identical devices, of which we would like \(C\) to be running simultaneously (_hot backup_), but we can survive even if all but one are broken. \(\mathbf{p_{ic}}\) is given by \(\mathbf{p_{c}}\) (6.5.2a), and \(\mathbb{E}[T_{n}]\) is the mean time until all are broken (MTTF, without repair). There are initially \(n-C\) devices in _cold backup_ and \(C-1\) in hot backup. We can generalize; failure can be defined as occurring when the number still at \(S_{1}\) drops below a certain value.

<!-- Pages 416-416 -->

4. You are driving cross-country and are in a hurry. Your car has five brand-new tires. You will have time to change, but not to fix, a flat if it occurs. Equation (6.5.2a) for \(C=4\) (unless you are driving a trailer truck) is the initial state, and failure occurs when you are down to three tires (hold the steering wheel steady when this occurs). \(T\) is the sum of the first two terms in (6.5.7b).

5. Same as Example 4, but now you are driving a rented car, so the four mounted tires have already been used to an uncertain amount, but the spare is new. What is \(\mathbf{p_{ik}}\) now?

Presumably the reader can think up a few more examples.

#### 6.5.2 Markov Renewal (Semi-Markov Departure) Processes

In the second paragraph of Section 6.4 we stated that the maximal service rate of \(S_{1}\) must be greater than \(\lambda\) for the steady-state M/ME/\(C\) queue to exist, without actually determining the maximal rate. We do that now. We also describe the departure process from \(S_{1}\) (which is, of course, the same as the arrival process at \(S_{2}\)), when its queue is unboundedly large. This is the direct generalization of the renewal processes described in Section 3.5, and is known as a _Markov Renewal Process_ (MRP). It is also known as a _semi-Markov point process_ (SMP). We go into this subject in a more general way, and in more detail in Chapter 8. We are not particularly interested in where names come from, but we give them so that the reader can have a reference point for reading the general literature. Based on our (and everyone else's) definition, this really is not a renewal process, and we hope that by the end of this section, you will see why.

In the preceding section we showed how to calculate the mean time for a customer to leave \(S_{1}\), given some initial state. We also showed how to calculate the time for the second, third, and all other customers to leave. All these times are different even if the queue is long enough to guarantee that there will always be more than \(C\) customers at \(S_{1}\). Fortunately, this sequence approaches a limit. That is, let \((Z_{n})\) be the r.v. for the time interval between the departure of customer \(n\) and customer \((n-1)\) for any initial state vector, \(\mathbf{p_{ic}}\). Note that the system has up to \(C\) customers actively being served, not just the one who ultimately leaves next. Therefore this period should not be identified with the \(n\)th customer to arrive. Among other things, the ordering of customers in not preserved. In any case, we call this the _nth epoch_. Then

\[\mathbf{E}[Z_{n}]=\mathbf{p_{ic}}(\mathbf{Y_{c}}\,\mathbf{R_{c}})^{n-1}\mathbf{ V_{c}}\,\boldsymbol{\epsilon}_{\boldsymbol{\mathrm{e}}}^{\prime},\] (6.5.8a) for all \[n\], if the queue is unboundedly large. Let us assume that the following limit exists. \[\mathbf{E}[Z]:=\lim_{n\to\infty}\mathbf{E}[Z_{n}].\] (6.5.8b) For the limit to exist, the matrix \[\mathbf{Y_{c}}\mathbf{R_{c}}=\mathbf{V_{c}}\mathbf{M_{c}}\mathbf{Q_{c}}\mathbf{ R_{c}}\] must satisfy certain properties, some of which we already know to be true. We know, for instance, that this matrix is isometric but not invertible. Thus it has one eigenvalue equal to \[1\] and multiple occurrences of \[0\] as an eigenvalue. We know the latter

<!-- Pages 418-418 -->

putting the system in a new state of \(\Xi_{c}\), \([\mathbf{R_{c}}]\). Therefore, \(\boldsymbol{P_{c}}\) is the transition matrix describing a short-circuited \(S_{1}\). The left eigenvector \(\mathbf{y_{c}}\), defined by

\[\mathbf{y_{c}}\,\boldsymbol{P_{c}}=\mathbf{y_{c}} \tag{6.5.11b}\]

and \(\mathbf{y_{c}}\,\boldsymbol{\epsilon^{\prime}_{e}}=1\), is interpreted in the following way. \([\mathbf{y_{c}}]_{i}\) is the probability that the short-circuited system will be found in state \(i\in\Xi_{c}\) between events. Next rewrite (6.5.11a) and (6.5.11b) in the form

\[\mathbf{y_{c}}\mathbf{Q_{c}}\mathbf{R_{c}}=\mathbf{y_{c}}[\mathbf{I_{c}}- \mathbf{P_{c}}], \tag{6.5.11c}\]

and compare with the following [from (6.5.9a) using the first part of (6.5.4a)].

\[\boldsymbol{\pi_{c}}=\boldsymbol{\pi_{c}}[\mathbf{I_{c}}-\mathbf{P_{c}}]^{-1} \mathbf{Q_{c}}\mathbf{R_{c}}. \tag{6.5.11d}\]

These two equations imply that \(\boldsymbol{\pi_{c}}\) must be proportional to \(\mathbf{y_{c}}[\mathbf{I_{c}}-\mathbf{P_{c}}]\); that is,

\[\boldsymbol{\pi_{c}}\sim\mathbf{y_{c}}[\mathbf{I_{c}}-\mathbf{P_{c}}].\]

Normalize so that \(\mathbf{y_{c}}\,\boldsymbol{\epsilon^{\prime}_{e}}=1\), and let \(g:=1/\boldsymbol{\pi_{c}}[\mathbf{I_{c}}-\mathbf{P_{c}}]^{-1}\boldsymbol{ \epsilon^{\prime}_{e}}\); then

\[\mathbf{y_{c}}=g\,\boldsymbol{\pi_{c}}[\mathbf{I_{c}}-\mathbf{P_{c}}]^{-1}.\]

Next consider the vector whose \(i\)th component is \(x_{i}:=y_{i}\,[\mathbf{M_{c}}]_{ii}\). Recall that \(1/[\mathbf{M_{c}}]_{ii}\) is the mean time the system spends in state \(i\) every time it finds itself there. Therefore, as a direct generalization of the _mean residual vector_ defined in (3.5.10b),

\[\mathbf{x_{c}}\sim\mathbf{y_{c}}[\mathbf{M_{c}}]^{-1}\] (6.5.12a) must be proportional to the steady-state probability vector of short-circuited \[S_{1}\]. On the other hand, we have (substituting for \[\mathbf{y_{c}}\] ) \[\mathbf{x_{c}}\sim\pi_{c}[\mathbf{I_{c}}-\mathbf{P_{c}}]^{-1}[\mathbf{M_{c}} ]^{-1}=\pi_{c}\mathbf{V_{c}}, \tag{6.5.12b}\]

where from (6.5.10a), \(\mathbf{x_{c}}\,\boldsymbol{\epsilon^{\prime}_{e}}=\mathbbm{E}[Z]\). Compare this with (3.5.10b) and (6.5.10a). The \(i\)th components of the three vectors \(\mathbf{y_{c}}\), \(\boldsymbol{\pi_{e}}\), and \(\mathbf{x_{c}}/\mathbbm{E}[Z]\) are, respectively, the steady-state probability of finding \(S_{1}\) in state \(i\in\Xi_{c}\) between events, the steady-state probability that a leaving\(-\)re-entering customer will put \(S_{1}\) in state \(i\), and the steady-state probability that a random observer will find \(S_{1}\) in state \(i\).2 And then there is \(\mathbf{p_{c}}\) of (6.5.2a). Can anything be clearer?

Footnote 2: Note that \(\mathbf{x_{c}}\) is the same as that given by the product-form solution for Jackson networks.

We have seen that the vector-matrix pair \(\boldsymbol{\langle}\mathbf{p_{ic}}(\mathbf{Y_{c}}\,\mathbf{R_{c}})^{n-1}\,, \,\mathbf{B_{c}}\boldsymbol{\rangle}\) generates the interdeparture-time distribution for the \(n\)th customer to leave \(S_{1}\) when there are more than \(n+C\) customers in the queue initially. We have also seen that when \(n\) is large enough, all the interdeparture distributions are the same and are generated by the pair \(\boldsymbol{\langle}\boldsymbol{\pi_{e}}\,,\,\mathbf{B_{c}}\boldsymbol{\rangle}\). Can we not say, then, that this process approaches a renewal process asymptotically? The answer to this is no, but the explanation is very subtle. The manifest property that is missing is _independence_. In renewal processes, interdepartur

<!-- Pages 420-420 -->

1. What is the relation between the product-form solution of steady-state Jackson networks and the matrices we had to create for the M/ME/\(C\)//\(C\) loop? It would seem that the only properties necessary for the two to give the same results is that the dimension of the \(\Xi_{k}\)'s be equal to the binomial coefficients as given in (6.3.6b).

2. There is no formal difference between a subsystem with \(C\) identical servers and the generalized subsystem. But the former has some special properties, and it would seem that those matrices should be capable of being broken down into smaller parts, so that the difference between the two can be seen explicitly.

3. Do there exist smaller-dimensional matrices that represent these processes equally well? We should be able to study the class of similarity transformations that leave the various equations invariant or the various results unchanged.

#### 6.5.3 A Little Bit of Up and Down, with Arrivals

The work we did in Chapters 4 and 5 on first-passage matrices and times, as well as the various \(\mathbf{W}\) matrices and other properties of the busy period, can be generalized to the networks we are treating in this chapter. We must be more careful though, because the operators, both in size and content, change from one queue length to the next. We give a sampling of how this can be done in just two areas, first-passage times up and first-passage times down. These two topics have increasingly important applicability to real-world problems. "Up" is easier, so we do that first.

#### 6.5.3.1 First-Passage Processes for Queue Growth

What we are about to do is taken directly from Section 4.5.1 with the added problem that dimensions and operators change as we go up the ladder. We also have the problem of setting up new notation. As in previous chapters, we use the symbol \(\mathbf{H}\) for our isometric first-passage matrices. We also need an auxiliary matrix for definition purposes. So, for our first definition,

_Definition 6.5.6_.

\(\mathbf{X_{k}:=}\) _probability matrix of first passage from \(k\) to \(k+1\) where \(k<C\)._

That is, \([\mathbf{X_{k}}]_{ij}\) is the probability that \(S_{1}\) will be in state \(j\in\Xi_{k+1}\) when its queue goes from \(k\) to \(k+1\) for the first time, given that it started in state \(i\in\Xi_{k}\). This is a \(D(k)\times D(k+1)\)-dimensional matrix and is isometric, because \(\mathbf{X_{k}\ell^{\prime}_{k+1}:=\ell^{\prime}_{k}}\). \(\mathbf{X_{k}}\) will soon be replaced by \(\mathbf{H_{k}}\) so we are not bothering to use \(\mathbf{u}\) for _up_ Note that this matrix is only defined for \(k<C\). 

To be consistent with previous notation, \(\mathbf{X}\) should have been subscripted as \(\mathbf{k+1}\), because that matches the higher dimension of this rectangular matrix. However, we soon after define the related matrix \(\mathbf{H}\), which is the one we actually use in our final formulas.

<!-- Pages 421-421 -->

Look at the time-dependent state diagram in Figure 6.5.1. There are five different types of equations we must look at for queue growth, namely \(0<1<k<C<n\). \(N\) is relevant only for queue decrease. Let us start with no-one at \(S_{1}\). Then all that can happen is for a customer to arrive, putting \(S_{1}\) into state \(\mathbf{p}\). Therefore,

\[\mathbf{X_{o}}=\mathbf{p}.\]

Next consider one customer in \(S_{1}\). Three things can happen.

1. A second customer arrives directly, with probability \(\lambda[\mathbf{M_{1}}+\lambda\mathbf{I_{1}}]^{-1}\), and enters, thereby changing the state of the subsystem \([\mathbf{R_{2}}]\).

2. A transition occurs in \(S_{1}\), \(\left[\mathbf{M_{1}}(\mathbf{M_{1}}+\lambda\mathbf{I_{1}})^{-1}\right]\), resulting in a customer changing phase \([\mathbf{P_{1}}]\), and then eventually the queue gets to length 2, \([\mathbf{X_{1}}]\).

3. A transition occurs in \(S_{1}\), \(\left[\mathbf{M_{1}}(\mathbf{M_{1}}+\lambda\mathbf{I_{1}})^{-1}\right]\), resulting in a customer leaving \([\mathbf{Q_{1}}=\mathbf{q}^{\prime}]\), and then the queue eventually grows from 0 to 1 to 2, \([\mathbf{X_{o}}\mathbf{X_{1}}]\).

The equation for this is [where \(\mathbf{M_{1}}(\mathbf{M_{1}}+\lambda\mathbf{I_{1}})^{-1}=(\mathbf{M_{1}}+ \lambda\mathbf{I_{1}})^{-1}\,\mathbf{M_{1}}\)]

\[\mathbf{X_{1}}=\lambda[\mathbf{M_{1}}+\lambda\mathbf{I_{1}}]^{-1}\mathbf{R_{2 }}+\mathbf{M_{1}}[\mathbf{M_{1}}+\lambda\mathbf{I_{1}

<!-- Pages 423-423 -->

**Definition 6.5.7**: \([\mathbf{H_{uk}}]_{ij}:=probability\) _that \(S_{1}\) will be in state \(j\in\Xi_{k}\) just before a customer arrives and enters \(\left[\mathbf{R_{k+1}}\right.\)/ to raise the queue length from \(k\) to \(k+1\) for the first time, given that \(S_{1}\) started in state \(i\in\Xi_{k}\). \(\mathbf{H_{uk}}\) and \(\mathbf{X_{k}}\) are related by (6.5.14)._

Now we must look at the system when there are \(C\) or more customers at \(S_{1}\). To do that we must first define a set of matrices for \(n\geq C\).

**Definition 6.5.8**: \(\mathbf{H_{uc}}(n):=probability\) _matrix of first passage from n to \(n+1\) where \(n\geq C\)._ Thus \([\mathbf{H_{uc}}(n)]_{ij}\) is the probability that \(S_{1}\) will be in state \(j\in\Xi_{c}\) just after a customer arrives to raise the queue length from \(n\) to \(n+1\) for the first time, given that the process started with the system in state \(i\in\Xi_{c}\)._

We do not need the auxiliary \(\mathbf{X}\) matrices, because the first-passage matrices of Definition 6.5.8 are already square and isometric. Put another way, from what we know of their meanings, they must be equal. After all, if the queue length at \(S_{1}\) is greater than or equal to \(C\), the system will be in the same internal state immediately before and immediately after an arrival.

Let us start with \(n=C\). The first-passage matrix satisfies

\[\mathbf{H_{uc}}(C) =\lambda[\mathbf{M_{c}}+\lambda\mathbf{I_{c}}]^{-1}+\mathbf{M_{ c}}[\mathbf{M_{c}}+\lambda\mathbf{I_{c}}]^{-1}\mathbf{P_{c}}\,\mathbf{H_{uc}}(C)\] \[+\mathbf{M_{c}}[\mathbf{M_{c}}+\lambda\mathbf{I_{c}}]^{-1}\mathbf{ Q_{c}}\,\mathbf{H_{uc}}\,\mathbf{H_{uc}}(C).\]

When we solve explicitly for \(\mathbf{H_{uc}}(C)\) we get

\[\mathbf{H_{uc}}(C)=\lambda[\lambda\,\mathbf{I_{c}}+\mathbf{B_{c}}-\mathbf{M_{ k}}\mathbf{Q_{c}}\mathbf{H_{uc}}(\mathbf{c-1})\mathbf{R_{c}}]^{-1}.\]

This is in exactly the same form as (6.5.15a), so we can say that

\[\mathbf{H_{uc}}(C)=\mathbf{H_{uc}},\]

but things are a little different from now on. The defining equation when \(n>C\) is the following.

\[mathbfH_{uc}(n) =\lambda[\mathbf{M_{c}}+\lambda\mathbf{I_{c}}]^{-1}+\mathbf{M_{ c}}[\mathbf{M_{c}}+\lambda\mathbf{I_{c}}]^{-1}\mathbf{P_{c}}\mathbf{H_{uc}}(n)\] \[+\mathbf{M_{c}}[\mathbf{M_{c}}+\lambda\mathbf{I_{c}}]^{-1}\mathbf{ Q_{c}}\mathbf{R_{c}}\mathbf{H_{uc}}(n-1)\mathbf{H_{uc}}(n).\]

Notice the subtle change. In the last term, \(\mathbf{R_{c}}\) is now to the left of \(\mathbf{H_{uc}}(n-1)\) and \(\mathbf{H_{uc}}(n)\) instead of between them. The reason is simple. When there are more than \(C\) customers at the subsystem, a departing customer can immediately be replaced \([\mathbf{R_{c}}]\), and eventually a customer comes to raise the queue to \(n+1\) for the first time \([\mathbf{H_{uc}}(n)]\). If there are \(C\) or fewer customers at \(S_{1}\), then eventually the subsystem has \(k-1\) customers when a new one arrives, \([\mathbf{H_{u(k-1)}}]\), and imediately enters \([\mathbf{R_{k}}]\). This, by the way, shows us the significance of having matrices that do not commute \((\mathbf{H_{u(e-1)}}\mathbf{R_{c}}\neq\mathbf{R_{c}}\mathbf{H_{u(e-1)}})\). This slight difference yields a somewhat different recursive equation:

\[\mathbf{H_{uc}}(n)=\lambda[\lambda\mathbf{I_{c}}+\mathbf{B_{c}}-\mathbf{M_{c }}\,\mathbf{Q_{c}}\,\mathbf{R_{c}}\,\mathbf{H_{uc}}(n-1)]^{-1}. \tag{6.5.15b}\]

<!-- Pages 424-424 -->

We leave it as an exercise to prove that these matrices are isometric.

Recall that \(\mathbf{p_{k}}\) from Equations (6.5.2) is the state probability vector for \(S_{1}\) if \(k\) customers entered the empty subsystem simultaneously. If the customers arrived randomly, the state \(S_{1}\) would be in when there are finally \(k\) customers there for the first time is defined by (compare with Definition 4.5.4) the following.

_Definition 6.5.9_.: \(\mathbf{p_{uk}}(n):=probability\) _vector of first passage from 0 to n. \([\mathbf{p_{uk}}(n)]_{i}\) is the probability that \(S_{1}\) will be in state \(i\in\Xi_{k}\) when there are \(n\) customers there for the first time. Two conventions go with this. First, \(k=n\) when \(n\leq C\), and \(k=C\) when \(n\geq C\). Second, when \(k=n\leq C\), we drop the argument:_

\[\mathbf{p_{uk}}:=\mathbf{p_{uk}}(k)\quad\text{for}\;\;k\leq C.\]

_The process starts with the arrival of the first customer and ends when the queue (including the customers in service) reaches \(n\). The queue could have gone back to 0 any number of times before the process ends._

It is plain to see that

\[\mathbf{p_{uk}}:=\mathbf{pH_{u1}R_{2}H_{u2}R_{3}\cdots H_{uk-1}R_{k}}\quad \text{for}\;\;n=k\leq C\] (6.5.16a) and for \[n>C\] \[\mathbf{p_{uc}}(n): =\mathbf{pH_{u1}R_{2}H_{u2}R_{3}\cdots H_{uc-1}R_{c}H_{uc}H_{uc}(C +1)\cdots H_{uc}(n-1)\] \[=\mathbf{p_{uc}}\,H_{uc}\,H_{uc}(C+1)\cdots H_{uc}(n-1). \tag{6.5.16b}\]

We can read these formulas physically. A first customer arrives \([\mathbf{p}]\). There is one customer at \(S_{1}\) when a second one arrives \([\mathbf{H_{u1}}]\), and enters \([\mathbf{R_{2}}]\). Eventually, there are two customers at \(S_{1}\) when a third one arrives \([\mathbf{H_{u2}}]\), and enters \([\mathbf{R_{3}}]\), and so on. Once there are \(C\) or more customers in the subsystem \([\mathbf{H_{c}}(n)]\), the arriving customer does not enter (no \(\mathbf{R}\)). The \(\mathbf{p_{u}}\) vectors satisfy a natural recursive equation.

\[\mathbf{p_{u(k+1)}} =\mathbf{p_{uk}}\mathbf{H_{uk}R_{k+1}}\quad\text{for}\;\;k<C, \tag{6.5.16c}\] \[\mathbf{p_{uc}}(n+1) =\mathbf{p_{uc}}(n)\mathbf{H_{uc}}(n)\quad\text{for}\;\;n\geq C. \tag{6.5.16d}\]

Without belaboring the point, note the difference between \(\mathbf{p_{c}}\) and \(\mathbf{p_{uc}}(n)\). In the former, even if more than \(C\) customers arrive simultaneously, only \(C\) of them will enter, so the vector is the same for all \(n\geq C\). In the latter case, when that special customer who will raise the queue to \(n+1\) for the first time, arrives, even though he does not enter \(S_{1}\), the system is in a special state. That special state \(\mathbf{p_{uc}}(n)\) is different for all \(n\).

After the following definition, we are finally ready to set up equations for the first-passage times, after which we summarize everything in a theorem.

<!-- Pages 426-426 -->

**Theorem 6.5.3:** Given a generalized M/ME/\(C\)-type queue, the mean first-passage time vectors for the queue at \(S_{1}\) to grow by 1, and associated matrices, can be constructed in the following way.

(a) Probability matrices of first passage from \(n\) to \(n+1\), \({\bf H_{uk}},{\bf H_{uc}}(n)\), as defined by Definitions 6.5.5 through 6.5.7 and Equation (6.5.14), are given by the following.

\[{\bf H_{u0}}=1\ \ \ \ \ {\bf Q_{1}}={\bf q},\ \ {\bf R_{1}}={\bf p}\]

[from (6.5.15a)]

\[{\bf H_{uk}}=\lambda[\lambda{\bf I_{k}}+{\bf B_{k}}-{\bf M_{k}}{\bf Q_{k}}{\bf H _{uk-1}}{\bf R_{k}}]^{-1},\ \ \ \ \ k=1,2,\ldots,C,\]

and from (6.5.15b), with \({\bf H_{uc}}(C)={\bf H_{uc}}\),

\[{\bf H_{uc}}(n)=\lambda[\lambda{\bf I_{c}}+{\bf B_{c}}-{\bf M_{c}}\,{\bf Q_{c} }\,{\bf R_{c}}\,{\bf H_{uc}}(n-1)]^{-1},\ \ \ \ \ n>C.\]

Every \({\bf H_{u}}\) is isometric.

(b) The first-passage time vectors, as defined by Definition 6.5.10, are given by the following [(6.5.17a) and (6.5.17b)].

\[{\boldsymbol{\tau^{\prime}_{u0}}}=\frac{1}{\lambda}\ \ \ \mbox{and}\ \ \ { \boldsymbol{\tau^{\prime}_{u1}}}=\frac{1}{\lambda}{\bf H_{u1}}\left[{\bf I_{1} }+\frac{1}{\lambda}{\bf B_{1}}\right]{\boldsymbol{\epsilon^{\prime}_{1}}}\]

[from (6.5.17c)],

\[{\boldsymbol{\tau^{\prime}_{uk}}}(n)=\frac{1}{\lambda}{\bf H_{uk}}[{\boldsymbol {\epsilon^{\prime}}}{\bf k}+{\bf M_{k}}{\bf Q_{k}}\,{\boldsymbol{\tau^{\prime }_{uk-1}}}],\ \ \ \ \ 1<k\leq C,\]

and [from (6.5.17d)], with \({\boldsymbol{\tau^{\prime}_{ue}}}(C)={\boldsymbol{\tau^{\prime}_{ue}}}\),

\[{\boldsymbol{\tau^{\prime}_{uc}}}(n)=\frac{1}{\lambda}{\bf H_{c}}(n)[{ \boldsymbol{\epsilon^{\prime}_{c}}}+{\bf M_{c}}\,{\bf Q_{c}}\,{\bf R_{c}}\,{ \boldsymbol{\tau^{\prime}_{uc}}}(n-1)],\ \ \ \ \ n>C.\]

(c) The probability vectors of first passage from 0 to \(n\), as defined in Definition 6.5.9, are given by the following.

\[{\bf p_{u1}}={\bf p}\]

[from (6.5.16)]

\[{\bf p_{u(k+1)}}={\bf p_{uk}}{\bf H_{uk}}{\bf R_{k+1}}\ \ \ \ \ k=1,\,2,\ldots,\,C-1,\]

\[{\bf p_{ue}}(n+1)={\bf p_{ue}}(n){\bf H_{uc}}(n)\ \ \ \ \ n=C,\ C+1,\ldots.\]

These equations are equally applicable to closed M/ME/\(C\)//\(N\) loops, as long as \(n\) does not exceed \(N\).

Remember that these processes include the possibility that the queue could drop to zero one or more times before rising to the given length.

<!-- Pages 428-428 -->

Variation 3 can give an idea of how bad things might get for the rest of the day. For instance, the afternoon arrival rate may be different from that which was used to calculate Equations (6.5.1). Presumably, other variations and interpretations can be thought up.

##### 6.5.3.2 First Passages for Queue Decrease

What we do here is very similar to that which we did in the preceding section, with one extra complication (there always is one more). In going _up_ there is always the natural floor, namely, the queue can never be less than 0. Here, unfortunately, the top can be anywhere, so we must carry \(N\) along in all our notation. Of course, when we go to the open system, \(N\) disappears, but in reliability theory, one seldom has an infinite number of backups, so the closed loop is important in its own right. Therefore, in what follows, we are looking at the M/ME/\(C\)//\(N\) loop.

Let us start, as usual, with the definition of a first-passage matrix.

_Definition 6.5.11_.:

\(\mathbf{H_{dc}}(n;N):=probability\) _matrix of first passage from n to \(n-1\), where \(N\geq n>C\)._\([\mathbf{H_{dc}}(n;N)]_{ij}\) is the probability that \(S_{1}\) will be in state \(j\in\Xi_{c}\) when its queue drops to \(n-1\) for the first time, given that it started in state \(i\in\Xi_{c}\) with \(n\) customers in the queue (including the \(C\) customers in service). This is a square isometric matrix of dimension \(D(C)\), but it has no inverse. 

For queue lengths less than, or equal to \(C\) we need slightly different matrices, which we define now.

_Definition 6.5.12_.:

\(\mathbf{H_{dk}}(N\,|\,C):=probability\) _matrix of first passage from \(k\) to \(k-1\), where \(C\geq k>0\)._\([\mathbf{H_{dk}}(N\,|\,C)]_{ij}\) is the probability that \(S_{1}\) will be in state \(j\in\Xi_{k-1}\) when its queue drops to \(k-1\) for the first time, given that it started in state \(i\in\Xi_{k}\) with \(k\) customers in the queue (all \(k\) customers are in service). This is an isometric, \(D(k)\times D(k-1)\)-dimensional matrix (proven below). 

In a moment we introduce a set of matrices that are invertible, although their interpretation is more difficult to grasp than these, but prove to be more convenient for our purposes. First let us set up the equation for the \(\mathbf{H_{dc}}\) matrices. When all customers are at \(S_{1}\) (refer to Figure 6.5.2), there can be no arrivals, so

\[\mathbf{H_{dc}}(N;N)=\mathbf{Q_{c}}\mathbf{R_{c}}+\mathbf{P_{c}}\mathbf{H_{dc }}(N;N),\]

which yields

\[\mathbf{H_{dc}}(N;N)=\mathbf{V_{c}}\mathbf{M_{c}}\mathbf{Q_{c}}\mathbf{R_{c}}.\] (6.5.21a) We already proved that this matrix is isometric in Section 6.5.2. Next, let us look at any other \(n\) greater than \(C\). Figure 6.5.2 shows that now three

<!-- Pages 431-431 -->

and

\[\mathbf{X_{k}}(N\,|\,C)=\frac{1}{\lambda}\mathbf{U_{k}}(N\,|\,C)\quad\text{for} \ \ 1\leq k\leq C. \tag{6.5.25b}\]

We now have everything we want to know about the \(\mathbf{H_{d}}\) matrices.

**Lemma 6.5.4:** The matrices described in Definitions 6.5.10 and 6.5.11 are isometric and are related to the steady-state matrices by the following equations.

\[\mathbf{H_{dc}}(n;N)=\frac{1}{\lambda}\mathbf{U_{c}}(N-n)\mathbf{M_{c}} \mathbf{Q_{c}}\mathbf{R_{c}}\quad\text{for}\ \ C<n\leq N \tag{6.5.26a}\]

and

\[\mathbf{H_{dk}}(N\,|\,C)=\frac{1}{\lambda}\mathbf{U_{k}}(N\,|\,C)\mathbf{M_{k }}\mathbf{Q_{k}}\quad\text{for}\ \ 1\leq k\leq C. \tag{6.5.26b}\]

The \(\mathbf{U}\) matrices are given by Equations (6.3.6) and (6.3.7). \(\blacktriangle\)

**Proof:** The isometric property follows directly from (6.3.4b). **QED**

We saw something like this in Section 4.5.3, but \(\mathbf{H_{d}}(n;N)\) [the \(C=1\) equivalent to \(\mathbf{H_{dc}}(n;N)\)] turned out to be the matrix \(\mathbf{Q}\), so the relation equivalent to (6.5.26a) is trivial.

Note from (6.3.9) that it is \([(1/\lambda)\mathbf{U_{c}}(N-n)\mathbf{B_{c}}]\) that is isometric, and not \(\mathbf{U_{c}}(N-n)\) itself. Indeed, it is this product that has the physical interpretation, for we can rewrite (6.5.26a) as

\[\mathbf{H_{dc}}(n;N)=\frac{1}{\lambda}\mathbf{U_{c}}(N-n)\mathbf{B_{c}} \mathbf{V_{c}}\mathbf{M_{c}}\mathbf{Q_{c}}\mathbf{R_{c}}=\left[\frac{1}{ \lambda}\mathbf{U_{c}}(N-n)\mathbf{B_{c}}\right]\mathbf{Y_{c}}\mathbf{R_{c}},\]

where \(\mathbf{Y_{c}}\) comes from Definition 6.5.2 and (6.5.4a). From their definitions we see that the \([\mathbf{Y_{c}}\mathbf{R_{c}}]\) portion carries a process to a departure and subsequent entry without any intervening arrivals. Therefore, the \((ij)\)th component of the portion in brackets must be the probability that \(S_{1}\) is in state \(j\in\Xi_{c}\), with \(n\) customers, immediately after the last arrival but before the departure that finally lowers the queue to \(n-1\) for the first time (given that the system was originally in state \(i\in\Xi_{c}\) with \(n\) customers). This is a rather complicated interpretation, but it need not be understood for the development of our formulas. Perhaps we should have given a special symbol to the isometric product and used it in our exposition, and maybe we will in the future. From now on we stop using the \(\mathbf{X}\) matrices and express the first-passage times in terms of the already familiar \(\mathbf{H}\) matrices. First we give the _down_ equivalent of \(\boldsymbol{\tau^{\prime}_{\text{{uk}}}}(n)\) in Definition 6.5.10.

_Definition 6.5.13_.

\([\boldsymbol{\tau^{\prime}_{\text{{dk}}}}(n;N\,|\,C)]:=\)_mean first-passage time vector for a generalized M/ME/\(C//N\) loop to go from \(n\) to \(n-1\). The \(i\)th component is the mean time until the queue at \(S_{1}\) (as usual, including the ones in service) reaches \(n-1\) customers for the first time, given that the process

<!-- Pages 435-435 -->

Consider some of the variations we can perform.

1. The system has been running for a long time, and presently there are \(n\) functional devices (and \(N-n\) devices in repair). The initial vector is given by (6.5.1) for \(k=n\), and MTTF is given by \(t_{d}(n\to\phi;N)\).

2. We are starting with new devices, but only \(n\) are available at the moment, with \(N-n\) still awaiting single delivery at rate \(\lambda\). If a device fails, an order is made for a new one. The initial vector is given by (6.5.2) for \(k=n\), and MTTF is \(t_{d}(n\to\phi;N)\).

3. The system was originally as given in Definition 6.5.13, but two devices have already failed and one has been repaired. The initial vector is given by (assuming that \(N\geq C\))

\[\mathbf{p_{ic}}=\mathbf{p_{c}}\mathbf{H_{dc}}(N;N)\mathbf{H_{dc}}(N-1;N) \mathbf{H_{uc}}(N-2),\]

and MTTF is given by \(t_{d}(N-1\to\phi;N)\). Notice the _up_ first-passage matrix.

The last example can be very useful for _dynamically updating_ the MTTF. Every time a device fails, postmultiply the initial vector by the appropriate \(\mathbf{H_{dk}}\) to create an updated initial vector for the MTTF starting now. Similarly, every time a device is returned from repair, postmultiply by the appropriate \(\mathbf{H_{uk}}\). The MTTFs change accordingly. By virtue of the fact that the \(\mathbf{H}\) matrices do not commute, we see that the sequence "two failures followed by one repair" gives different results from "one failure followed by one repair and then another failure." Dynamic updating can help us even if we do not know the initial state. Pick any initial vector; then update it regularly. Eventually, your poor guess will be forgotten, and the updated vector will converge to the correct updated initial vector.

We could go on indefinitely enumerating systems that can be described this way, but we do only one more analysis before giving up on this chapter. Consider what happens when \(N\to\infty\). Ah yes, of course, the open system. We have actually done this already, because the \(\mathbf{H_{dk}}\) matrices are known in terms of the \(\mathbf{U_{k}}\) matrices. Remember, though, that the limit exists only if \(\rho_{c}\) given by (6.5.10b) is less than 1. From (6.4.1),

\[\mathbf{H_{dc}}:=\lim_{N\to\infty}\mathbf{H_{dc}}(n;N):=\frac{1}{\lambda} \mathbf{U_{c}}\mathbf{M_{c}}\mathbf{Q_{c}}\mathbf{R_{c}}\quad\text{for}\;\;n\geq C\] (6.5.32a) and \[\mathbf{H_{dk}}(\infty\,|\,C):=\lim_{N\to\infty}\mathbf{H_{dk}}(N\,|\,C)=\frac {1}{\lambda}\mathbf{U_{k}}(\infty\,|\,C)\mathbf{M_{c}}\mathbf{Q_{c}}. \tag{6.5.32b}\]

So we do not have to cascade the \(\mathbf{H_{d}}\) matrices down from infinity to find out what they are. In fact, they are all the same for \(n\geq C\). All we have to do is solve for \(\mathbf{U_{c}}\) in (6.4.1). Similarly, we can find the first-passage times,

\[\boldsymbol{\tau^{\prime}_{dc}}:=\lim_{N\to\infty}\boldsymbol{\tau^{\prime}_{ dc}}(n;N)=\frac{1}{\lambda}[\mathbf{K_{c}}(\infty)-\mathbf{I_{c}}]\boldsymbol{ \epsilon^{\prime}_{c}}.\]

But from its recursive definition, (6.3.13b), \(\mathbf{K_{c}}(\infty)\) can be shown to be

\[\mathbf{K_{c}}:=\mathbf{K_{c}}(\infty)=[\mathbf{I_{c}}-\mathbf{U_{c}}]^{-1} \tag{6.5.33}\]

<!-- Pages 436-436 -->

[compare with (4.2.2a)]. Therefore,

\[\boldsymbol{\tau^{\prime}_{\text{de}}}:=\frac{1}{\lambda}\mathbf{U_{c}}[\mathbf{ I_{c}}-\mathbf{U_{c}}]^{-1}\boldsymbol{\epsilon^{\prime}_{\text{e}}}. \tag{6.5.34}\]

How interesting (we think lots of things are interesting). These vectors are independent of \(n\), just like the M/ME/1 queue in (4.5.16a). Some thought would lead us to believe that this is reasonable. Does this mean that the time for the queue to drop by \(n\) is simply \(n\) multiplied by the time it takes to drop by \(1\), just as it is for the M/G/1 queue, based on (4.5.16b)? The answer is NO, because the departing customer leaves the system in a different state from that which it was in at the previous departure. Because of (6.5.32a), (6.5.29a) still holds true, and becomes

\[\mathbf{p_{de}}(n;\,l):=\lim_{N\to\infty}\mathbf{p_{dc}}(n;\,l;\,N)=\mathbf{p_{ ic}}\mathbf{H_{dc}^{l}}.\] (6.5.35a) Also, \[t_{d}(n;\,l+1):=\lim_{N\to\infty}t_{d}(n;l+1;N)=\mathbf{p_{dc}}(n-l) \boldsymbol{\tau^{\prime}_{\text{de}}}=\mathbf{p_{ic}}\mathbf{H_{dc}^{l}} \boldsymbol{\tau^{\prime}_{\text{de}}}. \tag{6.5.35b}\]

Each step takes a different amount of time from the previous one, but they are independent of \(n\) as long as the queue length at \(S_{1}\) (including those in service) is greater than \(C\). That is,

\[\mathbf{p_{dc}}(n_{1};l)=\mathbf{p_{dc}}(n_{2};\,l)\quad\forall\;\,n_{1},\,n_{ 2},\;\text{ such that }\;n_{i}-l>C.\]

There are many useful applications of this set of equations. Here are some that come to mind. Let \(\bar{q}\) be the mean number of customers at \(S_{1}\) in a steady-state system.

1. A computer system has been in operation for a long time, when suddenly \(n_{b}\) jobs arrive in a bunch, while the Poisson arrivals continue at the same rate. How long will it take before the system settles back down to its steady state? Use (6.5.1) as the initial vector, with \(k=\bar{q}\), but use \(n\) for \(n-l+1\) in (6.5.35b). We call this the _rush-hour traffic_ approximation.

2. A computer system has been running for a long time, with an arrival rate of \(\lambda_{\mathbf{1}}\). After 5 P.M., the arrival rate drops to \(\lambda_{\mathbf{2}}\). How long will it take to reach its new steady state? When can a part of the subsystem be taken offline (reduce \(C\))?

3. The system has been down for a while, and when it starts up there are \(n>\bar{q}\) jobs in the queue. How long will it take for the system to settle down?

### Conclusions

We have seen that there are innumerable problems that can be explored using M/ME/\(C\) queues. They are more general than single-class Jackson networks. In fact, the formulas as derived here apply to more general systems than the ones we called "generalized M/ME/\(C//N\) systems." The equations depend on the defined properties of the input matrices (i.e., \(\mathbf{M_{k}}\), \(\mathbf{Q_{k}}\), \(\mathbf{R_{k}}\), and \(\mathbf{P_{k}}\)) and

<!-- Pages 437-437 -->

not how they were constructed. Although we did describe how to construct them, we did not make use of those properties. In other words, almost any QBD process may be analyzed in this way. We have seen that our formalism covers a larger class of problems than we had intended. Therefore we wonder whether the matrices can be given more detailed properties that can be incorporated to yield more specific results.

Most of the material laid out here remains unexplored, even though it is now computationally manageable. It is hoped that this chapter, in particular, will help stimulate such activity.

The two groups who this author feels would be most interested in this material are researchers in computer performance and systems reliability. Yet their interests tend to be at opposite ends of the \(\rho\) scale. That is, performance modelers usually assume that the system can handle the load (\(\rho_{c}<1\)). Otherwise, throw away the system. Therefore, they are interested in steady-state solutions (probably overly so), and even open systems, particularly because systems with millions of customers now exist (e.g., packets on the internet). On the other hand, reliability researchers usually assume that it takes less time to fix an object than it took to break it (\(\rho_{c}>1\)). Therefore, except for questions of _inventory_, open systems are uninteresting. Furthermore, the steady state tells us nothing about MTTF. Yet the underlying formalism is identical for both groups. So it is important that the queueing theory practitioners in each camp understand clearly the difference of their goals when they communicate with each other.

<!-- Pages 438-438 -->

## Chapter 7 G/G/1/N Loop

_Those who cannot remember the past are condemned to repeat it._ George Santayana

We are finally facing up to giving structure to \(S_{2}\). In many ways, this is the hardest queueing system for which analytic results are known. The mathematics required at present to describe such systems is too complicated for one to get reasonable insight from the formulas themselves. Furthermore, we must now specify two nonexponential functions, finding that the system behavior depends not merely on \(\rho\), the ratio of their mean service times, and their second moments, or variances, but to a great extent on the parameter \(C(x)\), which is the probability that the customer in service at \(S_{1}\) will finish before the customer at \(S_{2}\). This parameter, in turn, depends on \(x\), the difference between the times when the two customers started service.

As long as \(S_{2}\) was exponentially distributed, \(C(x)\) (for \(x\geq 0\)) reduced to the Laplace transform of \(b_{1}(t)\), and everything came out to be reasonably manageable, as described in previous chapters. For the G/G/1//\(N\) queue, things get messy (messier?). In matrix representations, this shows up in the difficulty one has in describing two different servers that are simultaneously active. This involves taking the direct product of two independent vector spaces. Presently, we discuss one such way to do this, the Kronecker product, and then go on to find the steady-state solution of the ME/ME/1//\(N\) loop. We do not continue on to the open queue, because we have not found how to get an explicit solution for that case. We do, however, discuss how this might be done eventually. In the final section we discuss some transient behavior, by looking at the mean time to failure for a system with small \(N\).

This material is taken in large part from the PhD thesis by Appie van de Liefvoort[11], most of which was also published in [12]. But first we look at \(C(x\geq 0)\), without relying on any direct-product representation.

### 7.1 Basis-Free Expression for \(\mathbb{Pr}[X_{1}<X_{2}]\)

Let us consider two subsystems, \(S_{i},\;\;i=1,2\), each represented by \(\boldsymbol{\langle}\,\mathbf{p_{i}}\,,\,\mathbf{B_{i}}\boldsymbol{)}\) with dimension \(m_{i}\). Let \(X_{i}\) be the random variables for the service times of the two servers. Now suppose that \(S_{2}\) started service \(x\) units of time before

<!-- Pages 441-441 -->

transform, \([B_{1}^{*}(\lambda)]\) of \(b_{1}(x)\), as stated in the second paragraph of this chapter. Some authors have used the symbolic notation for \(C(0)\) in general,

\[C(0)=B_{1}^{*}(\mathbf{B_{2}}),\]

although it is not clear what it means, except in terms of (7.1.3b). The reader should be wary of this notation, because different authors assign different meanings to the same expression.

Now, you are dying to ask, "What can \((\mathbf{B_{1}+B_{2}})\) [or \((\mathbf{I+V_{1}B_{2}})\)] mean? How can one add two matrices from two different spaces together? After all, they may not even have the same dimensions. Why, that is like adding apples and oranges!" (and indeed it is). We can still delay giving the full answer if we avoid having to use \((\mathbf{B_{1}+B_{2}})\) directly. For instance, we can formally expand the expression for \(C(0)\) in a Maclaurin series, as follows.

\[C(0)=\Psi\left[\mathbf{I}+\sum_{k=1}^{\infty}(-1)^{k}\,\mathbf{V_{1}}^{k}\, \mathbf{B_{2}}^{k}\right]=1+\sum_{k=1}^{\infty}(-1)^{k}\,\Psi\left[\mathbf{V_{ 1}}^{k}\right]\,\Psi\left[\mathbf{B_{2}}^{k}\right].\]

[Remember that if two operators, \(\mathbf{A}\) and \(\mathbf{B}\), commute, then \((\mathbf{A}\mathbf{B})^{k}=\mathbf{A}^{k}\,\mathbf{B}^{k}\).] We know what \(\Psi\left[\mathbf{V_{1}}^{k}\right]\) and \(\Psi\left[\mathbf{B_{2}}^{k}\right]\) are from (3.1.8b) and (3.1.9). Therefore, if the series converges, we can write

\[C(0)=\sum_{k=o}^{\infty}\frac{\mathbf{E}[X_{1}^{k}]}{k!}R_{2}^{(k)}(0). \tag{7.1.3c}\]

We could get this expression directly from the integral form for \(C(0)\) in (7.1.3b), but still, it does show that the matrix forms in that equation have real meaning. The power of our formalism is utilized only when we can use \((\mathbf{B_{1}+B_{2}})^{-1}\) directly. So, without further delay, we finally show how this is done.

### 7.2 Direct Products of Vector Spaces

Equations involving matrices that operate on vectors in different spaces are not uncommon, although they are usually restricted to combinations of square matrices of order \(m\) with matrices of order \(1\), the scalars. In this case, no problems arise, given that there is a natural embedding of the scalars into the matrices of order \(m\): The scalars are isomorphic to the diagonal matrices whose nonzero elements are all equal. Because of this embedding, one does not hesitate to write \(a=a\cdot\mathbf{I}\), even though this equality does not make any sense technically. In this chapter we are dealing with two sets of matrices of order greater than \(1\). Before equations containing these objects can be evaluated, the matrices must be replaced by their images under an embedding into a _direct-product space_, much as the scalar \(a\) is replaced by \(a\cdot\mathbf{I}\) before the expression \(\mathbf{A}+a\cdot\mathbf{I}\) can be evaluated.

<!-- Pages 442-442 -->

#### 7.2.1 Kronecker Products

The _Kronecker product_ is one way to represent the _direct product space_ from combining two disjoint operator spaces. (For a standard exposition of the subject see e.g., [12].) In particular, if \(\mathbf{K_{1}}\) is an \(m_{1}\times n_{1}\) matrix operating on objects in space 1, and \(\mathbf{K_{2}}\) is an \(m_{2}\times n_{2}\) matrix of space 2, the Kronecker product of \(\mathbf{K_{1}}\) and \(\mathbf{K_{2}}\), denoted by \(\mathbf{K_{1}}\otimes\mathbf{K_{2}}\), is the matrix of size \((m_{1}m_{2})\times(n_{1}n_{2})\) that is obtained by multiplying each element of \(\mathbf{K_{1}}\) [designated as \((\mathbf{K_{1}})_{ij}\)] by the full matrix, \(\mathbf{K_{2}}\). Observe that \(\mathbf{K_{1}}\otimes\mathbf{K_{2}}\) can be regarded as an \(m_{1}\times n_{1}\) matrix whose elements are themselves matrices of size \(m_{2}\times n_{2}\). For instance, let \(\mathbf{K_{1}}\) be \(2\times 3\); then

\[\mathbf{K}:=\mathbf{K_{1}}\otimes\mathbf{K_{2}}=\left[\begin{array}{ccc}( \mathbf{K_{1}})_{11}\mathbf{K_{2}}&(\mathbf{K_{1}})_{12}\mathbf{K_{2}}&( \mathbf{K_{1}})_{13}\mathbf{K_{2}}\\ (\mathbf{K_{1}})_{21}\mathbf{K_{2}}&(\mathbf{K_{1}})_{22}\mathbf{K_{2}}&( \mathbf{K_{1}})_{23}\mathbf{K_{2}}\end{array}\right]. \tag{7.2.1}\]

Note that the Kronecker product is neither commutative nor symmetric. That is, \(\mathbf{K_{1}}\bigotimes\mathbf{K_{2}}\neq\mathbf{K_{2}}\bigotimes\mathbf{K_ {1}}\), although the two representations are equivalent. What we are doing, in essence, is creating a supermatrix \(\mathbf{K}\), with elements \(K_{\underline{k}l}\), where \(\underline{k}\) and \(\underline{l}\) are themselves ordered pairs. That is,

\[\underline{k}=(k_{1},k_{2})\in\{(k_{1},k_{2})|\ k_{1}\in\Xi,\ k_{2}\in\Xi_{2}\},\]

where \(\Xi_{i}\) is the set of internal states of \(S_{i}\). In order to write down \(\mathbf{K}\) in a rectangular array, it is necessary to give a linear ordering to the pairs \((k_{1},k_{2})\). Equation (7.2.1) implies one such ordering; \(\mathbf{\bar{K}}:=\mathbf{K_{2}}\otimes\mathbf{K_{1}}\) would give a different ordering. \(\mathbf{K}\) and \(\mathbf{\bar{K}}\) are the same size and have the same elements, but they are arranged differently. With this definition, the following multiplication rule is valid. Let \(\mathbf{K_{i}}\) and \(\mathbf{L_{i}}\) be any two arrays in space \(i\) for which \(\mathbf{K_{i}}\mathbf{L_{i}}\) is defined; then

\[\mathbf{K}\,\mathbf{L}=[\mathbf{K_{1}}\otimes\mathbf{K_{2}}]\cdot[\mathbf{L_{1 }}\otimes\mathbf{L_{2}}]=\mathbf{K_{1}}\mathbf{L_{1}}\otimes\mathbf{K_{2}} \mathbf{L_{2}}. \tag{7.2.2}\]

Note that \(\mathbf{K}\,\mathbf{L}=\mathbf{L}\,\mathbf{K}\) if and only if \(\mathbf{K_{1}}\,\mathbf{L_{1}}=\mathbf{L_{1}}\,\mathbf{K_{1}}\) and \(\mathbf{K_{2}}\,\mathbf{L_{2}}=\mathbf{L_{2}}\,\mathbf{K_{2}}\

<!-- Pages 445-445 -->

have in (7.1.2a). The two new projections are those that deflate \(\mathbf{X}\) to space \(i\). Define the following operations on any \(\mathbf{X}\).

\[\Psi_{2}\left[\mathbf{X}\right]:=\mathbf{\hat{p}_{1}}\left[\mathbf{X}\right] \boldsymbol{\acute{\epsilon}^{\prime}_{1}}, \tag{7.2.5a}\] \[\Psi_{1}\left[\mathbf{X}\right]:=\mathbf{\hat{p}_{2}}\left[\mathbf{X}\right] \boldsymbol{\acute{\epsilon}^{\prime}_{2}}. \tag{7.2.5b}\]

Note the apparent mismatch between the subscripts on \(\Psi_{i}\) and on the vectors. This is correct, for \(\Psi_{2}\left[\mathbf{X}\right]\) is a matrix in space 2. In a sense, the vectors \(\mathbf{p_{1}}\) and \(\boldsymbol{\acute{\epsilon}^{\prime}_{1}}\) have deflated the dependence of \(\mathbf{X}\) on space 1 to a scalar. This is quite clear if \(\mathbf{X}\) is itself an embedding of an operator in space 2. Suppose that \(\mathbf{X}=\mathbf{\hat{X}_{2}}=\mathbf{I_{1}}\otimes\mathbf{X_{2}}\). Then

\[\Psi_{2}\left[\mathbf{X}\right] =\mathbf{\hat{p}_{1}}\left[\mathbf{I_{1}}\otimes\mathbf{X_{2}} \right]\boldsymbol{\acute{\epsilon}^{\prime}_{1}}=\left(\mathbf{p_{1}}\otimes \mathbf{I_{2}}\right)\cdot\left[\mathbf{I_{1}}\otimes\mathbf{X_{2}}\right] \cdot\left(\boldsymbol{\acute{\epsilon}^{\prime}_{1}}\otimes\mathbf{I_{2}}\right)\] \[=\left[\mathbf{p_{1}}\mathbf{I_{1}}\boldsymbol{\acute{\epsilon}^{ \prime}_{1}}\right]\otimes\left(\mathbf{I_{2}}\mathbf{X_{2}}\mathbf{I_{2}} \right)=1\otimes\mathbf{X_{2}}=\mathbf{X_{2}}.\]

Thus we see that the projections \(\Psi_{i}\left[\mathbf{X}\right]\) are inverses of the embeddings \(\mathbf{\hat{X}_{i}}\), in an operator sense, and in fact satisfy the idempotent properties,

\[\hat{\Psi}_{i}\left[\hat{\Psi}_{i}\left[\mathbf{X}\right]\right]=\hat{\Psi}_{i }\left[\mathbf{X}\right], \tag{7.2.5c}\]

which can be proven after some effort by direct substitution. The most important single property of projection operators is that they are idempotent. That is, successive operations yield the same result, which indeed is shown by (7.2.5c). We look further at \(\Psi_{1}\left[\mathbf{X}\right]\), with the intention of reducing it to a scalar. Then

\[\mathbf{p_{1}}\Psi_{1}\left[\mathbf{X}\right]\boldsymbol{\acute{\epsilon}^{ \prime}_{1}=p_{1}}\mathbf{\hat{p}_{2}}\left[\mathbf{X}\right]\boldsymbol{ \acute{\epsilon}^{\prime}_{2}}\boldsymbol{\acute{\epsilon}^{\prime}_{1}}= \mathbf{p}\left[\mathbf{X}\right]\boldsymbol{\acute{\epsilon}^{\prime}}=\Psi \left[\mathbf{X}\right].\] (7.2.6a) Similarly, \[\mathbf{p_{2}}\Psi_{2}\left[\mathbf{X}\right]\boldsymbol{\acute{\epsilon}^{ \prime}_{2}}=\Psi\left[\mathbf{X}\right]. \tag{7.2.6b}\]

Thus the order in which one deflates \(\mathbf{X}\) is immaterial. Now, we could have written \(\Psi_{2}\left[\Psi_{1}\left[\mathbf{X}\right]\right]=\Psi_{1}\left[\Psi_{2} \left[\mathbf{X}\right]\right]\), but the outer \(\Psi_{2}\) (or \(\Psi_{1}\)) implies that this is an object in 2-space (or 1-space), when in fact it is a scalar. Therefore, we use the notation

\[\Psi\left[\Psi_{1}\left[\mathbf{X}\right]\right]=\Psi\left[\Psi_{2}\left[ \mathbf{X}\right]\right]=\Psi\left[\mathbf{X}\right], \tag{7.2.6c}\]

because it unambiguously says that whatever is inside the brackets is reduced to a scalar.

Before going on to the ME/ME/1//N queue, we conclude this section with three important lemmas.

**Lemma 7.2.2:** [_Eigenvalues and eigenvectors of \(\left(\mathbf{A_{1}}\otimes\mathbf{B_{2}}\right)\) and \(\left(\mathbf{\hat{A}_{1}}+\mathbf{\hat{B}_{2}}\right)\)_ ]. Let

\[\alpha_{1},\,\alpha_{2},\,\ldots,\,\alpha_{m_{1}}\]

be the eigenvalues of \(\mathbf{A_{1}}\), with corresponding left eigenvectors

\[\mathbf{a_{1}},\,\mathbf{a_{2}},\,\ldots,\,\mathbf{a_{m_{1}}}.\]

<!-- Pages 447-447 -->

with an identical result for \(\mathbf{\hat{Q}_{2}}\). In fact, every idempotent matrix satisfies the null equation. It follows directly that the following are true:

\[\mathbf{\hat{Q}_{1}\,\ell_{1}^{\prime}=\ell_{1}^{\prime},\quad\hat{Q}_{1}\, \ell^{\prime}=\ell^{\prime},\quad\hat{p}_{1}\,\hat{Q}_{1}=\hat{p}_{1},\quad p \,\hat{Q}_{1}=p.}\]

Recall that \(\mathbf{\hat{\ell}_{1}^{\prime}}\) is not a vector, but the first of the equations above tells us that each of its \(m_{2}\) columns is a right eigenvector of \(\mathbf{\hat{Q}_{1}}\) with eigenvalue \(1\). Given that \(\mathbf{\hat{Q}_{1}}\) is of rank \(m_{2}\), there are no other unit eigenvectors. The equivalent can be said of the \(m_{2}\) rows of \(\mathbf{\hat{p}_{1}}\). The duals of all these statements are valid for \(\mathbf{\hat{Q}_{2}}\). 

Also, from (7.2.3c) we know that \(\mathbf{\hat{p}_{1}\,\ell_{1}^{\prime}=I_{2}}\) and \(\mathbf{\hat{p}_{2}\,\ell_{2}^{\prime}=I_{1}}\).

**Lemma 7.2.4:** Let \(\mathbf{F}\) and \(\mathbf{G}\) be any matrices in the product space, and let \(\Psi_{2}\left[\mathbf{I-GF}\right]\) be nonsingular. Then the matrix \(\mathbf{I-FG_{1}G}\) is nonsingular, and its inverse is

\[(\mathbf{I-FG_{1}G})^{-1}=\mathbf{I+F}\,\left(\hat{\Psi}_{2}\left[\mathbf{I-GF} \right]\right)^{-1}\mathbf{\hat{Q}_{1}G}. \tag{7.2.7}\]

Interchanging the indices \(1\) and \(2\) gives the dual result. We have used the notation

\[\hat{\Psi}_{2}\left[\mathbf{X}\right]:=\mathbf{I_{1}}\otimes\Psi_{2}\left[ \mathbf{X}\right].\]

The proof, although tedious, is by direct multiplication. 

Note that this lemma is a direct generalization of Lemma 4.2.1, and Equations (4.2.2).

Before going on, the reader should be sure that the material of this section is fairly familiar. However, a specific example of embedded matrices is deferred until we have the explicit solution for the ME/ME/1//_N_ loop. Perhaps the best strategy would be to read everything, up through the example, as best one can, and then go back to the beginning of this section.

### Steady-State ME/ME/1//_N_ Loop

We have set up a rather elaborate mathematical apparatus and present a considerable number of formulas before this chapter is completed. If the reader feels that the concrete results we give appear small in comparison, be encouraged. We are presenting more formulas than necessary in the hope that they will help some reader to discover further significant results. We touch on this at the end of the chapter.

#### 7.3.1 Balance Equations

Let us consider the usual two-server loop as given in Figure 7.3.1. Each subsystem \(S_{i},\ i=1,2\), can only have one active customer at a time, and the

<!-- Pages 448-448 -->

queueing discipline is FCFS. Both \(S_{1}\) and \(S_{2}\) are nonexponential and represented by \(\mathbf{(p_{i},\,B_{i})}\), with dimension \(m_{i}>1\), and with associated objects, \(\mathbf{M_{i},\,V_{i},\,\epsilon_{i}^{\prime},\,\,Q_{i},\,P_{i}}\), and \(\mathbf{q_{i}^{\prime}=(I_{i}-P_{i})\epsilon_{i}^{\prime}}\). As before, the diagonal elements of \(\mathbf{M_{1}}\) are denoted by \(\mu_{k}\) (\(k=1\) to \(m_{1}\)), and as a generalization of previous chapters, the diagonal elements of \(\mathbf{M_{2}}\) are denoted by \(\lambda_{k}\) (\(k=1\) to \(m_{2}\)). \(N\) is the number of customers in the system, and \(n\) is the number at \(S_{1}\) (with \(N-n\) customers at \(S_{2}\)). If neither subsystem is empty, we must know where both of the active customers are to specify the system completely. Let \(\Xi_{i}\) be the set of phases associated with \(S_{i}\), where \(|\Xi_{i}|=m_{i}\). We extend the notation further.

**Definition 7.3.1**: \(\{\underline{k};\,n;\,N\}\) _corresponds to one possible state of an ME/ME/1//N loop, for \(0<n<N\). N is the total number of customers in the system, n is the number of customers at \(S_{1}\), including the one in service, and \(\underline{k}\) stands for the ordered pair \((k_{1},\,k_{2})\),where \(k_{i}\in\ \Xi_{i}\). We say that the system is in the state \(\{\underline{k};\,n;\,N\}\). \(\Xi:=\Xi_{1}\otimes\Xi_{2}:=\{(k_{1},\,k_{2})|k_{i}\in\Xi_{i},\,i=1,2\}\). Given that only one customer can be active at a time in \(S_{i}\), \(\Xi\) is the set of all internal states of the system as a whole. As long as neither queue is empty, we can say that the system is in internal state \(\underline{k}\in\Xi\), or that the active customers are at phases \(k_{1}\) and \(k_{2}\) in their respective subsystems. 

Clearly, \(|\Xi|=(m_{1}\cdot m_{2})\), but this full space is relevant only if \(n\neq 0\) and \(n\neq N\). In those two cases, the state space collapses to \(\Xi_{2}\) or \(\Xi_{1}\), respectively. With this understanding, we define the steady-state probability vectors.

**Definition 7.3.2**: \([\mathbf{\Pi}(n;\,N)]_{\Bbbk}:=\) _steady-state probability that there are n \((0<n<N)\)

<!-- Pages 449-449 -->

_customers at \(S_{1}\) and \(N-n\) customers at \(S_{2}\), where \(\underline{k}=(k_{1},\,k_{2})\in\Xi\)_ (i.e., the active customer at \(S_{i}\) is at phase \(k_{i}\)). [\(\boldsymbol{\Pi}(n;\,N)\)] is an \((m_{1}\cdot m_{2})\)-dimensional row vector whose components are ordered according to the Kronecker product convention implied in (7.2.1), which also corresponds to the lexicographical ordering

\[\boldsymbol{\Pi}(n;\,N)=[\Pi_{(1,1)},\Pi_{(1,2)},\ldots,\Pi_{(1,m_{2})},\Pi_{ (2,1)},\ldots,\Pi_{(m_{1},m_{2})}].\]

[We have suppressed the components' dependence on \((n;N)\).] The associated scalar probability is denoted by

\[r(n;N)=\boldsymbol{\Pi}(n;\,N)\boldsymbol{\epsilon^{\prime}}. \tag{7.3.1}\]

The steady-state probability vector for \(n=0\) is a vector in 2-space, because no one is at \(S_{1}\), and is denoted by \(\boldsymbol{\pi_{2}}(0;N)\). Similarly, the probability vector for \(n=N\) is denoted by \(\boldsymbol{\pi_{1}}(N;N)\). For convenience [in analogy with what we did in (4.1.1)], we define

\[\boldsymbol{\Pi}(0;\,N):=\mathbf{p_{1}}\otimes\boldsymbol{\pi_{2}}(0;N)\] (7.3.2a) and \[\boldsymbol{\Pi}(N;\,N):=\boldsymbol{\pi_{1}}(N;N)\otimes\mathbf{p_{2}}. \tag{7.3.2b}\]

With these definitions, (7.3.1) is valid for all \(n\). 

We are now ready to set up the balance equations. The process is a straightforward extension of Section 4.1.1. The complications arise in rewriting the equations as matrix equations of objects in the product space. Recall that the balance equations are derived from the fact that the sum of probability rates of arrows entering a given state is equal to the sum of those leaving. The arrows are shown in Figure 7.3.2 for an arbitrary state \(\{(k,s);\,n;\,N\}\), where \((k,s)\in\Xi\) (i.e., \(k\in\Xi_{1}\) and \(s\in\Xi_{2}\)) and \(0<n<N\). The probability rate of an arrow is, in turn, equal to the steady-state probability that the system is in the state designated by its tail, times the probability rate of leaving that state, times the probability that an arrow will occur, given that the system is in the state of the tail. For instance, the probability rate of the arrow going from \(\{(k,s);\,n;\,N\}\) to \(\{(k,t);\,n+1;\,N\}\) is

\[\left[[\boldsymbol{\Pi}(n;\,N)]_{(k,s)}\right]\times[\mu_{k}+\lambda_{s}] \times\left[\frac{\lambda_{s}}{\lambda_{s}+\mu_{k}}(\mathbf{q^{\prime}_{2}})_{ s}(\mathbf{p_{2}})_{t}\right]\]

\[=[\boldsymbol{\Pi}(n;\,N)]_{(k,s)}\lambda_{s}(\mathbf{q^{\prime}_{2}})_{s}( \mathbf{p_{2}})_{t}.\]

This particular arrow corresponds to the following process. The customer at phase \(s\) in \(S_{2}\) finishes there and leaves \([(\mathbf{q^{\prime}_{2}})_{s}]\), going to \(S_{1}\) and raising its queue length to \(n+1\). Simultaneously, the next customer in the queue enters \(S_{2}\), and goes to phase \(t\), \([(\mathbf{p_{2}})_{t}]\). There is one arrow for each phase in \(S_{2}\), so we must sum over \(t\).

When doing the same for the other seven types of arrows, we get the balance equations for \(0<n<N\). Given that the sum of the probabilities of

<!-- Pages 454-454 -->

These equations are rather complicated, but it seems clear that \(\mathbf{T}^{+}\) and \(\mathbf{T}^{-}\) exist as long as \(\Psi_{2}\Big{[}\mathbf{D}\mathbf{\hat{B}_{1}}\Big{]}\) and \(\Psi_{1}\Big{[}\mathbf{D}\mathbf{\hat{B}_{2}}\Big{]}\) are nonsingular. We assume this to be true. To assume otherwise would end our exploration instantly. We now introduce the pivotal matrix of this chapter, the one that is the true generalization of the \(\mathbf{U}\) in Equations (4.1.4), and the one that provides the geometric solution to the ME/ME/1/\(N\) loop. We use the same symbol for it.

\[\mathbf{U}:=\mathbf{T}^{+}\mathbf{S}^{-}=\left[\mathbf{I}-\mathbf{D}\mathbf{ \hat{B}_{2}}\mathbf{\hat{Q}_{1}}\right]^{-1}\left[\mathbf{I}-\mathbf{D}\mathbf{ \hat{B}_{1}}\mathbf{\hat{Q}_{2}}\right].\] (7.3.9a) Using ( 7.3.8a ) and ( 7.3.5b ), \[\mathbf{U}\] can also be expressed as \[\mathbf{U}=\left(\mathbf{I}+\mathbf{D}\mathbf{\hat{B}_{2}}\mathbf{\hat{Q}_{1}} \mathbf{\hat{\Psi}}_{2}^{-1}\left[\mathbf{D}\mathbf{\hat{B}_{1}}\right] \right)\left[\mathbf{I}-\mathbf{D}\mathbf{\hat{B}_{1}}\mathbf{\hat{Q}_{2}} \right].\] (7.3.9b) From Equations ( 7.3.5 ) and the discussion following them, we see that \[\mathbf{U}\] reduces precisely to ( 4.1.4b ) when \[S_{2}\] is one-dimensional, and \[\mathbf{U}^{-1}=\mathbf{T}^{-}\mathbf{S}^{+}=\left[\mathbf{I}-\mathbf{D} \mathbf{\hat{B}_{1}}\mathbf{\hat{Q}_{2}}\right]^{-1}\left[\mathbf{I}-\mathbf{D }\mathbf{\hat{B}_{2}}\mathbf{\hat{Q}_{1}}\right]\] (7.3.9c) reduces to \[\mathbf{A}\] in ( 4.1.4a ). Actually, another matrix, defined by \[\mathbf{R}:=\mathbf{S}^{-}\mathbf{T}^{+}=\left[\mathbf{I}-\mathbf{\hat{B}_{1} }\mathbf{\hat{Q}_{2}}\mathbf{D}\right]\left[\mathbf{I}-\mathbf{\hat{B}_{2}} \mathbf{\hat{Q}_{1}}\mathbf{D}\right]^{-1},\] (7.3.9d) could equally be the pivotal matrix.

We need one final set of equations before presenting the major goal of this chapter, which as usual we precede with a definition:

\[\mathbf{E}:=(\mathbf{I}-\mathbf{\hat{Q}_{1}})(\mathbf{I}-\mathbf{\hat{Q}_{2} })=(\mathbf{I}-\mathbf{\hat{Q}_{2}})(\mathbf{I}-\mathbf{\hat{Q}_{1}}).\] (7.3.10a) \[\mathbf{E}\] is idempotent, with rank \[(m_{1}-1)\cdot(m_{2}-1)\]. As with all idempotent matrices, \[(\mathbf{I}-\mathbf{E})\] is also idempotent, with rank \[m_{1}+m_{2}-1\]. Clearly, \[[m_{1}+m_{2}-1]+[(m_{1}-1)\cdot(m_{2}-1)]=m_{1}\cdot m_{2}\].

**Lemma 7.3.4:** For any matrix \(\mathbf{X}\) in the product space,

\[(\mathbf{I}-\mathbf{X}\mathbf{\hat{Q}_{i}})(\mathbf{I}-\mathbf{\hat{Q}_{i}}) =(\mathbf{I}-\mathbf{\hat{Q}_{i}}). \tag{7.3.10b}\]

Therefore, given that \(\mathbf{\hat{Q}_{1}}\) and \(\mathbf{\hat{Q}_{2}}\) commute,

\[\mathbf{S}^{+}\,\mathbf{E}=(\mathbf{\hat{B

<!-- Pages 455-455 -->

\[{\bf T}^{\pm}(\hat{\bf B}_{\bf 1}+\hat{\bf B}_{\bf 2}){\bf E}={\bf E}={\bf E}(\hat{ \bf B}_{\bf 1}+\hat{\bf B}_{\bf 2}){\bf T}^{\pm}. \tag{7.3.10f}\]

Also,

\[{\bf S}^{-}\,\hat{\bf Q}_{\bf 1}+{\bf S}^{+}\,\hat{\bf Q}_{\bf 2}=[\hat{\bf B}_{ \bf 1}+\hat{\bf B}_{\bf 2}][{\bf I}-{\bf E}] \tag{7.3.10g}\]

and

\[\hat{\bf Q}_{\bf 1}{\bf S}^{-}+\hat{\bf Q}_{\bf 2}{\bf S}^{+}=[{\bf I}-{\bf E}] [\hat{\bf B}_{\bf 1}+\hat{\bf B}_{\bf 2}]. \tag{7.3.10h}\]

The proofs are by direct substitution for \({\bf U}\), \({\bf R}\), \({\bf S}^{\pm}\), and \({\bf T}^{\pm}\). \(\quad\blacksquare\)

Equations (7.3.10) are used to prove our theorem, and they contain information that may be of critical importance for future research. Equations (7.3.10d) and (7.3.10e) look like eigenvalue equations, and in fact, imply that there are as many eigenvectors of \({\bf U}\) (and \({\bf R}\)) with eigenvalue \(1\) as the rank of \({\bf E}\). Therefore, \(({\bf I}-{\bf U})\) has at most \(m_{1}+m_{2}-1\) nonzero eigenvalues. In the previous chapters, \(m_{2}=1\), so \(({\bf I}-{\bf U})\) had \(m_{1}\) nonzero eigenvalues, which was all of them, and so was invertible. But now that \(m_{2}>1\), this is no longer true. The same statement can be made for \({\bf R}\). This inhibits our ability to find an explicit solution to the open ME/ME/1 queue.

The main theorem is now stated and proved.

**Theorem 7.3.5:** Given a closed ME/ME/1 //N loop, with \(N>1\), the steady-state vector and scalar probabilities are described by

\[{\bf\Pi}(n;\,N)={\bf\Pi}(0;\,N)\hat{\bf B}_{\bf 2}{\bf U}^{n}{\bf T}^{-},\ \ \ \ n=1,\,2,\,\ldots\,,\,N-1\;,\] (7.3.11a) and \[{\bf\Pi}(N;\,N)={\bf\Pi}(0;\,N)\hat{\bf B}_{\bf 2}{\bf U}^{N-1}\hat{\bf V}_{ \bf 1}. \tag{7.3.11b}\]

Equation (7.3.11a) can also be written in the form

\[{\bf\Pi}(n;\,N)={\bf\Pi}(0;\,N)\hat{\bf B}_{\bf 2}{\bf T}^{-}\,{\bf R}^{n-1}. \tag{7.3.11c}\]

This form would seem to be preferred, because the geometric factor appears at the right of the expression, allowing one to use

\[{\bf\Pi}(n;\,N)={\bf\Pi}(n-1;\,N){\bf R},\ \ \ \ n=1,\,2,\,\ldots\,,\,N-1\]

(which we actually do in the algorithm below). It remains to be seen which is more significant in the long run. \(\quad\blacksquare\)

**Proof:** First we show that Equations (7.3.11) are symmetric in \(S_{1}\) and \(S_{2}\). We do this by expressing everything in terms of \({\bf\Pi}(N;\,N)\) and interchanging \(1\) and \(2\). The interchange, in turn, causes \(+\) and \(-\) to interchange; thus \({\bf U}\) goes to \({\bf U}^{-1}\), which we call \({\bf A}\). From (7.3.11b) we get

\[{\bf\Pi}(0;\,N)={\bf\Pi}(N;\,N)\hat{\bf B}_{\bf 1}{\bf A}^{N-1}\hat{\bf V}_{ \bf 2}.\]

Similarly, from (7.3.11a) and the above, we get

\[{\bf\Pi}(n;\,N)={\bf\Pi}(N;\,N)\hat{\bf B}_{\bf 1}{\bf A}^{N-1}\hat{\bf V}_{ \bf 2}\hat{\bf B}_{\bf 2}{\bf U}^{n}{\bf T}^{-}\]

<!-- Pages 462-462 -->

where \(\mathbf{Q}=\mathbf{\hat{Q}_{1}}\mathbf{\hat{Q}_{2}}=\mathbf{Q_{1}}\otimes\mathbf{Q_ {2}}\), and

\[\mathbf{E}=(\mathbf{I}-\mathbf{\hat{Q}_{1}})(\mathbf{I}-\mathbf{\hat{Q}_{2}})= \left[\begin{array}{cccc}0&0&0&0\\ 0&0&0&0\\ 0&0&0&0\\ 1&-1&-1&1\end{array}\right]\!.\]

Note that both \(\mathbf{\hat{Q}_{1}}\) and \(\mathbf{\hat{Q}_{2}}\) are of rank 2, \([m_{i}]\), because they each have two linearly independent rows when considered as vectors. On the other hand, \(\mathbf{Q}\) is of rank 1, as it should be, because all four of its rows are the same. \(\mathbf{E}\) is also of rank 1 \([(m_{1}-1)\cdot(m_{2}-1)=1]\), because all of its columns are proportional to each other.

\[\mathbf{\hat{B}_{1}}=\mu\left[\begin{array}{cccc}1&0&-1&0\\ 0&1&0&-1\\ 0&0&1&0\\ 0&0&0&1\end{array}\right]\!,\ \ \ \ \ \mathbf{\hat{B}_{2}}=\lambda\left[ \begin{array}{cccc}1&-1&0&0\\ 0&1&0&0\\ 0&0&1&-1\\ 0&0&0&1\end{array}\right]\!,\]

\[\mathbf{\hat{V}_{1}}=\frac{1}{\mu}\left[\begin{array}{cccc}1&0&1&0\\ 0&1&0&1\\ 0&0&1&0\\ 0&0&0&1\end{array}\right]\!,\ \ \ \ \mathbf{\hat{V}_{2}}=\frac{1}{\lambda}\left[ \begin{array}{cccc}1&1&0&0\\ 0&1&0&0\\ 0&0&1&1\\ 0&0&0&1\end{array}\right]\!.\]

Some composite matrices in the product space follow.

\[\mathbf{D}^{-1}=\mathbf{\hat{B}_{1}}+\mathbf{\hat{B}_{2}}=\mu\left[\begin{array} []{cccc}1+\rho&-\rho&-1&0\\ 0&1+\rho&0&-1\\ 0&0&1+\rho&-\rho\\ 0&0&0&1+\rho\end{array}\right],\]

\[\mu\mathbf{D}=\frac{1}{(1+\rho)^{3}}\left[\begin{array}{cccc}(1+\rho)^{2} &\rho(1+\rho)&(1+\rho)&2\rho\\ 0&(1+\rho)^{2}&0&(1+\rho)\\ 0&0&(1+\rho)^{2}&\rho(1+\rho)\\ 0&0&0&(1+\rho)^{2}\end{array}\right].\]

Recall that in Section 7.1 we used this operator to find the expression for \(C(0)\), the probability that \(S_{1}\) would finish before \(S_{2}\), given that they started at the same time. In our example, this turns out to be [using (7.1.3b)]

\[C(0)=\Psi\left[\mathbf{\hat{B}_{1}}\mathbf{D}\right]=\frac{1+3\rho}{(1+\rho) ^{3}}\;. \tag{7.3.3}\]

<!-- Pages 463-463 -->

**Exercise 7.3.1:** You are to compare \(C(0)\) for three different cases as a function of \(\rho.\) The cases are (a) exponential-exponential, from Equation (2.1.1b) (call it \(C_{11}\)); (b) exponential-Erlangian-2 [\(C_{12},\) see (3.1.10) and recall the interpretion of \(B^{*}(s)\)]; and (c) Equation (7.3.16) (call it \(C_{22}\)). First verify that

\[\Psi_{2}\left[\mathbf{\hat{B}_{1}}\,\mathbf{D}\right]=\frac{1}{(1+\rho)^{3}} \left[\begin{array}{cc}1+\rho&2\rho\\ 0&1+\rho\end{array}\right]\!.\]

Then verify that \(C_{22}\) is correct [use (7.2.6)], and find similar expressions for the other two. Prove that the following inequalities hold.

\[C_{12}<C_{11}<C_{22}\quad\text{for}\;\;\rho<1,\] \[C_{12}<C_{22}<C_{11}\quad\text{for}\;\;1<\rho<\frac{1+\sqrt{17}}{ 2},\] \[C_{22}<C_{12}<C_{11}\quad\text{for}\;\;\frac{1+\sqrt{17}}{2}<\rho.\]

Remember that \(\rho=\bar{x}_{1}/\bar{x}_{2},\) which for \(C_{12}\) is not \(\lambda/\mu.\)

Continuing with matrices in the product space,

\[\mathbf{S}^{+}=\mu\left[\begin{array}{cccc}1&0&-1&0\\ 0&1&0&-1\\ -\rho&\rho&1+\rho&-\rho\\ 0&-\rho&0&1+\rho\end{array}\right]\!,\quad\mathbf{S}^{-}=\mu\left[\begin{array} []{cccc}\rho&-\rho&0&0\\ -1&1+\rho&1&-1\\ 0&0&\rho&-\rho\\ 0&0&-1&1+\rho\end{array}\right]\!.\]

The determinants of \(S^{\pm}\) are \(\mu^{4}\) and \(\lambda^{4},\) respectively, so these matrices are nonsingular. Their inverses are

\[\mathbf{T}^{+}=\frac{1}{\mu}\left[\begin{array}{cccc}1+\rho&-\rho&1&0\\ 0&1+\rho&0&1\\ \rho&-\rho&1&0\\ 0&\rho&0&1\end{array}\right]\!,\quad\mathbf{T}^{-}=\frac{1}{\mu\,\rho^{2}} \left[\begin{array}{cccc}1+\rho&\rho&-1&0\\ 1&\rho&-1&0\\ 0&0&1+\rho&\rho\\ 0&0&1&\rho\end{array}\right]\!.\]

The most important matrix, \(\mathbf{U},\) is not so simple looking:

\[\mathbf{U}=\mathbf{T}^{+}\mathbf{S}^{-}=\left[\begin{array}{cccc}\rho(2+ \rho)&-2\rho(1+\rho)&0&0\\ -(1+\rho)&(1+\rho)^{2}&\rho&0\\ \rho(1+\rho)&-\rho(1+2\rho)&0&0\\ -\rho&\rho(1+\rho)&\rho-1&1\end{array}\right]\!,\]

from which we can get

\[\Psi_{2}\left[\mathbf{U}\right]=\left[\begin{array}{cc}\rho(2+\rho)&-2\rho( 1+\rho)\\ -1&(1+\rho)^{2}\end{array}\right]\!.\]

From either of these equations one can calculate \(\Psi\left[\mathbf{U}\right]=\Psi\left[\Psi_{2}\left[\mathbf{U}\right]\right]= -\rho^{2}.\) The characteristic equation for \(\mathbf{U}\) is

\[\phi(\alpha)=\left|\mathbf{U}-\alpha\mathbf{I}\right|=(\alpha-1)\left(\alpha -\rho^{2}\right)\left(\alpha^{2}-[1+4\rho+\rho^{2}]\alpha+\rho^{2}\right).\]

<!-- Pages 464-464 -->

Therefore, the eigenvalues of \(\mathbf{U}\) are

\[\alpha_{1}=1,\ \ \ \ \alpha_{2}=\rho^{2},\ \ \ \ \alpha_{3}=\frac{(\rho^{2}+4 \rho+1)+Z(1+\rho)}{2}\]

and

\[\alpha_{4}=\frac{(\rho^{2}+4\rho+1)-Z(1+\rho)}{2},\]

where \(Z^{2}=\rho^{2}+6\rho+1\). Sadly, we see that one of the eigenvalues is \(1\). Therefore, \(\mathbf{I}-\mathbf{U}\) has no inverse. We knew this would happen from Lemma 7.3.2 and the discussion following it. We said that there are at most \(m_{1}+m_{2}-1\) roots, which do not equal \(1\). In our case, \(m_{1}=m_{2}=2\), so there are at most three. In fact, there are exactly three if \(\rho\neq 1\). The other difficulty we have is that \(\alpha_{3}\) is greater than \(1\) for all \(\rho\). Therefore, some matrix elements of \(\mathbf{U}^{n}\) must become unboundedly large as \(n\) increases. For what it is worth, the four eigenvalues satisfy the following inequality.

\[\alpha_{4}<\alpha_{2}<\alpha_{1}=1<\alpha_{3}\ \ \ \text{for}\ \ \rho<1\]

and

\[\alpha_{4}<\alpha_{1}=1<\alpha_{2}<\alpha_{3}\ \ \ \text{for}\ \ \rho>1.\]

The matrix \(\mathbf{R}\), having a unit eigenvalue, can do no better. It presumably also has an eigenvalue greater than \(1\). We leave it as an exercise for the reader to analyze \(\mathbf{R}\) in the way that we just analyzed \(\mathbf{U}\).

Where do we go from here? Despite all these formulas, we cannot go to the open system. In Section 4.2.1 we successfully took the limit of \(\mathbf{K}(N)\) as \(N\) went to infinity because \((\mathbf{I}-\mathbf{U})^{-1}\) existed. It does not here. In Section 5.1.1 we were able to take the limit because we were able to isolate a unique eigenvalue and its associated left and right eigenvectors. So far we have not been successful in finding an appropriate generalization of this. We know this much: Victor Wallace proved that all open QBD processes of a certain type (of which the ME/ME/1 queue is a special case) must have a matrix geometric solution [20]. It is just that neither \(\mathbf{U}\) nor \(\mathbf{R}\) appears to be that matrix. But an isometric transformation of \(\mathbf{U}\) or \(\mathbf{R}\) in the product space may well yield the correct matrix. We do not go into detail here, but it should be possible to find a transformation that yields a matrix for which the eigenvectors belonging to the eigenvalue \(1\) drop out of the solution. The solution, whatever it turns out to be, almost surely will reflect the characteristics of both the M/ME/1 and ME/M/1 queues, given that the ME/ME/1 queue is the generalization of both. (See, however, [10] for an iterative solution.) We have presented far more formulas than are necessary, in the hope that they will help some reader to discover how this can be done.

We close out the chapter with a short look at mean first-passage times for the queue at \(S_{1}\) to drop. Extensions to other transient properties are left to the reader's ingenuity.

<!-- Pages 465-465 -->

### 7.4 A Modicum of Transient Behavior

We do not go into too much detail of transient behavior for two nonexponential servers, not so much because it is so hard, but because it looks so much like what we already did in Section 4.5. All objects are in the product space, so should be wearing hats. To make things simple for us, we revert to the naive approach of Section 7.1. We only cover the first-passage processes to drop by \(1\), and thereby reproduce (4.5.29a) for this more general case. The reader should review Section 4.5 before continuing.

First recall Definition 4.5.7. The matrix \([\mathbf{H_{d}}(n;N)]_{\underline{k}\underline{l}}\) is identical in meaning, except that now

\[\underline{l},\,\underline{k}\in\Xi=\Xi_{1}\otimes\Xi_{2}.\]

As in Chapter 4, after a single event occurs, the queue at \(S_{1}\) can grow by one, decrease by one, or stay the same. The difference now is that there are two ways that it can stay the same, either by a transition in \(S_{1}\), \([\mathbf{P_{1}}]\), or a transition in \(S_{2}\), \([\mathbf{P_{2}}]\). Thus \(\mathbf{H_{d}}\) satisfies the following.

\[\mathbf{H_{d}}(n;N) =[\mathbf{M_{1}}+\mathbf{M_{2}}]^{-1}[\mathbf{M_{1}}\,\mathbf{P_{1 }}+\mathbf{M_{2}}\,\mathbf{P_{2}}]\,\mathbf{H_{d}}(n;N)

<!-- Pages 469-469 -->

## Chapter 5 Semi-Markov Process

_Prediction is difficult, particularly about the future._

Niels Bohr

(also attributed to Mark Twain,

but falsely attributed to Yogi Berra).

_We can chart our future clearly and wisely only when_

_we know the path which has led to the present._

Adlai Stevenson.

In many (if not most) real-world applications, the arrival of customers to a service center is not well described by renewal processses. Quite often, the times between successive arrivals are correlated, whereas renewal processes have independent interarrival times. A natural generalization is the class of _semi-Markov processes_ (SMP), which when specifically applied to the arrival of customers are called _Markov Renewal Processes_ (MRP) or _Markov Arrival Processes_ (MAP). Of course arrivals to one station correspond to departures from some other station. So, to avoid confusion, we use the terms SMP or MRP here.

In this chapter we set up a general procedure for creating a sequence of random variables \(\{X_{i}\}\) which may be thought of as the interarrival times of successive customers for some arrival process. The \(\{X_{i}\}\) has PDFs \(\{F_{i}(x_{i})\}\) which are generated by a sequence of representations with the same \(\boldsymbol{\mathcal{B}}\) but different entrance vectors, namely \(\{\boldsymbol{\langle\boldsymbol{\wp}_{1}\,,\,\boldsymbol{\mathcal{B}}\, \rangle}\}\). Interval \(i\) we call the \(\boldsymbol{\mathsf{t}}\)the\(epoch\). Recall that for a renewal process the \(X_{i}\) r.v.s are iid. In this chapter they are not independent, but they are asymptotically identically distributed. That is, for \(i\) large enough, \(\{F_{i}(x_{i})\}\) approaches a limit. Hence, some researchers retain the word, renewal in describing MRPs.

The set of formulas for the joint interdeparture distributions and correlation lag-\(k\) number are then set up, thereby showing that, indeed, the \(X_{i}\) and \(X_{j}\) are in most cases, correlated. We then show how they can be used to solve for various performance properties of SMP/M/1 queues. One of the first papers to try to formalize this was by Ramaswami [14]. The particular formulation presented here stems from the PhD thesis by Pierre Fiorini [17] and other works [17].

<!-- Pages 472-472 -->

From this definition, it follows that \(\sum_{j}\boldsymbol{\mathcal{L}}_{ij}=[\boldsymbol{\mathcal{L}}\boldsymbol{ \mathcal{E}}^{\prime}]_{i}\) is the subsystem instantaneous departure rate from state \(i\). But that is what \([\boldsymbol{\mathcal{B}}\boldsymbol{\mathcal{E}}^{\prime}]_{i}\) is. Therefore

\[\boldsymbol{\mathcal{L}}\boldsymbol{\mathcal{E}}^{\prime}=\boldsymbol{ \mathcal{B}}\boldsymbol{\mathcal{E}}^{\prime}. \tag{8.2.1}\]

Although \(\boldsymbol{\mathcal{L}}\) and \(\boldsymbol{\mathcal{B}}\) are related by this relation, they describe different parts of the process of interest. \(\boldsymbol{\mathcal{B}}\) generates what happens during the epoch, and \(\boldsymbol{\mathcal{L}}\) tells what happens immediately after the departure. (8.2.1) states that they agree about the rate of departure.

Given that \(\boldsymbol{\mathcal{Y}}:=\boldsymbol{\mathcal{B}}^{-1}\), we have

\[\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{L}}\boldsymbol{\mathcal{E}}^{ \prime}=\boldsymbol{\mathcal{E}}^{\prime}.\]

Because of its importance, we define

\[\boldsymbol{\mathcal{Y}}:=\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{L}}, \quad\text{with the property}\;\;\boldsymbol{\mathcal{Y}}\boldsymbol{\mathcal{E}}^{ \prime}=\boldsymbol{\mathcal{E}}^{\prime} \tag{8.2.2}\]

(i.e., \(\boldsymbol{\mathcal{Y}}\) is _isometric_;\(\boldsymbol{\mathcal{E}}^{\prime}\) is a right eigenvector of \(\boldsymbol{\mathcal{Y}}\) with eigenvalue \(1\)).

We can now observe that the \(j^{th}\) component of the vector, \([\boldsymbol{\mathcal{G}}_{\text{o}}\exp(-x\boldsymbol{\mathcal{B}})\, \boldsymbol{\mathcal{L}}]\) is the instantaneous probability rate for service to end at time \(x\), and for the subsystem to be in state \(j\) immediately after the departure. The sum over all post-departure states must yield the pdf for the process, and indeed it does. After all, from (8.2.1),

\[f_{X_{1}}(x):=\boldsymbol{\mathcal{G}}_{\text{o}}\left[\exp(-x\boldsymbol{ \mathcal{B}})\,\boldsymbol{\mathcal{L}}\right]\boldsymbol{\mathcal{E}}^{ \prime}=\boldsymbol{\mathcal{G}}_{\text{o}}\left[\exp(-x\boldsymbol{\mathcal{ B}})\,\boldsymbol{\mathcal{B}}|\boldsymbol{\mathcal{E}}^{\prime}\right. \tag{8.2.3}\]

(compare with Theorem 3.1.1.) Note that although \(f_{X_{1}}(x)\) is a scalar function of \(x\), the objects in square brackets are square matrices.

The initial state for the second customer, given that \(X_{1}=x\), is

\[\boldsymbol{\mathcal{G}}_{1}(x)=\frac{1}{f_{X_{1}}(x)}\boldsymbol{\mathcal{G} }_{\text{o}}\exp(-x\boldsymbol{\mathcal{B}})\,\boldsymbol{\mathcal{L}}. \tag{8.2.4}\]

The initial state for the second customer, averaged over all first-process times is given by

\[\boldsymbol{\mathcal{G}}_{1} =\int_{\text{o}}^{\infty}f_{X_{1}}(x)\,\boldsymbol{\mathcal{G}} _{1}(x)\,dx=\int_{\text{o}}^{\infty}\boldsymbol{\mathcal{G}}_{\text{o}}\, \exp(-x\boldsymbol{\mathcal{B}})\,\boldsymbol{\mathcal{L}}\,dx\] \[=\boldsymbol{\mathcal{G}}_{\text{o}}\left[\int_{\text{o}}^{ \infty}\,\exp(-x\boldsymbol{\mathcal{B}})\,dx\right]\,\boldsymbol{\mathcal{L}} =\boldsymbol{\mathcal{G}}_{\text{o}}\,\boldsymbol{\mathcal{V}}\boldsymbol{ \mathcal{L}}=\boldsymbol{\mathcal{G}}_{\text{o}}\,\boldsymbol{\mathcal{Y}}, \tag{8.2.5}\]

where (8.1.2a) for \(n=0\) was used. One can immediately generalize that the probability state of the system immediately after the \(n\)th departure (and the starting vector for the \((n+1)\)st epoch) is

\[\boldsymbol{\mathcal{G}}_{\text{n}}=\boldsymbol{\mathcal{G}}_{\text{n-1}}\, \boldsymbol{\mathcal{Y}}=\boldsymbol{\mathcal{G}}_{\text{o}}\,\boldsymbol{ \mathcal{Y}}^{n}. \tag{8.2.6}\]

Observe that the state the subsystem is in immediately after customer number (n-1) departs is the beginning state of the subsystem for generating the \(n\)th

<!-- Pages 474-474 -->

application it may be easier to construct \(\boldsymbol{Q}\) than one of the other two. We note that \(\boldsymbol{\mathcal{B}}\) always has an inverse (namely, \(\boldsymbol{\mathcal{V}}\)), \(\boldsymbol{Q}\) never has an inverse (\(\boldsymbol{Q}\boldsymbol{\mathcal{E}^{\prime}}=\boldsymbol{0}^{\prime}\) implies that \(\boldsymbol{Q}\) has a \(0\) eigenvalue), and \(\boldsymbol{\mathcal{L}}\) may or may not have an inverse (but we wouldn't know what to do with it anyway).

As mentioned earlier, \(\boldsymbol{\mathcal{B}}\) controls the subsystem during an epoch and \(\boldsymbol{\mathcal{L}}\) connects each epoch to the next. We show in some of the applications below that \(\boldsymbol{\mathcal{Q}}\) controls the subsystem irrespective of departures. This is a direct generalization of the discussion surrounding Figure 3.5.3, leading to \(\boldsymbol{\pi}_{r}\) the mean residual vector. \(\boldsymbol{\mathcal{Q}}\) can also be thought of as the _rate matrix_, or _generator of a continuous Markov chain_ as given in the discussion surrounding (1.3.2c) in Chapter 1. So if \(\boldsymbol{\mathcal{G}}\) describes the state of the subsystem at the beginning of an arbitrary epoch, then \(\boldsymbol{\pi}\) describes the state of the system as seen by a random observer who has no idea when the epoch began. This is discussed further in Section 8.3.1.

Before going on, we describe how our approach differs from that of other researchers. The matrix distribution function \(Q_{ij}(x)\), as defined in many books (e.g.,[10]), in our case denotes the probability that "a departure will occur by time \(x\) and the system will find itself in state \(j\), given that the system was in state \(i\) at time \(x=0\)." We, on the other hand, use the matrix density function, \(\exp(-x\boldsymbol{\mathcal{B}})\,\boldsymbol{\mathcal{L}}\), which when integrated from \(0\to x\) yields \([\mathbf{I}-\exp(-x\boldsymbol{\mathcal{B}})]\boldsymbol{\mathcal{Y}}\), the equivalent to \(Q_{ij}(x)\), except that, like [11], the matrix elements themselves can be matrices. Also, our \(\boldsymbol{\mathcal{Y}}\) corresponds to their \(P_{ij}:=\lim_{x\to\infty}Q_{ij}(x)\). For the applications given here, because of Theorem 8.1.1, the actual values of the components of \(\exp(-x\boldsymbol{\mathcal{B}})\) are not usually needed to get useful results.

#### 8.2.2 Correlation of Departures

Based on the material of the previous section, we can write down the joint probability distributions for the interdeparture times. The joint density function for the departure of the first \(n+k\) customers is given by

\[f_{X_{1}\,X_{2}\cdots X_{n}\ldots X_{n+k}}(x_{1},\,x_{2},\ldots,\,x_{n}, \cdots,\,x_{n+k})\]

\[=\boldsymbol{\mathcal{G}}_{\text{\sf{o}}}[\,\exp(-x_{1}\boldsymbol{\mathcal{ B}})\boldsymbol{\mathcal{L}}\,\cdots\,\exp(-x_{n}\boldsymbol{\mathcal{B}}) \boldsymbol{\mathcal{L}}\,\cdots\,\exp(-x_{n+k}\boldsymbol{\mathcal{B}}) \boldsymbol{\mathcal{L}}]

<!-- Pages 478-478 -->

Either of these two formulas can be used to evaluate \(\text{Cov}(X,\,X_{+k})\).

An interesting parameter sometimes evaluated in studying correlations is their sum over all \(k\). This cannot be done directly, because \(\sum_{k}\boldsymbol{\mathcal{Y}}^{k}\) diverges. But when either of the two formulas above is put into (8.2.12a), one gets

\[\sum_{k=1}^{\infty}\text{Cov}(X,\,X_{+k})=\sum_{i^{*}}\frac{\lambda_{i}}{1- \lambda_{i}}[\boldsymbol{\mathcal{\mathcal{Y}}}\,\boldsymbol{\mathcal{V}}^{ \prime}_{i}]\,[\mathbf{u}_{i}\,\boldsymbol{\mathcal{\mathcal{V}}}\boldsymbol {\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{ \mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{\mathcal{ \mathcal{ \mathcal{ }}}}}}}}}}}}}}}}}}}}}}}}}}}}

<!-- Pages 480-480 -->

as discussed in Section 3.5, this is a renewal process if \(\boldsymbol{\wp}_{\text{o}}=\mathbf{p}\). Otherwise it is called a _delayed renewal process_, as defined by Feller [15]. It has also been called a _generalized renewal process_. Needless to say, all autocovariances are equal to 0. Apparently, it is not generally realized (although well known in some circles) that the _counting process_ (Definition 3.5.1) associated with any renewal process (with the Poisson process being the lone exception) does have a non-vanishing covariance. See Section 3.5.4.2 for an example that displays this correlation.

#### 8.3.2 Markov Modulated (or Regulated) Processes

All the processes in the next few sections involve a _token_ that in the course of its actions modulates, or regulates the customer departures. First we describe how the token behaves. Then we discuss several ways that the token can control traffic.

##### The Underlying Generator, \(\boldsymbol{\mathcal{Q}}\)

Consider a closed system with \(M\) servers, \(\{S_{i}\ |\ 1\leq i\leq M\}\), each with service time \(T_{i}\) with distribution represented by \(\boldsymbol{(}\ \mathbf{p_{i}}\,,\,\mathbf{B_{i}}\ \boldsymbol{)}\) of dimension \(m_{i}\). The representations are assumed to be mutually inequivalent. The token wanders from server to server, spending a time \(T_{i}\) at \(S_{i}\) and then with probability \(P_{ij}\) goes to \(S_{j}\). The mean time the token spends at \(S_{i}\) is \(\bar{t}_{i}:=\mathbb{E}[T_{i}]=\mathbf{p_{i}}\,\mathbf{V_{i}}\,\boldsymbol{ \epsilon^{\prime}_{i}}\). \(\boldsymbol{P}\) is an \(M\)-dimensional Markov matrix with components \([\boldsymbol{P}]_{ij}=P_{ij}\). That is, \(\boldsymbol{Pe^{\prime}=\boldsymbol{\epsilon^{\prime}}}\), where \(\boldsymbol{\epsilon^{\prime}}\) is an \(M\)-dimensional column vector, all of whose components are 1. As with all Markov matrices there is a vector \(\boldsymbol{p}\) satisfying

\[\boldsymbol{p}\,\boldsymbol{P}=\boldsymbol{p},\quad\text{and}\quad\boldsymbol{ p}\,\boldsymbol{\epsilon^{\prime}}=1.\]

Only one server can be active at a time, therefore the set of states needed to describe this system is the union of the sets of states needed to describe each \(S_{i}\). The vector space describing the process is the _direct sum_ of the individual spaces. So if \(S_{i}\) is of dimension \(m_{i}\), the full space is of dimension

\[M_{m}:=\sum_{i=1}^{M}m_{i}.\]

We are dealing here with three levels of matrices. Each server \(S_{i}\) is described by a set of matrices (e.g., \(\mathbf{B_{i}}\)), the traffic between subsystems is governed by matrices (e.g., \(\boldsymbol{P}_{ij}\)), and the overall system has a matrix description (e.g., \(\boldsymbol{\mathcal{P}}\)). We hope to avoid confusion by standardizing our notation with the following definition.

_Definition 8.3.1_.: Consider an overall system \(\mathcal{S}\), which itself is made up of subsystems, \(S_{i}\). Then matrices and vectors that refer to \(\mathcal{S}\) as a whole are said to operate in _Composite-space_, or simply _\(\boldsymbol{\mathcal{C}}\)-space_, and are denoted by symbols of the form:

\[\boldsymbol{\wp},\,\boldsymbol{\pi},\,\boldsymbol{\mathcal{B}},\,\boldsymbol{ \mathcal{I}},\,\boldsymbol{\mathcal{L}},\,\boldsymbol{\mathcal{P}},\, \boldsymbol{\mathcal{Q}},\,\boldsymbol{\mathcal{V}},\,\boldsymbol{\mathcal{Y}}, \,\boldsymbol{\varepsilon^{\prime}}\ (\textbf{bold--faced\ CALCIGRAPHIC}).\]

<!-- Pages 483-483 -->

Let \(\mathbf{b^{\prime}}\) be any \(M\)-dimensional column vector with components \([\mathbf{b^{\prime}}]_{i}=b_{i}\); then the \(\mathbf{\mathcal{C}}\)-space \(M_{n}\) column vector is:

\[\mathbf{\mid}\mathbf{b^{\prime}}\mathbf{\ \rangle}:=[b_{1}\mathbf{\epsilon^{\prime}_{1}},\ b_{2}\bm {\epsilon^{\prime}_{2}},\ \ldots\ b_{M}\mathbf{\epsilon^{\prime}_{M}}]. \tag{8.3.4c}\]

These operators can be very useful when dealing with networks of non-exponential servers. For instance,

\[\mathbf{\varepsilon^{\prime}}=[\mathbf{\epsilon^{\prime}_{1}},\,\mathbf{\epsilon^{\prime }_{2}},\,\ldots,\,\mathbf{\epsilon^{\prime}_{M}}]=\mathbf{\mid}\mathbf{e^{\prime}}\mathbf{\ \rangle},\]

and suppose

\[\mathbf{\wp}=\mathbf{\big{\langle}}\mathbf{\ p}\mathbf{\big{|}}\ :=[\![p_{1}\,\mathbf{p}_{1},\,p_ {2}\,\mathbf{p}_{2},\,\ldots,\,p_{M}\,\mathbf{p}_{M}].\]

Let \(\mathbf{\mathcal{W}}\) be any matrix in \(\mathbf{\mathcal{C}}\)-space, then

\[\mathbf{\wp}\mathbf{\mathcal{W}}\mathbf{\varepsilon^{\prime}}=\mathbf{\big{\langle}}\mathbf{p} \mathbf{\big{|}}\mathbf{\mathcal{W}}\mathbf{\mid}\mathbf{e^{\prime}}\mathbf{\ \rangle}=\mathbf{p}\mathbf{W}\mathbf{e^{\prime}}.\]

This algebra is discussed in full in Section 9.3. 

We now examine several ways in which the token can regulate customer traffic.

#### 8.3.2.2 Markov Regulated Departure Process (MRDP)

We define a _Markov Regulated Departure Process_ (MRDP) as one in which a customer departs every time the token leaves a server. It follows that the time for the \(i\)th epoch is determined by where the token is after customer \(i-1\) leaves. We have already assumed that \(P_{ij}\) is a Markov matrix, but if all its rows are equal (\(P_{ij}=P_{kj}=p_{j}\) for all \(i,\,j,\,k\); i.e., \(\mathbf{P}=\mathbf{e^{\prime}}\mathbf{p}\)) then the process reduces to the renewal process of Section 8.3.1.

An alternate but equivalent picture is of an infinite queue feeding into a network with \(M\) servers \(\{S_{i}\,|\,1\leq i\leq M\,\}\), each with service time \(T_{i}\) from the distribution represented by \(\mathbf{\big{\langle}}\ \mathbf{p_{i}}\ \mathbf{,\,B_{i}}\ \mathbf{\big{\rangle}}\) of dimension \(m_{i}\). The customers enter, one at a time. When a customer departs from \(S_{i}\) he leaves the network and the next customer goes to \(S_{j}\) with probability \(P_{ij}\).

For MRDPs \(\mathbf{\mathcal{B}}\) is easy to express, because the time between customer departures is the same as the time the token spends at \(S_{i}\). Therefore,

\[\mathbf{\mathcal{B}}=\mathbf{\mathcal{B}}_{\rm o}\quad\text{and}\quad\mathbf{\mathcal{V}} =\mathbf{\mathcal{V}}_{\rm o}.\] (8.3.5a) Now that we have shown from ( 8.3.3d ) that \[\mathbf{\mathcal{Q}}=\mathbf{\mathcal{B}}_{\rm o}-\mathbf{\mathcal{B}}_{\rm o}\big{\langle} \mathbf{P}\mathbf{\big{\rangle}},\ \mathbf{\mathcal{L}}\ \text{and}\ \mathbf{\mathcal{Y}}\] follow directly: \[\mathbf{\mathcal{L}}=\mathbf{\mathcal{B}}-\mathbf{\mathcal{Q}}=\mathbf{\mathcal{

<!-- Pages 485-485 -->

Recall that \(\mathbf{E}[T_{i}^{\ell}]=\ell!\,\mathbf{p_{i}V_{i}^{\ell}\mathbf{\xi_{i}^{\prime}}} =\Psi_{i}[\mathbf{V_{i}}^{\ell}]\). Then

\[\mathbf{E}[X^{2}]=2\,\boldsymbol{\wp}\boldsymbol{\mathcal{V}}^{2}\boldsymbol{ \varepsilon^{\prime}}=2\sum p_{i}\Psi_{i}[\mathbf{V_{i}}^{2}]=2\boldsymbol{p }\,\boldsymbol{V_{o}^{(2)}}\boldsymbol{\varepsilon^{\prime}}=\sum p_{i} \mathbf{E}\left[T_{i}^{2}\right],\]

where

\[\boldsymbol{V_{o}^{(2)}} :=\text{Diag}[\Psi_{1}[\mathbf{V_{1}}^{2}],\,\Psi_{2}[\mathbf{V_ {2}}^{2}],\,\cdots,\,\Psi_{M}[\mathbf{V_{M}}^{2}]]\] \[=\frac{1}{2}\text{Diag}[\mathbf{E}[T_{1}^{2}],\,\mathbf{E}[T_{2}^ {2}],\,\cdots,\,\mathbf{E}[T_{M}^{2}]].\]

Note that \(\boldsymbol{V_{o}^{(\ell)}}\neq\boldsymbol{V_{o}}^{\ell}\) unless all \(S_{i}\) are exponential.

The specific form for (8.2.12a) in this case is

\[\text{Cov}(X,\,X_{+k})=\boldsymbol{p}\,\boldsymbol{V_{o}}\,[\boldsymbol{P}^{k }-\boldsymbol{\varepsilon^{\prime}}\,\boldsymbol{p}]\,\boldsymbol{V_{o}} \,\boldsymbol{\varepsilon^{\prime}}=\sum_{i,j}p_{i}\,\bar{t}_{i}\,[ \boldsymbol{P}^{k}-\boldsymbol{\varepsilon^{\prime}}\,\boldsymbol{p}]_{ij}\, \bar{t}_{j}\] (8.3.9a) with interdeparture density \[f(t)=\sum_{i=1}^{M}p_{i}\,f_{i}(t). \tag{8.3.9b}\]

Some of the properties of these equations can best be seen by examining a particular subsystem. The steady-state interdeparture density for a subsystem with two servers (\(M=2\)) follows.

**Example 8.3.1:** First, from \(\boldsymbol{p}\,\boldsymbol{P=p}\), it is seen that \(p_{1}=P_{21}/(P_{12}+P_{21})\) and \(p_{2}=1-p_{1}=P_{12}/(P_{12}+P_{21})\), so (8.3.9b) becomes

\[f(t)=\frac{P_{21}\,f_{1}(t)+P_{12}\,f_{2}(t)}{P_{12}+P_{21}},\]

and from (8.3.8c), the mean interdeparture time is

\[\mathbf{E}[X]=\frac{P_{21}\,\bar{t}_{1}+P_{12}\,\bar{t}_{2}}{P_{12}+P_{21}}.\]

Using \(\mathbf{E}[X^{\ell}]=p_{1}\mathbf{E}[T_{1}^{\ell}]+p_{2}\mathbf{E}[T_{2}^{ \ell}]\) and \(\sigma^{2}=\mathbf{E}[X^{2}]-(\mathbf{E}[X])^{2}\), it follows that

\[\sigma^{2}=p_{1}\sigma_{1}^{2}+p_{2}\sigma_{2}^{2}+p_{1}p_{2}(\bar{

<!-- Pages 486-486 -->

It is clear that if the \(\bar{t}_{i}\)s are equal, then all covariances are \(0\). All covariances are also \(0\), if \(P_{12}=P_{22}\). For then \(P_{12}+P_{21}=1\) and \(\mathbf{P}=\mathbf{e}^{\prime}\mathbf{p}\). That is, what happens in each epoch is independent of what happened in the previous epoch.

On the other hand, if \(P_{12}=P_{21}=1\) (\(P\) is cyclic), then

\[\mbox{Cov}(X,\,X_{+k})=(-1)^{k}\,\left(\frac{\bar{t}_{1}-\bar{t}_{2}}{2}\right) ^{2}.\]

In this case, the limit as \(k\to\infty\) does not exist, and the sum over \(k\) does not converge! [See Theorem 8.2.2.]

For a last word we look at the autocorrelations, \(\hat{r}(k)=\mbox{Cov}(X,\,X_{+k})/\sigma^{2}\). They depend on \(S_{1}\) and \(S_{2}\) only through their variances. The bigger \(\sigma_{1}^{2}\) and \(\sigma_{2}^{2}\) are, the smaller is \(\hat{r}(k)\). In the other direction, if the two distributions are deterministic, their variances equal \(0\) and

\[\hat{r}(k)=(1-P_{12}-P_{21})^{k}.\]

The dependence on the distributions is completely gone; and all that remains is a "coin-flipping" game. The _Bernoulli process_ corresponds to \(P_{12}=P_{21}\) with \(\hat{r}(k)=0\). The probability of flipping a \(1\) is \(P_{11}=P_{21}\).

If \(P_{12}\) does not equal \(P_{21}\), the game is biased in that the probability of a \(1\) depends on the result of the previous flip. \(\blacktriangle\)

What is most interesting about these processes is that their mean epoch times (\(\mathbf{\mathbb{E}}[X_{n}]\)) and correlations depend only on the means (\(\bar{t}_{i}\)) of the different distributions, and not the distributions or even the higher moments. Thus, even two exponential servers regulated this way will produce a non-renewal process.

##### 8.3.2.3 Markov Modulated Poisson Process (MMPP)

The most widely used SMPs are MMPPs. In particular, they have been used to model voice traffic, and recently, all telecommunications traffic (see, for instance, [Meier-Fischer92] and [Park-Will00]). In the previous section we defined the MRDP, where a "token" wanders from one server to another, spends a time \(T_{j}\) at \(S_{j}\) with distribution generated by \(\mathbf{\langle}\,\mathbf{p}_{\!\!\!j},\,\mathbf{B }_{\!\!\!j}\,\mathbf{\rangle}\), at which time one customer departs the system, and the token moves to another server according to the matrix \(P\) (8.3.5c). In this section the token still wanders from \(S_{i}\) to \(S_{j}\), but now customers depart continuously at a Poisson rate of \(\lambda_{j}\) while the token is at \(S_{j}\). That is, the time between departures is exponentially distributed, with mean \(1/\lambda_{j}\), and on average, \(\lambda_{j}\mathbf{\mathbb{E}}[T_{j}]\) customers leave while the token is at \(j\). Thus the token _modulates the rate_ at which customers depart by moving from one station to another.

Most applications of MMPPs assume that each \(T_{j}\) is exponentially distributed. But here we assume that they are as described in Section 8.3.2.1 and have nonexponential distributions. Therefore, the token's behavior is governed by the \(Q\) of (8.3.3d). When viewed as an \(M\)-dimensional system, the

<!-- Pages 487-487 -->

time the token spends at \(S_{i}\) is indeed nonexponential. But if one looks at \(\boldsymbol{\mathcal{Q}}\) as an \(M_{m}\)-dimensional system, where each phase is thought of as a server, then the structure is again that of exponential servers. From a modeling point of view (that's what is important) we have a generalization of MMPPs. But from a purely mathematical view, this is still an MMPP (and a restricted one at that).

From its description, \(\boldsymbol{\mathcal{L}}\) is easy to write down, being:

\[\boldsymbol{\mathcal{L}}=\boldsymbol{\mathcal{L}}_{\mathrm{o}}:=\left[ \begin{array}{cccc}\lambda_{1}\mathbf{I}_{1}&\mathbf{O}&\cdots&\mathbf{O}\\ \mathbf{O}&\lambda_{2}\mathbf{I}_{2}&\cdots&\mathbf{O}\\ \cdots&\cdots&\cdots&\cdots\\ \mathbf{O}&\mathbf{O}&\cdots&\lambda_{M}\mathbf{I}_{M}\end{array}\right].\] (8.3.10a) Note that adding a term of the form \[\lambda_{b}\boldsymbol{\mathcal{I}}\] to \[\boldsymbol{\mathcal{L}}\], doesn't change its structure and doesn't change \[\boldsymbol{\mathcal{Q}}\] either. But this can then be interpreted either as increasing the rate at each server, or as an MMPP with a background (or merged with a) Poisson process of rate \[\lambda_{b}\]. We also have occasion to use the \[M\] -dimensional matrix \[\boldsymbol{L}_{\mathrm{o}}:=\mathrm{Diag}[\lambda_{1},\,\lambda_{2},\,\ldots, \,\lambda_{M}]\].

We have another notational point to make. The matrices, \(\boldsymbol{\mathcal{B}}\), \(\boldsymbol{\mathcal{V}}\), \(\boldsymbol{\mathcal{L}}\), and \(\boldsymbol{\mathcal{Q}}\) have the same physical meaning from application to application, but they may have completely different structures. On the other hand, the matrices with subscript "o" (e.g., \(\boldsymbol{\mathcal{L}}_{\mathrm{o}}\)) are always block diagonal matrices, and may have no physical meaning in any particular application. For a summary of useful matrices, see Table 8.3.1 below.

In discussing overloaded servers in Section 8.3.1, we easily set up \(\boldsymbol{\mathcal{B}}\) and \(\boldsymbol{\mathcal{L}}\), and thereby were able to get \(\boldsymbol{\mathcal{Q}}\). In Section 8.3.2.2, for MRDPs we first set up \(\boldsymbol{\mathcal{B}}\) and \(\boldsymbol{\mathcal{Q}}\), from which \(\boldsymbol{\mathcal{L}}\) followed. Here we have set up \(\boldsymbol{\mathcal{Q}}\) and \(\boldsymbol{\mathcal{L}}\) for the MMPP and now have

\[\boldsymbol{\mathcal{B}}=\boldsymbol{\mathcal{L}}+\boldsymbol{\mathcal{Q}}= \boldsymbol{\mathcal{L}}_{\mathrm{o}}+\boldsymbol{\mathcal{B}}_{\mathrm{o}}- \boldsymbol{\mathcal{B}}_{\mathrm{o}}\big{\langle}\boldsymbol{P}\big{\rangle}, \tag{8.3.10b}\]

where \(\boldsymbol{\mathcal{Q}}\) is from (8.3.3d) and \(\boldsymbol{\mathcal{B}}_{\mathrm{o}}\) is from (8.3.3a).

The inverse of \(\boldsymbol{\mathcal{B}}\) can be found using a technique similar to that used in Lemma 4.2.1. We present the result here, and those who wish to know more about the algebra of \(\boldsymbol{\mathcal{C}}\) embeddings are referred to Section 9.3. First manipulate (8.3.10b), recalling that both \(\boldsymbol{\mathcal{V}}_{\mathrm{o}}\) and \(\boldsymbol{\mathcal{L}}_{\mathrm{o}}\) are block diagonal and commute with each other, but not with \(\big{\langle}\boldsymbol{P}\big{\rangle}\). That is, \(\boldsymbol{\mathcal{L}}_{\mathrm{o}}\boldsymbol{\mathcal{V}}_{\mathrm{o}}= \boldsymbol{\mathcal{V}}_{\mathrm{o}}\boldsymbol{\mathcal{L}}_{\mathrm{o}}\) but \(\boldsymbol{\mathcal{L}}_{\mathrm{o}}\big{\langle}\boldsymbol{P}\big{\rangle} \neq\big{\langle}\boldsymbol{P}\big{\rangle}\boldsymbol{\mathcal{L}}_{ \mathrm{o}}\). We get

\[\boldsymbol{\mathcal{V}}=\boldsymbol{\mathcal{B}}^{-1}=\left[\boldsymbol{ \mathcal{I}}-\boldsymbol{\mathcal{D}}_{\mathrm{o}}\big{\langle}\boldsymbol{P} \big{\rangle}\right]^{-1}\boldsymbol{\mathcal{V}}_{\mathrm{o}}\boldsymbol{ \mathcal{D}}_{\mathrm{o}}, \tag{8.3.10c}\]

where

\[\boldsymbol{\mathcal{D}}_{\mathrm{o}}:=[\boldsymbol{\mathcal{I}}+\boldsymbol{ \mathcal{L}}_{\mathrm{o}}\boldsymbol{\mathcal{V}}_{\mathrm{o}}]^{-1}=\mathrm{ Diag}[\mathbf{D}_{\mathbf{1}},\;\mathbf{D}_{\mathbf{2}},\;\ldots,\;\mathbf{D}_{ \mathbf{M}}]\]

with \(\mathbf{D}_{\mathbf{i}}=[\mathbf{I}_{\mathbf{i}}+\lambda_{i}\mathbf{V}_{ \mathbf{i}}]^{-1}\). Furthermore,

\[\boldsymbol{\mathcal{D}}_{\mathrm{o}}:=\mathrm{Diag}[d_{1},\;d_{2},\;\ldots,\;d _{M}],\quad\text{where}\;\;d_{i}=\mathbf{p}_{\mathbf{i}}\,\mathbf{D}_{ \mathbf{i}}\,\boldsymbol{\epsilon}_{\mathbf{i}}^{\prime}.\]

<!-- Pages 488-488 -->

We next make use of the special properties of to take the inverse of an matrix by embedding the inverse of an matrix:

and put this into (8.3.10c) to get

(8.3.10d)

As was shown in Theorem 3.1.1, the Laplace transform of the distribution generated by and can be interpreted as the probability that the token will leave before any customers depart. We take a closer look at this in the next section.

The matrix comes easily:

(8.3.10e)

It is useful at times to use the identity, while noting that the three matrices commute with each other.

There are three advantages of using this notation. First, the internal structure of the matrices is more explicit (once one gets used to the notation). Second, the inverses of matrices are found by inverting matrices of smaller dimension. Third, one can go further by analytic manipulation rather than having to resort to numerical computation. The manipulations can occur without having to resort to a particular distribution representation; that is, the expressions are valid for all distributions.

We next find the steady-state mean interdeparture time. First we find and. We have actually done most of the work already. The of this section is the same as that in the previous section, therefore so is, as given in (8.3.6b). First multiply by [remembering that for MMPP, from (8.3.10a)]

(8.3.11a)

The steady-state vector comes directly from (8.2.8e) and satisfies.

(8.3.11b)

We can now find. But wait; from (8.2.8c) and (8.3.11a) we already know what it is, namely:

(8.3.11c)

<!-- Pages 489-489 -->

This has a straightforward physical interpretation. The numerator is the average time spent by the token per visit to some \(S_{i}\), averaged over all servers. The term \(\bar{t}_{i}\lambda_{i}=(\boldsymbol{V_{\!o}L_{\!o}})_{ii}\) is the average number of departures while the token is at \(S_{i}\). Thus the denominator is the average number of departures per token visit, averaged over all visits.

Keep in mind that (8.3.11c) is only valid for steady-state epochs. If the system is in some vector state, say \(\boldsymbol{\wp}_{\mathrm{o}}\), or \(\boldsymbol{\wp}_{\mathbf{n}}=\boldsymbol{\wp}_{\mathrm{o}}\boldsymbol{\mathcal{Y}}\) (the \(n\)th customer has just departed), then one must compute

\[\boldsymbol{\mathbb{E}}[X_{n+1}]=\boldsymbol{\wp}_{\mathbf{n}}\boldsymbol{ \mathcal{V}}\boldsymbol{\varepsilon}^{\prime}\]

using (8.3.10c). This takes some skill and practice to do analytically (see Section 9.3). However, all the moments, and even autocorrelation coefficients are easy to compute.

In the rest of this subsection we look at applying MMPP's to problems in telecommunications. We show how to use physical arguments to make mathematical changes to the model.

#### 8.3.2.4 Augmented MMPP's (AMMPP)

There is one problem with this model, particularly for the _ON-OFF processes_ we will be discussing later. As was mentioned in the discussion following (8.3.10c), \(d_{i}\) is the probability that the token will leave \(S_{i}\) without any packets departing (customers are now called _packets_, or _cells_). That is, sometimes a token's visit to \(S_{i}\) will result in no sent packets. If the mean number of packets per visit is large, then \(d_{i}\) will be small and nothing need be done. But if that is not the case, then some modifications must be made. After all, by definition each _ON_ interval must have at least one packet. After all, it represents actual transmission, not merely permission to transmit.

Thus we introduce the _Augmented MMPP_ (AMMPP). The token wanders through the system as usual. While it is at \(S_{i}\), customers depart at rate \(\lambda_{i}\). But when the token leaves \(S_{i}\), another customer leaves. Thus, \(\boldsymbol{\mathcal{Q}}\) is the same as in the two previous sections, but \(\boldsymbol{\mathcal{L}}\) is the sum of the MRDP and MMPP \(\boldsymbol{\mathcal{L}}\)s. (note that the resulting AMMPP is not an MMPP. That is [from (8.3.3d)]:

\[\boldsymbol{\mathcal{Q}}=\boldsymbol{\mathcal{B}}_{\mathrm{o}}-\boldsymbol{ \mathcal{B}}_{\mathrm{o}}\big{\langle}\,\mathbf{P}\,\big{\rangle}\] (8.3.12a) and [adding (8.3.5b) to (8.3.10a)] \[\boldsymbol{\mathcal{L}}=\boldsymbol{\mathcal{L}}_{\mathrm{o}}+\boldsymbol{ \mathcal{B}}_{\mathrm{o}}\big{\langle}\,\mathbf{P}\,\big{\rangle}. \tag{8.3.12b}\]

Then

\

<!-- Pages 491-491 -->

_OFF time_). This has been called a _one-burst process_. If the times between packets during an \(ON\) time are exponentially distributed (the usual assumption) the system is also called an _Interrupted Poisson Process_ (IPP) (see, e.g., [11, 12]). When one analyzes the superposition of several voice streams, it is difficult to tell where the _ON_ and _OFF_ periods are, but the burstiness remains. Still, satisfactory MMPP models were constructed where several servers, corresponding to 1, 2,..., \(n\) simultaneous voice streams were included. In this case, \(\lambda_{n}=n\lambda_{1}\). Reasonable \(P\) matrices were constructed to reflect the probability that a new voice stream will join in, or a present one will stop. We might call these _ON-OFF MMPP_'s (OOMMPP).

As data transmission became more common the MMPP models were found to be less and less useful. Further examination of data streams showed that there was _long-range autocorrelation_[10]. That is, \(\hat{r}(k)\) [see (8.2.12c)] remains measurable for very large \(k\). This could not be modeled by the then-existing models. But further measurements of data revealed that the size of transmitted files is power-tailed for many orders of magnitude; see Hatem [13], Lipsky [14], and Crovella [10]. See Section 3.3 for a full discussion, including the TPTs. When files are to be transmitted they are first broken up into packets. The packets are then sent in a smooth (Poisson?) manner, for a period of time which is PT. That is, the _ON_ times must be power-tail distributed. The model presented in Section 8.3.2.3 is adequate, even reproducing the long-range autocorrelation, if a good representation of PT distributions is used. Strictly speaking, PT functions require infinite representations, but in Section 3.3.6.2 we present a truncated variety that has been shown to be more than adequate (see Schwefel [15]).

Perhaps the best way to become familiar with all the above matrices is by an example. Let us consider a simple _ON-OFF_ model. It shows that previously unknown properties can be discovered without actually having to specify the PDFs of the \(S_{i}\)s. In fact, we come up with some interesting results.

**Example 8.3.2:** Consider a system with two servers \(S_{1}\) and \(S_{2}\), with distributions represented by \(\{\textbf{p}_{1},\,\textbf{B}_{1}\}\) and \(\{\textbf{p}_{2},\,\textbf{B}_{2}\}\), respectively. While the token is at \(S_{1}\) a data source sends a _burst of packets_ at a _peak_ rate of \(\lambda_{p}\) for a time \(T_{1}\). When the burst is over, the token goes to \(S_{2}\) for a time \(T_{2}\), during which time no packets are sent (\(\lambda_{2}=0\)). The token then returns to \(S_{1}\), repeating the process indefinitely. The matrices describing the system are:

\[\textbf{P} =\left[\begin{array}{cc}0&1\\ 1&0\end{array}\right], \textbf{\quad\quad}\textbf{\langle}\textbf{P}\textbf{\rangle} =\left[\begin{array}{cc}\textbf{0}_{1}&\textbf{\ell}_{1}^{\prime}\,\textbf{ p}_{2}\\ \textbf{\ell}_{2}^{\prime}\,\textbf{p}_{1}&\textbf{0}_{2}\end{array}\right],\] \[\textbf{p} =\left[\frac{1}{2},\,\frac{1}{2}\right], \textbf{\quad\quad\quad}\textbf{\varepsilon}^{\prime} =\left[\begin{array}{c}\textbf{\ell}_{1}^{\prime}\\ \textbf{\ell}_{2}^{\prime}\end{array}\right]=\textbf{\|}\textbf{\epsilon}^{ \prime}\textbf{\rangle},\]

and (using \(\textbf{\mathcal{D}}_{\rm o}=[\overline{\textbf{I}}+\boldsymbol{\mathcal{L}}_ {\rm o}\boldsymbol{\mathcal{V}}_{\rm o}]^{-1}\) with \(\textbf{D}_{1}=[\mathbf{I}+\lambda_{p}\mathbf{V}_{1}]^{-1}\))

\[\boldsymbol{\mathcal{L}}_{\rm o}=\left[\begin{array}{cc}\lambda_{p} \textbf{I}_{1}&\textbf{0}\\ \textbf{0}&\textbf{0}\end{array}\right], \textbf{\quad\quad}\textbf{\mathcal{B}}_{\rm o}=\left[\begin{array}{ cc}\textbf{B}_{1}&\textbf{0}\\ \textbf{0}&\textbf{B}_{2}\end{array}\right],\]

<!-- Pages 492-492 -->

\[\boldsymbol{\mathcal{V}}_{\mathrm{o}}=\left[\begin{array}{cc}\mathbf{V_{1}}& \mathbf{0}\\ \mathbf{0}&\mathbf{V_{2}}\end{array}\right],\hskip 14.226378pt\boldsymbol{ \mathcal{D}}_{\mathrm{o}}=\left[\begin{array}{cc}\mathbf{D_{1}}&\mathbf{0} \\ \mathbf{0}&\mathbf{I_{2}}\end{array}\right].\]

The matrices governing the 2-server MMPP _ON-OFF process_ follow.

\[\boldsymbol{\mathcal{L}}=\boldsymbol{\mathcal{L}}_{\mathrm{o}},\hskip 14.226378pt \boldsymbol{\mathcal{Q}}=\left[\begin{array}{cc}\mathbf{B_{1}}&-\mathbf{B_{ 1}}\boldsymbol{\epsilon_{1}^{\prime}}\mathbf{p}_{2}\\ -\mathbf{B_{2}}\boldsymbol{\epsilon_{2}^{\prime}}\mathbf{p}_{1}&\mathbf{B_{2} }\end{array}\right],\]

\[\boldsymbol{\mathcal{B}}=\left[\begin{array}{cc}\mathbf{B_{1}}+\lambda_{p} \mathbf{I_{1}}&-\mathbf{B_{1}}\boldsymbol{\epsilon_{1}^{\prime}}\mathbf{p}_{2 }\\ -\mathbf{B_{2}}\boldsymbol{\epsilon_{2}^{\prime}}\mathbf{p}_{1}&\mathbf{B_{2} }\end{array}\right],\]

(using \(d:=\mathbf{p}_{1}\mathbf{D_{1}}\boldsymbol{\epsilon_{1}^{\prime}}\))

\[\boldsymbol{\mathcal{V}}=\left[\begin{array}{cc}\mathbf{V_{1}}\mathbf{D_{1}} +\frac{1}{1-d}\mathbf{D_{1}}\boldsymbol{\epsilon_{1}^{\prime}}\mathbf{p}_{1} \mathbf{V_{1}}\mathbf{D_{1}}&\frac{1}{1-d}\mathbf{D_{1}}\boldsymbol{\epsilon_ {1}^{\prime}}\mathbf{p}_{2}\mathbf{V_{2}}\\ \frac{1}{1-d}\boldsymbol{\epsilon_{2}^{\prime}}\mathbf{p}_{1}\mathbf{V_{1}} \mathbf{D_{1}}&\mathbf{V_{2}}+\frac{d}{1-d}\boldsymbol{\epsilon_{2}^{\prime} }\mathbf{p}_{2}\mathbf{V_{2}}\end{array}\right],\]

\[\boldsymbol{\mathcal{P}}=\frac{1}{\bar{t}_{1}}[\mathbf{p_{1}}\mathbf{V_{1}}, \,\mathbf{o}],\hskip 14.226378pt\boldsymbol{\mathcal{Y}}=\lambda_{p}\left[ \begin{array}{cc}\mathbf{V_{1}}\mathbf{D_{1}}+\frac{1}{1-d}\mathbf{D_{1}} \boldsymbol{\epsilon_{1}^{\prime}}\mathbf{p}_{1}\mathbf{V_{1}}\mathbf{D_{1}}& \mathbf{0}\\ \frac{1}{1-d}\boldsymbol{\epsilon_{2}^{\prime}}\mathbf{p}_{1}\mathbf{V_{1}} \mathbf{D_{1}}&\mathbf{0}\end{array}\right].\]

\[\boldsymbol{\pi}=\frac{1}{\boldsymbol{p}\boldsymbol{V_{\mathrm{o}}}\boldsymbol {e^{\prime}}}\big{\langle}\boldsymbol{p}\big{|}\,\boldsymbol{\mathcal{V}}_{ \mathrm{o}}=\frac{1}{\bar{t}_{1}+\bar{t}_{2}}[\mathbf{p_{1}}\mathbf{V_{1}},\, \mathbf{p_{2}}\mathbf{V_{2}}],\]

\[\boldsymbol{\mathcal{P}}\boldsymbol{\mathcal{V}}=\frac{1}{\boldsymbol{p} \boldsymbol{V_{\mathrm{o}}}\boldsymbol{e^{\prime}}}\big{\langle}\boldsymbol{ p}\big{|}\,\boldsymbol{\mathcal{V}}_{\mathrm{o}}=\frac{1}{\lambda_{p}\bar{t}_{1}}[ \mathbf{p_{1}}\mathbf{V_{1}},\,\mathbf{p_{2}}\mathbf{V_{2}}].\]

We now find the mean and variance of the interdeparture times. The mean is simple enough to evaluate. It is

\[\boldsymbol{\mathbb{E}}[X]=\boldsymbol{\mathcal{P}}\boldsymbol{\mathcal{V}} \boldsymbol{\mathcal{E}^{\prime}}=\frac{\bar{t}_{1}+\bar{t}_{2}}{\bar{n}_{p}},\] (8.3.13a) where \[\bar{n}_{p}:=\lambda_{p}\bar{t}_{1}\] is the mean number of packets per cycle and the numerator is the total time for one cycle. Considered as a flow of packets, the mean flow rate \[\kappa\] [see 8.2.8d] is [the same as \[1/(\boldsymbol{\mathcal{P}}\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{E}^{ \prime}})\] ]: \[\kappa:=\boldsymbol{\pi}\boldsymbol{\mathcal{L}}\boldsymbol{\mathcal{E}^{ \prime}}=\left[\frac{\bar{t}_{1}}{\bar{t}_{1}+\bar{t}_{2}}\right]\lambda_{p}.\] In many applications it is possible to change \[\lambda_{p}\], by for instance, increasing the transmission speed of data. At that moment, the amount of data to be sent is fixed, therefore \[\bar{t}_{1}\] decreases in such a way that \[\bar{n}_{p}\] remains constant. Therefore, at least for _ON-OFF_ models, it is appropriate to replace \[\lambda_{p}\bar{t}_{1}\] by \[\bar{n}_{p}\]. The typical picture is of data being prepared for transmission and then sent to the transmitter. In this scenario, even if the data are transmitted more rapidly, the next batch of data won't be ready for transmission until one full cycle later. In other words \[\bar{t}_{1}+\bar{t}_{2}\], like \[\bar{n}_{p}\], is constant. In such cases the _burst parameter, b_, can be a useful variable for describing the performance of the application.

\[b:=\frac{\bar{t}_{2}}{\bar{t}_{1}+\bar{t}_{2}}=1-\frac{\kappa}{\lambda_{p}}. \tag{8.3.13b}\]

<!-- Pages 494-494 -->

\(\bar{n}_{p}\) is assumed to be the same irrespective of the peak rate; consequently we see that \(\mathbf{D_{1}}\) is also independent of \(\lambda_{p}\).

We now go one step further. In Section 4.4.1 we found a relationship between the _exponential moments_\(\alpha_{k}(s)\) and the matrices, \(\mathbf{D}^{k}\). From (4.4.1a) we have

\[\alpha_{k}(s)=\int_{\mathrm{o}}^{\infty}\frac{(sx)^{k}}{k!}e^{-sx}\,b(x)\,dx= \Psi[(\mathbf{I}-\mathbf{D})^{k}\mathbf{D}]=\Psi[(s\mathbf{V}\mathbf{D})^{k} \mathbf{D}].\]

If we identify \(s\) with \(\lambda_{p}\) and \(\mathbf{D}(s)\) with \(\mathbf{D_{1

<!-- Pages 495-495 -->

and \(\boldsymbol{\wp}=[1,\,0,\,\ldots,\,0]\).

**Proof:** The formulas of Example 8.3.2 apply here with the following substitutions: \(\mathbf{I_{1}}\to 1\), \(\mathbf{B_{1}}\to\mu_{1}:=1/\bar{t}_{1}\), \(\mathbf{V_{1}}\to\bar{t}_{1}\), \(\mathbf{p}_{1}\to 1\)\(\mathbf{D_{1}}\to 1/(1+\bar{n}_{p})\), and \(\boldsymbol{\epsilon^{\prime}_{1}}\to 1\). Then

\[\boldsymbol{\mathcal{L}}\Longrightarrow\lambda_{p}\left[\begin{array}{cc}1& \mathbf{o}\\ \mathbf{o}^{\prime}&\mathbf{0}\end{array}\right]=\lambda_{p}\left[\begin{array} []{c}1\\ \mathbf{o}^{\prime}\end{array}\right]\boldsymbol{\wp};\]

that is, \([\boldsymbol{\mathcal{L}}]_{11}=1\) and all other elements are \(0\). Also,

\[\boldsymbol{\mathcal{Y}}\Longrightarrow\left[\begin{array}{cc}1&\mathbf{o} \\ \boldsymbol{\epsilon^{\prime}_{2}}&\mathbf{0}\end{array}\right]=\boldsymbol{ \varepsilon^{\prime}}\boldsymbol{\wp}.\]

This makes \(\boldsymbol{\mathcal{L}}\) and \(\boldsymbol{\mathcal{Y}}\) rank-1 matrices. Therefore by Theorem 8.2.1 the process is a renewal process. Each departure epoch (time between departures) can be described in the following way. The customer starts in \(S_{1}\). Because it is exponential no \(\mathbf{p}_{1}\) vector is necessary. Then, after mean time \(\bar{t}_{1}\) he either departs [with probability \(\bar{n}_{p}/(1+\bar{n}_{p})\)] or goes to \(S_{2}\). After a mean time of \(\bar{t}_{2}=\mathbf{p}_{2}\mathbf{V_{2}}\boldsymbol{\epsilon^{\prime}_{2}}\), he returns to \(S_{1}\). The cycle continues until he finally departs. Each new customer begins at the exponential server, so the interdeparture times are iid. **QED**

The second interesting result concerns autocovariance and autocorrelation, and is given in the following.

**Theorem 8.3.2:** The \(\mathrm{Cov}(X,\,X_{+k})\)s are independent of the _OFF-time_ distribution. Also, \(\hat{r}(k)\) varies inversely with \(\sigma^{2}_{OFF}\) but no other moments.

**Proof:** The autocovariance lag-\(k\) is given by (8.2.12b), but first we look at (8.2.12a). From the previous example we see that \(\boldsymbol{\mathcal{Y}}\) is of the form

\[\boldsymbol{\mathcal{Y}}=\left[\begin{array}{cc}\mathbf{A}&\mathbf{0}\\ \mathbf{B}&\mathbf{0}\end{array}\right].\]

Direct multiplication shows that

\[\boldsymbol{\mathcal{Y}}^{k}=\left[\begin{array}{cc}\mathbf{A}^{k}&\mathbf{ 0}\\ \mathbf{B}\,\mathbf{A}^{k-1}&\mathbf{0}\end{array}\right]=\left[\begin{array}[] {cc}\mathbf{A}&\mathbf{0}\\ \mathbf{B}&\mathbf{0}\end{array}\right]\left[\begin{array}{cc}\mathbf{A}^{k -1}&\mathbf{0}\\ \mathbf{0}&\mathbf{0}\end{array}\right]\]

and \(\boldsymbol{\wp}\boldsymbol{\mathcal{Y}}\boldsymbol{\mathcal{Y}}\) is of the form \(\mathbf{[a_{1},\,o]}\). Thus, from (8.2.12a), \(\mathbf{E}[X,\,X_{+k}]\) is of the form

\[[\boldsymbol{\wp}\boldsymbol{\mathcal{Y}}]\boldsymbol{\mathcal{Y}}^{k-1}\,[ \boldsymbol{\mathcal{V}}\boldsymbol{\varepsilon^{\prime}}]=\mathbf{[a_{1},\,o] }\left[\begin{array}{cc}\mathbf{A}^{k-1}&\mathbf{0}\\ \mathbf{0}&\mathbf{0}\end{array}\right]\left[\begin{array}{c}\mathbf{c}_{1 }^{\prime}\\ \mathbf{d}_{2}^{\prime}\end{array}\right]=\mathbf{a_{1}}\,\mathbf{A}^{k-1} \mathbf{c}_{1}^{\prime},\]

where

\[\mathbf{a_{1}}=\frac{1}{\lambda_{p}\bar{t}_{1}}\left[\mathbf{p_{1}}\mathbf{V_ {1}}+\frac{\bar{t}_{2}}{1\!-\!d}\mathbf{p_{1}}(\mathbf{I_{1}}\!-\!\mathbf{D_{1} })\right],\]

\[\mathbf{A}=\lambda_{p}\left[\mathbf{V_{1}}\mathbf{D_{1}}+\frac{1}{1\!-\!d} \mathbf{D_{1}}\boldsymbol{\epsilon^{\prime}_{1}}\mathbf{p_{1}}\mathbf{V_{1}} \mathbf{D_{1}}\right],\]

<!-- Pages 497-497 -->

Well, it could have turned out messier. It does display the properties we established previously. For instance, if \(b\to 0\) then \(\hat{r}(1)=0\), as should be the case for all \(\hat{r}(k)\), because in that limit the process becomes a Poisson process. Furthermore, it depends on \(S_{2}\) only through \(C_{2}^{2}\) and decreases with increasing variance. In addition, it only depends on the probabilities of having \(0\) or \(1\) packet in the \(ON\) period.

Last, for exponential _ON_ times,

\[\alpha_{k}(\bar{n}_{p})=\left[\frac{\bar{n}_{p}}{\bar{n}_{p}+1}\right]^{k} \frac{1}{\bar{n}_{p}+1}.\]

As would be expected, geometric distribution of packets per burst yields exponential _ON_ times, and it is independent of \(\lambda_{p}\) and \(\bar{t}_{1}\). It also follows that \(\hat{r}(1)=0\), consistent with Theorem 8.3.1. \(\blacktriangle\)

**MRP's with Background Poisson Traffic Added**

We now return to the question of what happens when there is background Poisson traffic. Here, for any MRP, whatever phase the token is in, the background source produces at the rate \(\lambda_{b}\). The \(\boldsymbol{\mathcal{Q}}\) matrix doesn't change, and \(\boldsymbol{\mathcal{L}}\) is modified to:

\[\boldsymbol{\mathcal{L}}_{\mathbf{b}}=\boldsymbol{\mathcal{L}}+\lambda_{b} \boldsymbol{\mathcal{I}}\]

and \(\boldsymbol{\mathcal{B}}\) is modified to

\[\boldsymbol{\mathcal{B}}_{\mathbf{b}}=\boldsymbol{\mathcal{Q}}+\boldsymbol{ \mathcal{L}}_{\mathbf{b}}=\boldsymbol{\mathcal{B}}+\lambda_{b}\boldsymbol{ \mathcal{I}}.\]

We look at the special case of merging renewal processes in Section 8.3.3. If one of them is Poisson, then that is equivalent to what we have here. But right now we are interested in what happens to an _ON-OFF_ process. If the term \(\lambda_{b}\boldsymbol{\mathcal{I}}\) is added to \(\boldsymbol{\mathcal{L}}\) in Example 8.3.2, then the result is a process that looks exactly like any \(2\)-server MMPP. This leads us to the following theorem.

**Theorem 8.3.3:** Every MMPP is equivalent to some _ON-OFF_ MMPP with background Poisson traffic. \(\blacksquare\)

**Proof:** Consider any MMPP with \(\boldsymbol{\mathcal{Q}}\), \(\boldsymbol{\mathcal{L}}\), and \(\boldsymbol{\mathcal{B}}\) given. Because the process is MMPP,

\[\boldsymbol{\mathcal{L}}=\mathrm{Diag}[\lambda_{1}\mathbf{I_{1}},\,\lambda_{2 }\mathbf{I_{2}},\,\cdots,\,\lambda_{M}\mathbf{I_{M}}].\]

Define \(\lambda_{b}\) as the smallest \(\lambda\)s. That is

\[\lambda_{b}:=\mathrm{Min}\{\lambda_{i}|1\leq i\leq M\}.\]

We now construct an _ON-OFF_ process (using subscript "**oo**") as follows. Let

\[\boldsymbol{\mathcal{L}}_{\mathbf{oo}}=\boldsymbol{\mathcal{L}}-\lambda_{b} \boldsymbol{\mathcal{I}},\quad\quad\boldsymbol{\mathcal{Q}}_{\mathbf{oo}}= \boldsymbol{\mathcal{Q}},\quad\text{and}\quad\boldsymbol{\mathcal{B}}_{ \mathbf{oo}}=\boldsymbol{\mathcal{B}}-\lambda_{b}\boldsymbol{\mathcal{I}}.\]

Then \(\{\boldsymbol{\mathcal{L}}_{\mathbf{oo}},\,\boldsymbol{\mathcal{B}}_{\mathbf{oo }},\,\boldsymbol{\mathcal{Q}}_{\mathbf{oo}}\}\) is an _ON-OFF_ process. After all, while the token is visiting the server corresponding to \(\lambda_{b}\) no packets are leaving; that is, it's _OFF_. We can now reverse the process by adding \(\lambda_{b}\boldsymbol{\mathcal{I}}\) to the _ON-OFF_ process and end up with the original MMPP. **QED**

<!-- Pages 498-498 -->

One might ask if this is true in general. The answer is "No." It is true for MMPP's because of the particular structure of \(\boldsymbol{\mathcal{L}}\), but each process must be examined individually. We show this in what follows.

##### Modified Augmented ON-OFF MMPP Model (MAOOMMPP)

We next examine the augmented MMPP that is also an _ON-OFF_ process (MAOOMMPP). This process forces the _ON_ server to yield at least one packet per token visit. But it cannot be a special case of the AMMPP model presented in Section 8.3.2.4. There, every token visit to every server produced at least one packet. This must not be allowed to happen at the _OFF_ server. The way we augmented the MMPP model was to add \(\boldsymbol{\mathcal{B}}_{\mathrm{o}}\big{\langle}\boldsymbol{P}\big{\rangle}\) to \(\boldsymbol{\mathcal{L}}\). A particular term in that matrix is \(\mathbf{B}_{\mathbf{i}}\boldsymbol{\epsilon}_{\mathbf{i}}^{\prime}P_{i}p_{ \mathbf{j}}\), or \(\mathbf{M}_{\mathbf{i}}\,\mathbf{q}_{i}^{\prime}P_{i}p_{\mathbf{j}}\). Its interpretation is as follows. Start with the token finishing in phase \(k\) of server \(S_{i}\) [\((\mathbf{M}_{\mathbf{i}})_{kk}\)], leaving \(S_{i}\) [\((\mathbf{q}_{\mathbf{i}})_{k}\)], going to \(S_{j}\) [\((\boldsymbol{P})_{ij}\)], and finally going to phase \(\ell\) in \(S_{j}\) [\((\boldsymbol{p}_{j})_{\ell}\)]. Because this is a term in the \(\boldsymbol{\mathcal{L}}\) matrix, it causes a customer to depart. If \(S_{i}\) is the _OFF_ server, then this shouldn't happen. Therefore we _modify_ the augmented model by setting that corresponding row (now call it \(\ell\)) to \(\mathbf{0}\). That is, the matrix block \(\boldsymbol{\mathcal{B}}_{\mathbf{\ell}\mathbf{j}}=\boldsymbol{\mathcal{O}}\). This can be done formally by defining \(\boldsymbol{\mathcal{I}}_{\mathbf{oo}}\) as

\[\boldsymbol{\mathcal{I}}_{\mathbf{oo}}:=\mathrm{Diag}[\mathbf{I}_{\mathbf{1}}, \,\ldots,\,\mathbf{I}_{\ell-1},\,\mathbf{0},\,\mathbf{I}_{\ell+1},\,\cdots,\, \mathbf{I}_{\mathbf{M}}].\]

Then the _Modified Augmented ON-OFF MMPP_ (MAOOMMPP) model is:

\[\boldsymbol{\mathcal{Q}} = \boldsymbol{\mathcal{B}}_{\mathrm{o}}-\boldsymbol{\mathcal{B}}_{ \mathrm{o}}\big{\langle}\boldsymbol{P}\big{\rangle};\] \[\boldsymbol{\mathcal{L}} = \boldsymbol{\mathcal{L}}_{\mathrm{o}}+\boldsymbol{\mathcal{B}}_{ \mathrm{o}}\boldsymbol{\mathcal{I}}_{\mathrm{oo}}\big{\langle}\boldsymbol{P} \big{\rangle}; \tag{8.3.15}\] \[\boldsymbol{\mathcal{B}} = \boldsymbol{\mathcal{B}}_{\mathrm{o}}+\boldsymbol{\mathcal{L}}_{ \mathrm{o}}-\boldsymbol{\mathcal{B}}_{\mathrm{o}}(\boldsymbol{\mathcal{I}}_{ \mathrm{o}}-\boldsymbol{\mathcal{I}}_{\mathrm{oo}})\big{\langle}\boldsymbol{P} \big{\rangle}.\]

Compare with the comparable entries in Table 8.3.1. We now explore the two-server system in the following example.

**Example 8.3.4:** Consider a system as in Example 8.3.2, but now the _ON_ time must have at least one packet, and the _OFF_ time must have none. Assume that when the token leaves the _ON_ server he emits a packet, giving the MAOOMMPP. Let \(M=2\), then (8.3.15) becomes

\[\boldsymbol{\mathcal{L}}=\left[\begin{array}{cc}\lambda_{p}\mathbf{I}_{ \mathbf{1}}&\mathbf{B}_{\mathbf{1}}\boldsymbol{\epsilon}_{\mathbf{1}}^{ \prime}\mathbf{p}_{2}\\ \mathbf{0}&\mathbf{0}\end{array}\right],\hskip 14.226378pt\boldsymbol{ \mathcal{B}}=\left[\begin{array}{cc}\mathbf{B}_{\mathbf{1}}+\lambda_{p} \mathbf{I}_{\mathbf{1}}&\mathbf{0}\\ -\mathbf{B}_{\mathbf{2}}\boldsymbol{\epsilon}_{\mathbf{2}}^{\prime}\mathbf{p}_{ 1}&\mathbf{B}_{\mathbf{2}}\end{array}\right],\]

\[\boldsymbol{\mathcal{Q}}=\left[\begin{array}{cc}\mathbf{B}_{\mathbf{1}}&- \mathbf{B}_{\mathbf{1}}\boldsymbol{\epsilon}_{\mathbf{1}}^{\prime}\mathbf{p}_ {2}\\ -\mathbf{B}_{\mathbf{2}}\boldsymbol{\epsilon}_{\mathbf{2}}^{\prime}\mathbf{p}_{ 1}&\mathbf{B}_{\mathbf{2}}\end{array}\right].\]

It is straightforward to set up \(\boldsymbol{\mathcal{V}}\) and \(\boldsymbol{\mathcal{Y}}\).

\[\boldsymbol{\mathcal{V}}=\left[\begin{array}{cc}\mathbf{V}_{\mathbf{1}}\, \mathbf{D}_{\mathbf{1}}&\mathbf{0}\\ \boldsymbol{\epsilon}_{\mathbf{2}}^{\prime}\mathbf{p}_{\mathbf{1}}\mathbf{V}_{ \mathbf{1}}\mathbf{D}_{\mathbf{1}}&\mathbf{V}_{\mathbf{2}}\end{array}\right] \quad\text{and}\quad\boldsymbol{\mathcal{Y}}=\left[\begin{array}{cc}\mathbf{ I}_{\mathbf{1}}-\mathbf{D}_{\mathbf{1}}&\mathbf{D}_{\mathbf{1}}\boldsymbol{\epsilon}_{ \mathbf{1}}^{\prime}\mathbf{p}_{\mathbf{2}}\\ \boldsymbol{\epsilon}_{\mathbf{2}}^{\prime}\mathbf{p}_{\mathbf{1}}(\mathbf{I}_{ \mathbf{1}}-\mathbf{D}_{\mathbf{1}})&d\boldsymbol{\epsilon}_{\mathbf{2}}^{ \prime}\mathbf{p}_{\mathbf{2}}\end{array}\right].\]

\(\boldsymbol{\mathcal{Q}}\) is the same as before. Therefore we already know what \(\boldsymbol{\pi}\) is, and get \(\boldsymbol{\mathcal{P}}\) from that.

\[\boldsymbol{\pi}=\frac{1}{\bar{t}_{1}+\bar{t}_{2}}[\mathbf{p}_{\mathbf{1}} \mathbf{V}_{\mathbf{1}},\,\mathbf{p}_{\mathbf{2}}\mathbf{V}_{\mathbf{2}}] \quad\text{and}\quad\boldsymbol{\mathcal{Q}}=\frac{1}{1+\lambda_{p}\bar{t}_{1 }}[\lambda_{p}\mathbf{p}_{\mathbf{1}}\mathbf{V}_{\mathbf{1}},\,\mathbf{p}_{ \mathbf{2}}].\]

<!-- Pages 499-499 -->

The flow rate is

\[\kappa=\boldsymbol{\pi}\boldsymbol{\mathcal{L}}\boldsymbol{\varepsilon}^{\prime}= \frac{1}{\boldsymbol{\varphi}\boldsymbol{\mathcal{V}}\boldsymbol{\varepsilon} ^{\prime}}=\frac{1+\lambda_{p}\bar{t}_{1}}{\bar{t}_{1}+\bar{t}_{2}}.\]

The denominator is the mean cycle time, so the mean number of packets per burst is one more than in the pure _ON-OFF_ MMPP model, as we would have hoped.

Before going on, we examine \(\boldsymbol{\mathcal{Y}}\). Although it is more complex than the \(\boldsymbol{\mathcal{Y}}\) for the pure MMPP _ON-OFF_ process in Example 8.3.2, it has the same rank. The other \(\boldsymbol{\mathcal{Y}}\) has \(m_{2}\) columns of all zeroes. Also its \(\boldsymbol{\mathcal{Y}_{11}}\) block matrix has an inverse. Therefore it must be of rank \(m_{1}\). This \(\boldsymbol{\mathcal{Y}}=\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{L}}\), as it must. \(\boldsymbol{\mathcal{L}}\) has \(m_{2}\) rows of \(0\), and so must be of rank \(m_{1}\). Therefore, \(\boldsymbol{\mathcal{Y}}\) must also have rank \(m_{1}\).

If in particular, the _ON_ time is exponentially distributed then \(m_{1}=1\) and \(\boldsymbol{\mathcal{Y}}\) is of rank \(1\), just as in Theorem 8.3.1. Therefore, here too, if the \(ON\)-time distribution is exponential, the process is a renewal process. Direct substitution shows that \(\boldsymbol{\mathcal{L}}\) and \(\boldsymbol{\mathcal{Y}}\) reduce to

\[\boldsymbol{\mathcal{L}}=\left[\begin{array}{cc}\lambda_{p}&(1/\bar{t}_{1}) \mathbf{p}_{2}\\ \mathbf{o}^{\prime}&\mathbf{0}\end{array}\right]\]

and

\[\boldsymbol{\mathcal{Y}}=\left[\begin{array}{cc}1-d&d\,\mathbf{p}_{2}\\ (1-d)\boldsymbol{\epsilon}_{2}^{\prime}&d\boldsymbol{\epsilon}_{2}^{\prime} \end{array}\right]=\left[\begin{array}{c}1\\ \boldsymbol{\epsilon}_{2}^{\prime}\end{array}\right][1-d,\,d\,\mathbf{p}_{2}]= \boldsymbol{\varepsilon}^{\prime}\boldsymbol{\wp},\]

whereas \(\boldsymbol{\mathcal{B}}\) and \(\boldsymbol{\mathcal{V}}\) reduce to

\[\boldsymbol{\mathcal{B}}=\left[\begin{array}{cc}1/\bar{t}_{1}\,d&\mathbf{o} \\ -\mathbf{B}_{2}\boldsymbol{\epsilon}_{2}^{\prime}&\mathbf{B}_{2}\end{array} \right]\quad\text{and}\quad\boldsymbol{\mathcal{V}}=\left[\begin{array}{cc }\bar{t}_{1}d&\mathbf{o}\\ \bar{t}_{1}\,d\boldsymbol{\epsilon}_{2}^{\prime}&\mathbf{V}_{2}\end{array} \right],\]

where \(d=1/(1+\lambda_{p}\bar{t}_{1})\). As already stated, this is a renewal process with interdeparture times generated by \(\boldsymbol{\langle}\boldsymbol{\wp},\boldsymbol{\mathcal{B}}\boldsymbol{ \rangle}\). The reader should show directly that

\[\boldsymbol{\mathbb{E}}[X] =\boldsymbol{\wp}\boldsymbol{\mathcal{V}}\boldsymbol{ \varepsilon}^{\prime}=d(\bar{t}_{1}+\bar{t}_{2})\quad\text{and}\] \[\sigma_{X}^{2} =d\,\sigma_{2}^{2}+d^{2}\,\bar{t}_{1}^{2}+d(1-d)\bar{t}_{2}^{2}.\]

We return now to nonexponential \(ON\) times, The formulas get quite messy as we attempt to find \(\sigma_{X}^{2}\) and other properties. We find that

\[\boldsymbol{\wp}\boldsymbol{\mathcal{V}}=\frac{1}{1+\lambda_{p}\bar{t}_{1}} \boldsymbol{[}\boldsymbol{p}_{1}\boldsymbol{V}_{1},\ \boldsymbol{p}_{2}\boldsymbol{V}_{2}\boldsymbol{]}\]

and

\[\boldsymbol{\mathcal{V}}\boldsymbol{\varepsilon}^{\prime}=\left[\begin{array}[] {c}\boldsymbol{V}_{1}\boldsymbol{D}_{1}\boldsymbol{\epsilon}_{1}^{\prime}\\ \Psi[\boldsymbol{V}_{1}\boldsymbol{D}_{1}]\boldsymbol{\epsilon}_{2}^{\prime}+ \boldsymbol{V}_{2}\boldsymbol{\epsilon}_{2}^{\prime}\end{array}\right].\]

It is easy enough to evaluate \(\boldsymbol{\wp}\boldsymbol{\mathcal{V}}\boldsymbol{\varepsilon}^{\prime}\) numerically for any specific values of the various parameters, but the analytic expression is somewhat long

<!-- Pages 503-503 -->

and by (8.2.8a)

\[\boldsymbol{\mathcal{Q}}=\boldsymbol{\mathcal{B}}-\boldsymbol{\mathcal{L}}=\hat{ \mathbf{B}}_{1}(\mathbf{I}-\hat{\mathbf{Q}_{1}})+\hat{\mathbf{B}}_{2}(\mathbf{I }-\hat{\mathbf{Q}_{2}}). \tag{8.3.19b}\]

By direct substitution, it can be shown that

\[\boldsymbol{\mathcal{P}}=\frac{1}{\bar{x}_{1}+\bar{x}_{2}}(\mathbf{p}_{1} \otimes\mathbf{p}_{2})(\hat{\mathbf{V}}_{1}+\hat{\mathbf{V}}_{2})\] (8.3.20a) and satisfies \[\boldsymbol{\mathcal{P}}\boldsymbol{\mathcal{Y}}=\boldsymbol{\mathcal{P}}.\] Also, from (8.2.8b) \[\boldsymbol{\pi}=c\,\boldsymbol{\mathcal{P}}\boldsymbol{\mathcal{V}}=\frac{1}{ \bar{x}_{1}\,\bar{x}_{2}}(\mathbf{p}_{1}\otimes\mathbf{p}_{2})(\hat{\mathbf{ V}}_{1}\,\hat{\mathbf{V}}_{2}), \tag{8.3.20b}\] \[\boldsymbol{\mathbb{E}}[X]=\boldsymbol{\mathcal{P}}[\hat{\mathbf{B}}_{1}+ \hat{\mathbf{B}}_{2}]^{-1}\boldsymbol{\mathcal{E}}^{\prime}=\boldsymbol{ \mathcal{P}}[\hat{\mathbf{V}}_{1}+\hat{\mathbf{V}}_{2}]^{-1}\,\hat{\mathbf{V} }_{1}\,\hat{\mathbf{V}}_{2}\,\boldsymbol{\mathcal{E}}^{\prime}\] \[=\frac{\bar{x}_{1}\,\bar{x}_{2}}{\bar{x}_{1}+\bar{x}_{2}}=\frac{1}{(1/ \bar{x}_{1}\!+\!1/\bar{x}_{2})}\,. \tag{8.3.20c}\]

Clearly, the mean arrival rate \((1/\bar{x})\) is equal to the sum of the arrival rates \([(1/\bar{x_{1}}\!+\!1/\bar{x_{2}})]\) of the two streams. This is only true for the steady state, or when many customers have already departed.

These equations are perfectly amenable to numerical computation, but we can get analytical results if \(S_{1}\) or \(S_{2}\) is an exponential server (or equivalently, if one of the processes is Poisson). Let \(m_{2}=1\). Then \(\mathbf{B}_{2}\) is a scalar, say \(\lambda\), and we can drop the subscript for \(S_{1}\). The product space is now the same as the state-space for \(S_{1}\). The above equations become

\[\boldsymbol{\mathcal{B}}=\mathbf{B}+\lambda\mathbf{I},\] (8.3.21a) \[\boldsymbol{\mathcal{L}}=\mathbf{B}\,\mathbf{Q}+\lambda\mathbf{I},\ \ \ \ \boldsymbol{\mathcal{Q}}=\mathbf{B}-\mathbf{B}\,\mathbf{Q},\] (8.3.21b) and \[\boldsymbol{\mathcal{Y}}=[\lambda\mathbf{I}+\mathbf{B}]^{-1}\,[\lambda\mathbf{ I}+\

<!-- Pages 504-504 -->

\[=\frac{1}{1+\lambda\bar{x}}\left[(\Psi[\lambda\mathbf{VD}])^{2}+\Psi[ \lambda^{3}\,\mathbf{V}^{3}\,\mathbf{D}^{2}]\right]-\left[\frac{\lambda\bar{x}}{1 +\lambda\bar{x}}\right]^{2}\,. \tag{8.3.22b}\]

Recall that \(\lambda\mathbf{VD}=\mathbf{I}-\mathbf{D}\), so from (4.4.1c)

\[\alpha_{k}(\lambda):=\Psi[(\lambda\mathbf{VD})^{k}\,\mathbf{D}]=\int_{\mathrm{ o}}^{\infty}\frac{(\lambda x)^{k}}{k!}\,e^{-\lambda x}\,f(x)\,dx. \tag{8.3.22c}\]

The integral clearly shows that \(\alpha_{k}(\lambda)\) is the probability that there will be \(k\) departures from \(S_{2}\) between departures from \(S_{1}\). For future reference, it is not hard to see (in at least two different ways) that \(\sum_{k=\mathrm{o}}^{\infty}\alpha_{k}(\lambda)=1\).

Finally it can be shown that

\[\lambda^{2}\,\mathrm{Cov}(X,\,X_{+1})=\frac{\alpha_{\mathrm{o}}^{2}+\alpha_{1 }}{1+\lambda\bar{x}}-\frac{1}{[1+\lambda\bar{x}]^{2}}\,. \tag{8.3.22d}\]

If \(f(x)\) is exponential (two Poisson processes), then \(\alpha_{\mathrm{o}}=1/(1+\lambda\bar{x})\), \(\alpha_{1}=\lambda\bar{x}/(1+\lambda\bar{x})^{2}\), and the covariance is \(0\). Of course in this case, (8.3.21c) clearly shows that \(\boldsymbol{\mathcal{Y}}\) reduces to \(1\), and all correlations are \(0\). Thus we reprove the well-known theorem that the merging of Poisson processes is a Poisson process with mean arrival rate equal to the sum of the arrival rates of the individual processes.

Similar expressions can be derived for lag-2 or more, but with increasing difficulty. Note, however, that the last equation does not depend on any ME representation, so it is true for all distributions.

#### 8.3.4 Departures from Overloaded Multiprocessor Systems

In Chapter 6 we discussed "generalized X/G/C-type systems". Such systems can be \(C\) identical servers, or even an arbitrary _Jackson networklike_ collection of load-dependent exponential servers, for which only \(C\) customers can be active at once. The other customers must queue up. The matrices needed here are already defined in that chapter. The correspondence is as follows, where all matrices with subscript \(c\) are the _reduced-product space_ operators explicitly defined in Chapter 6.

\[\begin{array}{rcl}\boldsymbol{\mathcal{B}}&=&\mathbf{B_{c}}\\ \boldsymbol{\mathcal{L}}&=&\mathbf{M_{c}}\,\mathbf{Q_{c}}\,\mathbf{R_{c}}\\ \boldsymbol{\mathcal{Y}}&=&\mathbf{V_{c}}\,\mathbf{M_{c}}\,\mathbf{Q_{c}}\, \mathbf{R_{c}}\\ \boldsymbol{\wp}_{\mathrm{o}}&=&\mathbf{p}\,\mathbf{R_{2}}\,\mathbf{R_{3}}\, \cdots\,\mathbf{R_{c}}\\ \boldsymbol{\wp}&=&\boldsymbol{\pi_{c}}.\end{array} \tag{8.3.23}\]

Imagine a large number of customers waiting to be served with \(C\) of them entering service simultaneously at the start. Then \(\boldsymbol{\wp}_{\mathrm{o}}\) is the initial vector, and many properties, including the mean time to drain the queue, as well as the interdeparture distributions and correlations can be calculated according to the formulas in this chapter.

<!-- Pages 507-507 -->

where \(\boldsymbol{\wp}\boldsymbol{\varepsilon}^{\prime}=1\). With some algebraic manipulation it can be shown that \(\boldsymbol{\wp}\boldsymbol{\mathcal{Y}}=\boldsymbol{\wp}\).

Note, it is the departure vectors of the M/G/1 queue, \(\mathbf{d}(n)\) (see theorem 4.2.4), not the steady-state vectors \(\pi(n)\), that make up \(\boldsymbol{\wp}\), the left eigenvector of \(\boldsymbol{\mathcal{Y}}\). Also note that if the elements of \(\boldsymbol{\mathcal{Y}}\) are reduced to scalars by pre- and postmultiplying them by appropriately dimensioned \(\mathbf{p}\) (or 1) and \(\boldsymbol{\epsilon}^{\prime}\) (or 1), the following matrix results [see (8.3.22c)].

\[\bar{\boldsymbol{\mathcal{Y}}}:=\left[\begin{array}{cccccc}\alpha_{\text{o} }&\alpha_{1}&\alpha_{2}&\alpha_{3}&\alpha_{4}&\cdots\\ \alpha_{\text{o}}&\alpha_{1}&\alpha_{2}&\alpha_{3}&\alpha_{4}&\cdots\\ 0&\alpha_{\text{o}}&\alpha_{1}&\alpha_{2}&\alpha_{3}&\cdots\\ 0&0&\alpha_{\text{o}}&\alpha_{1}&\alpha_{2}&\cdots\\ \cdots&\cdots&\cdots&\cdots&\cdots&\cdots\end{array}\right]. \tag{8.3.29}\]

Finding the left-eigenvector of this matrix is the standard way one finds the scalar steady-state probabilities, as given in [100] (see also Section 4.4.3). But its derivation depends on the knowledge that a random observer sees the same probabilities as a departing customer for the M/G/1 queue. This, in turn, is only true because the arrival process to \(S_{1}\) is Poisson.

Returning to evaluation of the various covariances, we need expressions for \(\boldsymbol{\mathcal{Y}}\boldsymbol{\nu}\boldsymbol{\varepsilon}^{\prime}\) and \(\boldsymbol{\mathcal{Y}}\boldsymbol{\mathcal{V}}\boldsymbol{\nu}\boldsymbol{ \varepsilon}^{\prime}\). It does not take too much effort to get them. They are:

\[\lambda\boldsymbol{\mathcal{Y}}\boldsymbol{\nu}\boldsymbol{\varepsilon}^{ \prime}=\left[\begin{array}{c}\alpha_{\text{o}}\\ \mathbf{D}\boldsymbol{\epsilon}^{\prime}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \cdots\end{array}\right]+\rho\boldsymbol{\varepsilon}^{\prime}\] (8.3.30a) and \[\lambda\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{Y}}\boldsymbol{\nu} \boldsymbol{\varepsilon}^{\prime}=\left[\begin{array}{c}\alpha_{\text{o}}+ \alpha_{1}\\ (\lambda\mathbf{V}\mathbf{D})\mathbf{D}\boldsymbol{\epsilon}^{\prime}\\ \mathbf{o}^{\prime}\\ \cdots\end{array}\right]+\rho\left[\begin{array}{c}1\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \cdots\end{array}\right]+\rho\left[\begin{array}{c}\rho\\ \lambda\mathbf{V}\boldsymbol{\epsilon}^{\prime}\\ \lambda\mathbf{V}\boldsymbol{\epsilon}^{\prime}\\ \lambda\mathbf{V}\boldsymbol{\epsilon}^{\prime}\\ \cdots\end{array}\right]. \tag{8.3.30b}\]

Three different initial conditions are presented here for \(\boldsymbol{\wp}_{\text{o}}\). They are:

1. The process starts with an empty queue (designated by subscript "a"),

2. The process starts with the arrival of a customer to an empty queue (subscript "b"),

3. The process starts in its steady state (8.3.28) (no subscript).

The first two are:

\[\boldsymbol{\wp}_{\mathbf{a}}=[1,\,\mathbf{o},\,\mathbf{o},\,\mathbf{o},\, \dots]\] (8.3.31a) and \[\boldsymbol{\wp}_{\mathbf{b}}=[0,\,\mathbf{p},\,\mathbf{o},\,\mathbf{o},\, \dots]. \tag{8.3.31b}\]

<!-- Pages 509-509 -->

and

\[\boldsymbol{\mathcal{V}}\boldsymbol{\varepsilon}^{\prime}=\frac{1}{\lambda} \boldsymbol{\varepsilon^{\prime}}+\left[\begin{array}{c}\mathbf{V}\boldsymbol{ \epsilon^{\prime}}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \cdots\end{array}\right], \tag{8.3.32d}\]

where \(\mathbf{D}:=[\mathbf{I}+\lambda\mathbf{V}]^{-1}\) and \(d:=\alpha_{\mathrm{o}}=\Psi[\mathbf{D}]\) [see (8.3.22c)]. We also have occasion once again to use \(\lambda\mathbf{V}\mathbf{D}=\mathbf{I}-\mathbf{D}\). It is not hard to see that the departure matrix is

\[\boldsymbol{\mathcal{L}}=\left[\begin{array}{ccccc}\mathbf{O}&\mathbf{O}& \mathbf{O}&\mathbf{O}&\cdots\\ \lambda\mathbf{I}&\mathbf{O}&\mathbf{O}&\mathbf{O}&\cdots\\ \mathbf{O}&\lambda\mathbf{I}&\mathbf{O}&\mathbf{O}&\cdots\\ \mathbf{O}&\mathbf{O}&\lambda\mathbf{I}&\mathbf{O}&\cdots\\ \cdots&\cdots&\cdots&\cdots&\cdots\end{array}\right]\quad\text{and}\quad \boldsymbol{\mathcal{L}}\boldsymbol{\varepsilon^{\prime}}=\lambda\left[ \begin{array}{c}\mathbf{o}^{\prime}\\ \boldsymbol{\epsilon^{\prime}}\\ \boldsymbol{\epsilon^{\prime}}\\ \boldsymbol{\epsilon^{\prime}}\\ \cdots\end{array}\right]=\boldsymbol{\mathcal{B}}\boldsymbol{\varepsilon^{ \prime}}.\] (8.3.33a) We see, then, that ( 8.2.1 ) is satisfied. We can calculate \[\boldsymbol{\mathcal{Y}}\] and, with some effort, we can also show that it is isometric, \[\boldsymbol{\mathcal{Y}}=\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{L}}= \lambda\left[\begin{array}{ccccc}\mathbf{Q}\mathbf{V}\mathbf{D}&d\mathbf{Q} \mathbf{V}\mathbf{D}&d^{2}\mathbf{Q}\mathbf{V}\mathbf{D}&d^{3}\mathbf{Q} \mathbf{V}\mathbf{D}&\cdots\\ \mathbf{V}\mathbf{D}&\mathbf{D}\mathbf{Q}\mathbf{V}\mathbf{D}&d\mathbf{D} \mathbf{Q}\mathbf{V}\mathbf{D}&d^{2}\mathbf{D}\mathbf{Q}\mathbf{V}\mathbf{D}& \cdots\\ \mathbf{O}&\mathbf{O}&\mathbf{V}\mathbf{D}&\mathbf{D}\mathbf{Q}\mathbf{V} \mathbf

<!-- Pages 510-510 -->

\[s=F^{*}(\lambda(1-s)).\]

The geometric parameter for the steady-state G/M/1 queue \(s\) is the smallest root between 0 and 1 that satisfies the above.

The most important example is the steady-state vector. Again from Theorem 5.1.3 we know that the steady-state vector probability of having \(k\) customers at \(S_{1}\) at the time of a departure is

\[\mathbf{d}(k)=(1-s)s^{k}\,\hat{\mathbf{u}}.\]

Therefore, the infinite steady-state vector over all queue lengths is

\[\boldsymbol{\wp}=(1-s)[\hat{\mathbf{u}},\,s\hat{\mathbf{u}},\,s^{2}\hat{ \mathbf{u}},\,s^{3}\hat{\mathbf{u}},\,\ldots]. \tag{8.3.37}\]

One can show by direct calculation that this \(\boldsymbol{\wp}\) satisfies (8.2.7) (\(\boldsymbol{\wp\mathcal{Y}}=\boldsymbol{\wp}\)), as it must. Of course, all three vectors have "length" 1; that is,

\[\boldsymbol{\wp}_{\mathrm{a}}\boldsymbol{\varepsilon^{\prime}}=\boldsymbol{ \wp}_{\mathrm{b}}\boldsymbol{\varepsilon^{\prime}}=\boldsymbol{\wp} \boldsymbol{\varepsilon^{\prime}}=1.\]

In order to calculate the covariance for each of the three cases, we need:

\[\boldsymbol{\wp}_{\mathrm{x}}\left[\boldsymbol{\mathcal{V}}\right] \boldsymbol{\varepsilon^{\prime}},\hskip 14.226378pt\boldsymbol{\wp}_{ \mathrm{x}}\left[\boldsymbol{\mathcal{V}}\right]\boldsymbol{\varepsilon^{ \prime}},\hskip 14.226378pt\mathrm{and}\hskip 14.226378pt \boldsymbol{\wp}_{\mathrm{x}}\left[\boldsymbol{\mathcal{V}}\boldsymbol{ \mathcal{V}}\right]\boldsymbol{\varepsilon^{\prime}},\]

where \(\mathbf{x=a}\), \(\mathbf{b}\), and \(blank\). This is easiest done by first setting up \(\left[\boldsymbol{\mathcal{V}}\boldsymbol{\varepsilon^{\prime}}\right]\), \(\left[\boldsymbol{\mathcal{V}}\boldsymbol{\varepsilon^{\prime}}\right]\), and \(\left[\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{V}}\boldsymbol{ \varepsilon^{\prime}}\right]\). We already know \(\left[\boldsymbol{\mathcal{V}}\boldsymbol{\varepsilon^{\prime}}\right]\) from (8.3.32d). The second term is

\[\boldsymbol{\mathcal{V}}\boldsymbol{\nu}\boldsymbol{\varepsilon^{\prime}}= \boldsymbol{\mathcal{Y}}\left[\boldsymbol{\nu}\boldsymbol{\varepsilon^{ \prime}}\right]=\frac{1}{\lambda}\boldsymbol{\mathcal{Y}}\boldsymbol{ \varepsilon^{\prime}}+\boldsymbol{\mathcal{Y}}\left[\begin{array}{c} \mathbf{V}\boldsymbol{\epsilon^{\prime}}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \cdots\end{array}\right]=\frac{1}{\lambda}\boldsymbol{\varepsilon^{\prime} }+\lambda\left[\begin{array}{c}\Psi[\mathbf{V}^{2}\,\mathbf{D}]\, \boldsymbol{\epsilon^{\prime}}\\ \mathbf{V}^{2}\,\mathbf{D}\boldsymbol{\epsilon^{\prime}}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\ \cdots\end{array}\right].\] (8.3.38a) The third term can be evaluated in a similar fashion \[\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{V}}\boldsymbol{\varepsilon^{ \prime}}=\boldsymbol{\mathcal{V}}\left[\boldsymbol{\mathcal{V}}\boldsymbol{ \varepsilon^{\prime}}\right]=\frac{1}{\lambda}\boldsymbol{\mathcal{V}} \boldsymbol{\varepsilon^{\prime}}+\lambda\boldsymbol{\mathcal{V}}\left[ \begin{array}{c}\Psi[\mathbf{V}^{2}\,\mathbf{D}]\,\boldsymbol{\epsilon^{ \prime}}\\ \mathbf{V}^{2}\,\mathbf{D}\boldsymbol{\epsilon^{\prime}}\\ \mathbf{o}^{\prime}\\ \mathbf{o}^{\prime}\\

<!-- Pages 512-512 -->

\[\begin{array}{rcl}\lambda^{2}\,{\rm Cov}(X_{a1},\,X_{a2})&=&\alpha_{\rm o}+ \alpha_{1}-1\\ \lambda^{2}\,{\rm Cov}(X_{b1},\,X_{b2})&=&\lambda^{2}\,{\rm Cov}(X_{a1},\,X_{a2} )\\ s\lambda^{2}\,{\rm Cov}(X_{1},\,X_{2})&=&\alpha_{\rm o}\,(\lambda s\bar{x}-1). \end{array} \tag{8.3.39d}\]

The steady-state covariance formula is particularly interesting. Only if \(\lambda s\bar{x}=1\) is the covariance equal to \(0\). For G/M/1 queues, the utilization factor, \(\rho\) is equal to \(1/(\lambda\bar{x})\). The only interarrival process for which \(s=\rho\) for all \(\rho\) is the Poisson process, but it is possible for the covariance lag-1 to vanish for some values of \(\rho\).

##### 8.3.5.3 Both \(S_{1}\) and \(S_{2}\) Are Nonexponential

It is possible to generalize from the two previous sections what \(\boldsymbol{\mathcal{B}}\), \(\boldsymbol{\mathcal{V}}\), \(\boldsymbol{\mathcal{L}}\), and \(\boldsymbol{\mathcal{Y}}\) are for the G/G/1 queue. Furthermore, given that \(\boldsymbol{\mathcal{Y}}\) is subtriangular, the steady-state departure vector \(\boldsymbol{\mathcal{P}}\) can be computed recursively. The notation is the same as that for Section 8.3.3, where subscript 2 refers to the arrival process, and subscript 1 refers to the service process. The relevant matrices are again ordered according to the number of customers at \(S_{1}\), and the entries themselves are matrices. The \(00\) element is an \(m_{2}\times m_{2}\) matrix, the other \(0n\) elements are \(m_{2}\times m_{1}\,m_{2}\) matrices, the other \(n0\) matrices are \(m_{1}\,m_{2}\times m_{2}\)-dimensional, and all other elements are \(m_{1}\,m_{2}\times m_{1}\,m_{2}\) matrices. Generalizing from (8.3.24a) and (8.3.32a), we write

\[\boldsymbol{\mathcal{B}}=\left[\begin{array}{ccccc}{\bf B}_{2}&-{\bf\hat{p}} _{1}\,{\bf\hat{B}}_{2}{\bf\hat{Q}}_{2}&{\bf O}&{\bf O}&\cdots\\ {\bf O}&{\bf\hat{B}}_{1}+{\bf\hat{B}}_{2}&-{\bf\hat{B}}_{2}{\bf\hat{Q}}_{2}&{ \bf O}&\cdots\\ {\bf O}&{\bf O}&{\bf\hat{B}}_{1}+{\bf\hat{B}}_{2}&-{\bf\hat{B}}_{2}{\bf\hat{Q} }_{2}&\cdots\\ {\bf O}&{\bf O}&{\bf O}&{\bf\hat{B}}_{1}+{\bf\hat{B}}_{2}&\cdots\\ \cdots&\cdots&\cdots&\cdots&\cdots\end{array}\right]. \tag{8.3.40a}\]

It can be verified by direct multiplication that (now let \({\bf D}:=[{\bf\hat{B}}_{1}+{\bf\hat{B}}_{2}]^{-1}\))

\[\boldsymbol{\mathcal{V}}=\left[\begin{array}{ccccc}{\bf V}_{2}&{\bf\hat{p}} _{1}{\bf\hat{Q}}_{2}{\bf D}&{\bf\hat{p}}_{1}{\bf\hat{Q}}_{2}{\bf D}{\bf X}&{ \bf\hat{p}}_{1}{\bf\hat{Q}}_{2}{\bf D}{\bf X}^{2}&{\bf\hat{p}}_{1}{\bf\hat{Q} }_{2}{\bf D}{\bf X}^{3}&\cdots\\ {\bf o}^{\prime}&{\bf D}&{\bf D}{\bf X}&{\bf D}{\bf X}^{2}&{\bf D}{\bf X}^{3}& \cdots\\ {\bf o}^{\prime}&{\bf O}&{\bf D}&{\bf D}{\bf X}&{\bf D}{\bf X}^{2}&\cdots\\ {\bf o}^{\prime}&{\bf O}&{\bf O}&{\bf D}&{\bf

<!-- Pages 515-515 -->

and departures). For QBD processes the steps are multistate sets, exactly as we have been dealing with here.

Let \(\boldsymbol{\pi}(n)\) be the steady-state vector probability that the system is in vector state \(\{i,\,n\}\) and \(r(n)=\boldsymbol{\pi}(n)\boldsymbol{\varepsilon}^{\prime}\) is the associated scalar probability. The theorem states that if the matrices that govern the transitions are independent of the population \(n\), then

\[\boldsymbol{\pi}(n)=c\,\boldsymbol{\mathcal{U}}\boldsymbol{\mathcal{R}}^{n} \quad\text{and}\quad r(n)=\boldsymbol{\pi}(n)\boldsymbol{\varepsilon}^{ \prime},\]

where \(\boldsymbol{\mathcal{R}}\) is a matrix satisfying some _matrix quadratic equation_, \(\boldsymbol{u}\) is a special vector with \(\boldsymbol{u}\boldsymbol{\varepsilon}^{\prime}=1\), and \(c\) is determined by the normalization condition, \(\sum_{n=\infty}^{\infty}r(n)=1\).

We next consider queueing systems where the arrivals to an exponential server are generated by some MRP satisfying the rules defined in this chapter. By "system" we mean the combination of the arrival process, the exponential server, and the customers in the queue.

#### 8.4.1 Balance Equations

Let \(n\) be the number of customers at an exponential server (called \(S_{\nu}\)) with service rate \(\nu\). The arrival process is described by the matrices \(\boldsymbol{\mathcal{B}},\ \boldsymbol{\mathcal{Q}},\ \text{and}\ \boldsymbol{\mathcal{L}}\), as defined previously. The \(i\)th component of the ss vector, \(\boldsymbol{\pi}_{i}(n)\), refers to the state the MRP is in when there are \(n\) customers at \(S_{\nu}\). This is a straightforward generalization of the description we gave in Chapter 5 from the G/M/1 queue. The system can leave state \(\{i\,;\,n\,\}\) by either a change at the MRP \([\boldsymbol{\pi}_{i}(n)(\boldsymbol{\mathcal{M}})_{ii}]\) or a customer completion at \(S_{\nu}\)\([\boldsymbol{\pi}_{i}(n)\nu]\). The system can enter this state by one of three ways:

1. A change of state from some \(j\) to \(i\) in the arrival process \([\boldsymbol{\pi}_{j}(n)(\boldsymbol{\mathcal{M}})_{jj}(\boldsymbol{\mathcal{ P}})_{ji}]\),

2. A customer completion at \(S_{\nu}\) when there are \(n\!+\!1\) customers there \([\boldsymbol{\pi}_{i}(n\!+\!1)\nu]\),

3. The MRP has a departure when there are \(n\!-\!1\) customers at \(S_{\nu}\)\([\boldsymbol{\pi}_{j}(n\!-\!1)(\boldsymbol{\mathcal{L}})_{ji}]\).

By summing over all intermediate subscripts we get the vector balance equations:

\[\boldsymbol{\pi}(n)(\boldsymbol{\mathcal{M}}+\mu\boldsymbol{\mathcal{I}})= \boldsymbol{\pi}(n)\boldsymbol{\mathcal{M}}\boldsymbol{\mathcal{P}}+ \boldsymbol{\pi}(n\!+\!1)\nu+\boldsymbol{\pi}(n\!-\!1)\boldsymbol{\mathcal{L}}.\]

Making use of the relation, \(\boldsymbol{\mathcal{B}}=\boldsymbol{\mathcal{M}}-\boldsymbol{\mathcal{M}} \boldsymbol{\mathcal{P}}\) we get for \(n\geq 1\),

\[\boldsymbol{\pi}(n\!+\!1)\nu-\boldsymbol{\pi}(n)(\boldsymbol{\mathcal{B}}+\nu \boldsymbol{\mathcal{I}})+\boldsymbol{\pi}(n\!-\!1)\boldsymbol{\mathcal{L}}=0. \tag{8.4.1a}\]

[Compare with (4.1.3d).] For \(n=0\) there is no possibility for a customer to complete service, so instead we have

\[\boldsymbol{\pi}(1)\nu=\boldsymbol{\pi}(0)\boldsymbol{\mathcal{B}}. \tag{8.4.1b}\]

We now substitute \(\boldsymbol{\pi}(n)=\boldsymbol{\pi}\boldsymbol{\mathcal{R}}^{n}\) into (8.4.1a), but \(\boldsymbol{\pi}\) and \(\boldsymbol{\mathcal{R}}\) are yet to be determined. For \(n>1\),

\[\boldsymbol{\pi}(1)\left[\nu\boldsymbol{\mathcal{R}}^{n+1}-\boldsymbol{ \mathcal{R}}^{n}(\boldsymbol{\mathcal{B}}+\nu\boldsymbol{\mathcal{I}})+ \boldsymbol{\mathcal{R}}^{n-1}\boldsymbol{\mathcal{L}}\right]

<!-- Pages 516-516 -->

Because this must be true for all \(n>1\) and \(\boldsymbol{\pi}(1)\) cannot be \(0\), the expression in square brackets must be \(0\). Therefore

\[\boldsymbol{\mathcal{R}}^{n-1}\left[\nu\boldsymbol{\mathcal{R}}^{2}-\boldsymbol {\mathcal{R}}\left(\boldsymbol{\mathcal{B}}+\nu\boldsymbol{\mathcal{I}}\right) +\boldsymbol{\mathcal{L}}\right]=0.\]

Again, if \(\boldsymbol{\mathcal{R}}\) has an inverse (something that is not always true, as we show below) then the expression in square brackets must be \(0\). Thus

\[\nu\boldsymbol{\mathcal{R}}^{2}-\boldsymbol{\mathcal{R}}\left(\boldsymbol{ \mathcal{B}}+\nu\boldsymbol{\mathcal{I}}\right)+\boldsymbol{\mathcal{L}}=0.\] (8.4.2a) This equation doesn't hold for \[n=1\], so we must go back to ( 8.4.1a ), using \[\boldsymbol{\pi}(2)=\boldsymbol{\pi}(1)\boldsymbol{\mathcal{R}}\], \[\boldsymbol{\mathcal{Y}}=\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{L}}\], and ( 8.4.1b ) to get \[\boldsymbol{\pi}(1)\left[\nu\boldsymbol{\mathcal{R}}-\boldsymbol{\mathcal{B}}- \nu\boldsymbol{\mathcal{I}}+\nu\boldsymbol{\mathcal{Y}}\right]=0. \tag{8.4.2b}\]

Ah, if only we could argue that the expression in square brackets is zero, we would have an explicit expression for \(\boldsymbol{\mathcal{R}}\). But it is, instead, an eigenvector equation for \(\boldsymbol{\pi}(1)\) (once we know what \(\boldsymbol{\mathcal{R}}\) is). A necessary and sufficient condition that \(\boldsymbol{\mathcal{R}}=\boldsymbol{\mathcal{I}}+\boldsymbol{\mathcal{B}}/ \nu-\boldsymbol{\mathcal{Y}}\) satisfy (8.4.2a) is that \(\boldsymbol{\mathcal{Y}}^{2}=\boldsymbol{\mathcal{Y}}\). From (8.2.12c) this condition leads to \(\text{Cov}(X,X_{+k})=\text{constant}\), independent of \(k\). Furthermore, all the eigenvalues of \(\boldsymbol{\mathcal{Y}}\) must be either \(0\) or \(1\), the number of unit eigenvalues being equal to the rank of \(\boldsymbol{\mathcal{Y}}\). The only processes of interest to us that have these properties are the renewal processes, where the covariance equals \(0\) for all \(k\) and \(\boldsymbol{\mathcal{Y}}=\boldsymbol{\varepsilon^{\prime}\boldsymbol{ \wp}}\) has one unit eigenvalue. In fact this is exactly what we used in Chapters 4 and 5. But that does not work here, for we are now interested in the more general MRPs. We discuss this in Section 8.4.3.

Equation (8.4.2a) is the defining equation for \(\boldsymbol{\mathcal{R}}\), but it is not that easy to solve. First we search for some other properties. We multiply this equation from the right by \(\boldsymbol{\varepsilon^{\prime}}\) and note that \(\boldsymbol{\mathcal{L}\varepsilon^{\prime}}=\boldsymbol{\mathcal{B} \varepsilon^{\prime}}\) to get:

\[\nu(\boldsymbol{\mathcal{R}}-\boldsymbol{\mathcal{I}})\boldsymbol{\mathcal{ R}\varepsilon^{\prime}}=(\boldsymbol{\mathcal{R}}-\boldsymbol{\mathcal{I}}) \boldsymbol{\mathcal{B}\varepsilon^{\prime}}.\]

But \((\boldsymbol{\mathcal{R}}-\boldsymbol{\mathcal{I}})\) must have an inverse unless at least one of the eigenvalues of \(\boldsymbol{\mathcal{R}}\) equals \(1\). This happens when the arrival rate (\(\kappa=\boldsymbol{\pi}\boldsymbol{\mathcal{L}\varepsilon^{\prime}}\)) equals \(\nu\), in which case the system is unstable and there is no steady-state solution. Otherwise, a unit eigenvalue implies decomposability, a property which we assume has been removed _a priori_. So, assuming that \((\boldsymbol{\mathcal{I}}-\boldsymbol{\mathcal{R}})^{-1}\) exists, we get

\[\nu\boldsymbol{\mathcal{R}\varepsilon^{\prime}}=\boldsymbol{\mathcal{B} \varepsilon^{\prime}}. \tag{8.4.3}\]

This relation also satisfies (8.4.2b).

The \(\boldsymbol{\pi}\) vectors must still satisfy the normalization property \(\sum r(n)=1\). But more than that, we can assume that if the MRP is observed without reference to queue length it must be found in state \(i\) with the same probability as the residual vector. That is,

\[\sum_{n=0}^{\infty}\boldsymbol{\pi}(n)=\boldsymbol{\pi},\]

<!-- Pages 517-517 -->

where \(\boldsymbol{\pi}\) (no argument) is defined by (8.2.8b), namely, \(\boldsymbol{\pi}\boldsymbol{\mathcal{Q}}=\mathbf{o}\), and \(\boldsymbol{\pi}\boldsymbol{\varepsilon^{\prime}}=1\). Thus [note that \(\boldsymbol{\pi}(0)\) may not be of the same form as the other vector probabilities]

\[\boldsymbol{\pi}=\sum_{n=1}^{\infty}\boldsymbol{\pi}(1)\boldsymbol{\mathcal{R }}^{n-1}+\boldsymbol{\pi}(0)=\boldsymbol{\pi}(1)\left[(\boldsymbol{\mathcal{ I}}-\boldsymbol{\mathcal{R}})^{-1}+\nu\boldsymbol{\mathcal{V}}\right]\]

or

\[\boldsymbol{\pi}(1)[\boldsymbol{\mathcal{I}}+\nu\boldsymbol{\mathcal{V}}( \boldsymbol{\mathcal{I}}-\boldsymbol{\mathcal{R}})]=\boldsymbol{\pi}( \boldsymbol{\mathcal{I}}-\boldsymbol{\mathcal{R}}). \tag{8.4.4}\]

But equations (8.4.2a), (8.4.2b), (8.4.3), and (8.4.4) together are not sufficient to uniquely determine the vector-matrix pair \(\left\{\boldsymbol{u},\,\boldsymbol{\mathcal{R}}\right\}\). In fact, there may be multiple distinct solutions, all of which produce the same queue-length probabilities \(\boldsymbol{\pi}(n)\).

At this point, following [Meier-Fischer92], we assume that

\[c\boldsymbol{u}=\boldsymbol{\pi}(\boldsymbol{\mathcal{I}}-\boldsymbol{ \mathcal{R}}).\]

From this we have

\[\boldsymbol{\pi}(n)=\boldsymbol{\pi}(\boldsymbol{\mathcal{I}}-\boldsymbol{ \mathcal{R}})\boldsymbol{\mathcal{R}}^{n}\quad\text{and}\quad r(n)= \boldsymbol{\pi}(\boldsymbol{\mathcal{I}}-\boldsymbol{\mathcal{R}}) \boldsymbol{\mathcal{R}}^{n}\boldsymbol{\varepsilon^{\prime}}. \tag{8.4.5}\]

This equation clearly satisfies \(\sum\boldsymbol{\pi}(n)=\boldsymbol{\pi}\), which then implies that \(\sum r(n)=1\). But, we still don't know how to solve for \(\boldsymbol{\mathcal{R}}\).

A standard procedure for finding \(\boldsymbol{\mathcal{R}}\) follows.

**Algorithm 8.4.1:** First rewrite (8.4.2a) as

\[\boldsymbol{\mathcal{R}}=\nu\boldsymbol{\mathcal{R}}^{2}\boldsymbol{\mathcal{ D}}+\boldsymbol{\mathcal{LD}},\]

where \(\boldsymbol{\mathcal{D}}:=(\nu\boldsymbol{\mathcal{I}}+\boldsymbol{\mathcal{ B}})^{-1}\). Consider this to be a formula for _fixed point iteration_. That is, let \(\boldsymbol{\mathcal{R}}_{\mathrm{o}}=\mathbf{0}\) and

\[\boldsymbol{\mathcal{R}}_{\ell+1}=\nu(\boldsymbol{\mathcal{R}}_{\ell})^{2} \,\boldsymbol{\mathcal{D}}+\boldsymbol{\mathcal{LD}},\quad\text{for}\;\;\ell \geq 0.\]

Iterate on \(\ell\) until \((\boldsymbol{\mathcal{R}}_{\ell+1}-\boldsymbol{\mathcal{R}}_{\ell})\) is "sufficiently small" by some pre-established criterion.

This procedure is guaranteed to converge if the MRP was constructed from PH representations, but may not converge otherwise. Nonconvergence does not mean there is no solution, just that another method, or a different \(\boldsymbol{\mathcal{R}}_{\mathrm{o}}\), must be chosen. Furthermore, this is not the unique solution to (8.4.2a). Given that this is a quadratic equation, one might expect to find two independent solutions. But this is a _matrix quadratic_ equation, for which the number of independent solutions is given by

\[\left(\begin{array}{c}2M\\ M\end{array}\right),\quad\text{where}\;\;M=\mathrm{Dim}(\boldsymbol{\mathcal{ R}}).\]

We can say that the algorithm produces an \(\boldsymbol{\mathcal{R}}\) whose eigenvalues are all less than \(1\) in magnitude, otherwise the algorithm would not converge. For more

<!-- Pages 521-521 -->

## Chapter 7 A QT

In the previous chapters we saw that matrix relations continually occur, independently of probabilistic interpretations. Surely this is not an accident. We now attempt to create a linear algebraic formulation that is not merely an algorithmic or computational aid but could lead to a complete formal procedure for dealing with nonexponential queues. The idea is to avoid resorting to any particular basis set, a common technique in linear algebra. We have not been entirely successful, but some interesting results, particularly in Section 9.3, are presented. The rest is open to discussion and review.

We first show that most, if not all, the equations in this book are invariant to the isometric transformations we introduced in Section 3.4.2. This invariance property implies that a basis-free formulation is possible. In some sense this chapter serves as a review of the book, but now all the properties of the servers and queues are in terms of linear operators that modify the state vector of the system when things happen. This change in viewpoint may appear self-evident to some readers, and if so, fine, but it is important to mention, nonetheless. We do not claim that we are doing this in the best or most efficient way to set up the algebraic structure. Surely some readers can do better. We merely wish to show that it can be done. Therefore, questions that may arise should not be considered to be weaknesses of the theory but issues to be cleared up or clarified, which may actually lead to new insights.

One problem we have is that density functions have the constraint that \(f(x)\geq 0\) for all pdfs. Thus the difference of pdfs does not always lead to a function that is greater than or equal to 0 for all \(x\). Therefore the set of all pdfs is not truly a _vector space_ even though the set of all integrable functions is. In various areas of applied mathematics, functions are expanded in terms of orthogonal functions which serve as the _basis vectors_. See Section 4.4.2 for the example of Laguerre polynomials and the discussion therein. Usually the accepted metric is defined in \(L_{2}\) space, that is, the "length" of a vector (function) is

\[\left[\int_{\rm o}^{\infty}|f(x)|^{2}dx\right]^{1/2}\]

<!-- Pages 522-522 -->

and _orthogonal basis functions_, \(\{\phi_{j}(x)\}\) satisfy the property:

\[\int_{\circ}^{\infty}\phi_{j}(x)\phi_{i}^{\prime}(x)dx=\delta_{ij}.\]

For this orthogonality condition to occur, all but one of the \(\phi_{i}\)s must be negative for some values of \(x\). Therefore they cannot be interpreted as pdfs.

In quantum mechanics the \(\psi\) functions are interpreted as _probability amplitudes_ (i.e., \(|\psi(x)|^{2}\) is a probability density), and \(\psi(x)\) can even be complex. How fortunate for physics that nature works this way for subatomic particles. But we are stuck with classical probability and as a substitute must use phases as basis functions, and isometric transformations as a substitute for preserving lengths. So don't try too hard to give physical meaning to individual phases.

### 9.1 Isometric Transformations

In Section 3.4.2 (Theorem 3.4.1), we showed that if \(\{\textbf{p}\,,\,\textbf{B}\}\) is a faithful representation of a given distribution function, so is \(\{\textbf{pS}^{-1}\,,\,\textbf{SBS}^{-1}\,\}\), where **S** is any isometric invertible matrix. That is, \(B(t)\), \(R(t)\), \(b(t)\), and \(B^{*}(s)\) remain unchanged by such transformations. These isometric transformations go beyond the description of a single server. We now extend this idea to any row vector **u**, column vector \(\textbf{v}^{\prime}\), and square matrix **X**, and define the following mapping.

_Definition 9.1.1_

Let **S** be any nonsingular _isometric matrix_, then the following mapping (or similarity transformation) is called an _isometric transformation_:

\[\tilde{\textbf{u}}:=\textbf{uS}^{-1},\ \ \ \ \ \tilde{\textbf{v}}^{\prime}= \textbf{S}\textbf{v}^{\prime},\]

and

\[\tilde{\textbf{X}}:=\textbf{SX}\textbf{S}^{-1},\]

for every row vector, column vector, and matrix of interest. Because **S** is isometric, \(\textbf{\epsilon}^{\prime}\) does not change under any transformation. Note that

\[\tilde{\textbf{u}}\tilde{\textbf{v}}^{\prime}=\textbf{uS}^{-1}\textbf{S} \textbf{v}^{\prime}=\textbf{u}\textbf{v}^{\prime}\ \ \ \text{and}\ \ \ \tilde{\textbf{v}}\left[\tilde{\textbf{X}}\right]:=\tilde{\textbf{p}}\tilde{ \textbf{X}}\textbf{\epsilon}^{\prime}=\Psi\left[\textbf{X}\right].\]

These equations show us that inner products and \(\Psi\left[\,\cdot\,\right]\) operations remain unchanged (are invariant) under isometric transformations. In general, we say that an "equation is invariant" if it is identical in form for the transformed objects as it is for the original objects. 

We showed in Section 4.1.2 that the steady-state solutions of M/G/1 queues (both open and closed) depend on the matrix **A** and its inverse **U**, defined by

\[\textbf{A}:=\textbf{U}^{-1}:=\textbf{I}+\frac{1}{\lambda}\textbf{B}-\textbf{Q}, \tag{9.1.1}\]

<!-- Pages 524-524 -->

### 9.2 Linear Algebraic Formulation

We now attempt to formulate queueing processes without resorting to individual components or phases. First we look at a single isolated (general) server \(S\). To do this we change the meaning of our notation somewhat. In general, one can start with a set of independent basis vectors (the equivalent of our phases) and then generate the entire vector space by taking all possible linear combinations of the basis vectors. Alternatively, we can start with an abstract vector space, and then, if we need one, select a basis set. We did the former in previous chapters. We do the latter here. We assume, as we did throughout this book, that all systems of interest are _stationary_ in that all the primitive operators are independent of time [12].

#### 9.2.1 Description of a Single Server

Let \(\mathbf{r}\) be a vector in some discrete (in our case, finite-dimensional) vector space \(\Xi\) that contains all we know about \(S\). Previously, we considered \(\Xi\) to be the set of phases of \(S\) and then constructed the vectors from them. Now, we let \(\Xi\) be the set of all vectors. In doing this we are actually tightening up our mathematics. Keep in mind, though, that not every vector in \(\Xi\) has physical meaning.

Let the "length" of any vector in \(\Xi\) be its "dot product" with a special unique vector from the _adjoint space_\(\Xi^{\prime}\), denoted by \(\boldsymbol{\epsilon^{\prime}}\).1

Footnote 1: Technically, objects in \(\Xi^{\prime}\) are _linear functionals_ that map vectors in \(\Xi\) into the complex numbers. It is well known that this is also a vector space (see, e.g., [13]) and is isomorphic to (i.e., has the same dimension as) \(\Xi\). When one is working with an explicit basis, one thinks of row and column vectors, and the scalar mapping is the dot product.

Then, for one thing,

\[R:=\mathbf{r}\,\boldsymbol{\epsilon^{\prime}}=\text{probability that S is busy.}\]

\(R\) is a measurable quantity, but the components of \(\mathbf{r}\) need not be. From an outside observer's point of view, \(S\) can only be in one of two _external states_: either it is busy or it is not. What goes on inside is hidden from view until \(S\) stops, in which case \(\mathbf{r}\) becomes the null vector, \(\mathbf{o}\). (Of course, if an observer really can look inside, \(S\) must truly be a phase distribution.)

From the basic Markov property, only one thing can happen at a time, and it can only depend on the state the system is in when it happens. Also, a transition that does not change the length of \(\mathbf{r}\) is not directly observable. Let \(\mathbf{P}\) be a linear operator on \(\Xi\) which moderates internal transitions, while \(\mathbf{q^{\prime}}\) moderates completion of service. That is, given that something has occurred, \(\mathbf{rq^{\prime}}\) is the probability that service ended, \(\mathbf{rP}\) is the new state \(S\) is in if service has not ended, and \(\mathbf{rP}\,\boldsymbol{\epsilon^{\prime}}\) is the probability that service did not end. Nothing else can occur, so we must have

\[\mathbf{rq^{\prime}}+\mathbf{r}\,\mathbf{P}\,\boldsymbol{\epsilon^{\prime}}= \mathbf{r}\,\boldsymbol{\epsilon^{\prime}}.\]

<!-- Pages 527-527 -->

the same dimension (call it \(m\)), and because of (9.2.5a), there must exist \(m\) linearly independent vectors, \(\{{\bf r}_{\bf j}!|1\leq j\leq m\}\), in \(\Xi\) for which

\[{\bf r}_{\bf j}\,\mathbf{\epsilon^{\prime}}=1,\quad\mbox{for}\;\;j=1, \,2,\,\ldots,\;m. \tag{9.2.5b}\]

These (or any independent linear combination of them) can be used as the basis set for \(\Xi\). If we so desired, we could pick an appropriate linear combination that makes \({\bf M}\) a diagonal matrix, as discussed in the paragraph following (9.2.2). Note that all bases which satisfy (9.2.5b) must be related to each other by some _isometric transformation_. Let \(\{{\bf r}_{\bf j}\}\) and \(\{\mathbf{\tilde{\bf r}}_{\bf j}\}\) be two bases for \(\Xi\). Then there exists a matrix (or linear transformation) \({\bf S}\) such that

\[{\bf r}_{\bf j}\,{\bf S}=\mathbf{\tilde{\bf r}}_{\bf j}\quad\mbox{for} \;\;j=1,\,2,\,\ldots,\,m, \tag{9.2.5c}\]

and \({\bf S}\mathbf{\epsilon^{\prime}}=\mbox{\boldmath$\epsilon^{\prime}$

<!-- Pages 528-528 -->

(with \(\boldsymbol{\pi}_{\mathbf{r}}\,\boldsymbol{\epsilon}^{\prime}=1\)). We can say that \(\boldsymbol{(\pi}_{\mathbf{r}}\,,\,\mathbf{B}\boldsymbol{)}\) generates the residual process, including, for instance, the mean residual time

\[\boldsymbol{\mathbb{E}}(X_{r})=\boldsymbol{\pi}_{\mathbf{r}}\,\mathbf{V}\, \boldsymbol{\epsilon}^{\prime}=\frac{\mathbf{p}\,\mathbf{V}^{2}\;\boldsymbol{ \epsilon}^{\prime}}{\bar{x}}=\frac{\boldsymbol{\mathbb{E}}(X^{2})}{2\bar{x}}\;. \tag{9.2.7b}\]

\(X_{r}\) is the r.v. denoting the time for service to complete if it is not known when service began.

### 9.3 Networks of Nonexponential Servers

In Section 8.3.2 we described a token, wandering forever in a closed network of nonexponential servers, emitting packets to the outside world in various prescribed manners. Here we revert to the terminology of Chapter 3 where a customer enters a subsystem and after going from server to server, eventually leaves. As discussed in Definition 8.3.1 we are dealing with three different levels of matrices. The difference is that here the customer eventually leaves. In examining this system, we prove that the mean time spent in the subsystem is independent of the service time distributions of the different servers. We also derive a simple expression for the variance of the time spent in the subsystem. This approach was presented in [KonwarLipSleiman06].

#### 9.3.1 Description of System

Consider a network \(S\) with \(M\) nonexponential servers as shown in Figure 9.3.1. Recall from Definition 8.3.1 that:

_Bold-faced Italic_ characters such as \(\boldsymbol{P}\), \(\boldsymbol{p}\), and \(\boldsymbol{e^{\prime}}\) characterize the customer's travel to, and between servers. These operators are \(M\)-dimensional,

**Bold-faced Roman** characters such as \(\mathbf{p_{i}}\), \(\mathbf{P_{i}}\), \(\mathbf{B_{i}}\), \(\mathbf{V_{i}}\), and \(\boldsymbol{\epsilon_{i}^{\prime}}\) describe the customer's passage into and within server \(S_{i}\). These operators are \(m_{i}\)-dimensional;

_Bold-faced CacligRaprice_ characters such as \(\boldsymbol{\varphi}\), \(\boldsymbol{\pi}\), \(\boldsymbol{\mathcal{B}}\), \(\boldsymbol{\mathcal{P}}\), and \(\boldsymbol{\varepsilon^{\prime}}\) represent the sum-space composite system. These are \(M_{m}\)-dimensional, where \(M_{m}=\sum_{i=1}^{M}m_{i}\). We think of \(\boldsymbol{\mathcal{W}}\) as an \(M\times M\) matrix whose elements are also matrices. Element \((\boldsymbol{\mathcal{W}})_{\mathbf{ij}}\) is an \(m_{i}\times m_{j}\) matrix.

The _interserver operators_ are as follows.

\[\boldsymbol{p}=\text{\it System entrance vector},\]

whose \(i\)th component, \(p_{i}=(\boldsymbol{p})_{i}\), is the probability that a customer upon entering \(S\) goes directly to \(S_{i}\). Because the customer must go somewhere, \(\boldsymbol{p}\boldsymbol{e^{\prime}}=1\), where \(\boldsymbol{e^{\prime}}\) is a column \(M\)-vector whose components are all equal to \(1\).

The _interserver transition matrix_ is \(\boldsymbol{P}\), where

\[(\boldsymbol{P})_{ij}=P_{ij}\]

is the probability that the customer, upon leaving \(S_{i}\) goes directly to \(S_{j}\). Given that the customer must eventually leave \(S\), it must be the case that \((\boldsymbol{I}-\boldsymbol{P})\)

<!-- Pages 534-534 -->

Recall that for any distribution \(\sigma^{2}=\mathbb{E}[X^{2}]-\bar{t}^{2}\), \(\mathbb{E}[X^{2}]=2\Psi[\mathbf{V}^{2}]\), and \(C^{2}=\sigma^{2}/\bar{t}^{2}\). These give us

\[[\boldsymbol{T^{(2)}-T}^{2}]_{ii}=\frac{1}{2}\,\bar{t}_{i}^{2}\,\big{[}C_{i}^{ 2}-1\big{]}\,,\]

where \(C_{i}^{2}\) is the squared coefficient of variation for \(S_{i}\). Define the diagonal matrix \(\boldsymbol{\Gamma}\) as

\[[\boldsymbol{\Gamma}]_{ii}:=C_{i}^{2}-1. \tag{9.3.10}\]

Then

\[[\boldsymbol{T^{(2)}-T}^{2}]=\frac{1}{2}\,\boldsymbol{T}^{2}\,\boldsymbol{\Gamma}\]

and

\[\boldsymbol{\varphi}\boldsymbol{\mathcal{V}}^{2}\,\boldsymbol{\varepsilon}^ {\prime}=\boldsymbol{\varphi}\boldsymbol{\mathcal{V}}_{e}^{2}\,\boldsymbol{ \varepsilon}^{\prime}+\frac{1}{2}\boldsymbol{p}\,\boldsymbol{V_{e}}\, \boldsymbol{T}\boldsymbol{\Gamma}\,\boldsymbol{\varepsilon}^{\prime}.\]

We put all this together and get (finally)

\[\sigma^{2}=\sigma_{e}^{2}+\boldsymbol{p}\,\boldsymbol{V_{e}}\,\boldsymbol{T} \,\boldsymbol{\Gamma}\,\boldsymbol{\varepsilon}^{\prime}. \tag{9.3.11}\]

We summarize some of this in the following theorem.

**Theorem 9.3.1:** Let \(S\) be a system of nonexponential servers where \((\boldsymbol{I-P})\) is invertible. Then the time \(X\) spent in \(S\) by a single customer has distribution generated by \((\boldsymbol{\varphi},\,\boldsymbol{\mathcal{B}})\), where \(\boldsymbol{\mathcal{B}}\) is given by (9.3.7a),

\[\boldsymbol{\mathcal{B}}=\boldsymbol{\mathcal{B}}_{o}\,\Big{[}\boldsymbol{ \mathcal{I}-\big{\langle}\,\boldsymbol{P}\big{\rangle}}\Big{]}\,,\]

with inverse given by (9.3.7b),

\[\boldsymbol{\mathcal{V}}=\boldsymbol{\mathcal{B}}^{-1}=\Big{[}\boldsymbol{ \mathcal{I}+\big{\langle}\,\boldsymbol{P}[\boldsymbol{I-P}]^{-1}\big{\rangle} }\Big{]}\,\boldsymbol{\mathcal{V}}_{o},\]

and

\[\boldsymbol{\varphi}=\big{\langle}\,\boldsymbol{p}\,\big{|}\,.\]

The mean and variance are given by (9.3.9a) and (9.3.11), respectively:

\[\mathbb{E}[X]=\boldsymbol{p}\,\big{[}(\boldsymbol{I-P})^{-1}\big{]}\, \boldsymbol{T}\boldsymbol{e}^{\prime}=\boldsymbol{p}\,\boldsymbol{V_{e}}\, \boldsymbol{e}^{\prime},\]

and

\[\sigma^{2}=\sigma_{e}^{2}+\boldsymbol{p}\,\boldsymbol{V_{e}}\,\boldsymbol{T} \,\boldsymbol{\Gamma}\,\boldsymbol{e}^{\prime},\]

where \(\boldsymbol{V_{e}}=(\boldsymbol{I-P})^{-1}\boldsymbol{T}\) and \((\boldsymbol{\Gamma})_{ii}=C_{i}^{2}-1\). Furthermore, in general, \(\mathbb{E}[X^{\ell}]=\ell!\,\boldsymbol{\wp}\,\boldsymbol{\mathcal{V}}^{ \ell}\,\boldsymbol{\varepsilon}^{\prime}\), depends only on the first \(\ell\) moments of each of the \(S_{i}\) through \(\{\,\boldsymbol{T^{(k)}}\,\big{|}\,k\leq\ell\,\}\). For instance, after some effort it can be shown that

\[\big{\langle}\,\boldsymbol{p}\,\big{|}\,\boldsymbol{\mathcal{V}}^{3}\, \big{|}\,\boldsymbol{e}^{\prime}\,\big{\rangle}=\boldsymbol{p}(\boldsymbol{I- P})^{-1}\boldsymbol{T^{(3)}}\,\boldsymbol{e}^{\prime}+\boldsymbol{p}\,\boldsymbol{V_{e}}\, \boldsymbol{P}(\boldsymbol{I-P})^{-1}\boldsymbol{T^{(2)}}\,\boldsymbol{e}^{\prime}\]

\[+\boldsymbol{p}\,(\boldsymbol{I-P})^{-1}\boldsymbol{T^{(2)}}\,\boldsymbol{P }\,\boldsymbol{V_{e}}\,\boldsymbol{e}^{\prime}r+\boldsymbol{p}\,\boldsymbol{V _{e}}\,\boldsymbol{PV_{e}}\,\boldsymbol{P}\,\boldsymbol{V_{e}}\,\boldsymbol{e }^{\prime}.\]

If all servers are exponential, \(\boldsymbol{T_{e}^{(\ell)}}\to\boldsymbol{T}^{\ell}\), and \(\big{\langle}\,\boldsymbol{p}\,\big{|}\,\boldsymbol{\mathcal{V}}^{\ell}\, \big{|}\,\boldsymbol{e}^{\prime}\,\big{\rangle}\,\to\boldsymbol{p}\,\boldsymbol {V_{e}}^{\ell}\boldsymbol{e}^{\prime}\).

Could anything be simpler?

<!-- Pages 535-535 -->

One might ask if setting up all this mathematical apparatus is worth the effort of this theorem, as well as those in Section 8.3.2. It is hoped that in the future this can be used to explore the behavior of a system where more than one customer can be active at a time. If all the servers have one-dimensional representations, \(\Xi\) is one-dimensional and we have a Jackson network, [10], [11], and we have nothing new to contribute. If at least one of the servers needs a higher-dimensional representation, we are into LAQT. If, in particular, exactly one subspace, say \(S_{1}\), is multidimensional, then the problem may be tractable. But If two or more spaces are multidimensional, one can no longer avoid the problems inherent in product space arithmetic.

### Systems With Two Servers

We have no intention at this time of trying to continue our discussion of many-server systems. Thus let us let \(m=2\) hereafter. Our purpose is to show that many of the known results of queueing theory that have matrix formulations (beyond those we discussed in Section 9.1) are invariant to isometric transformations and can be written in a base-free way. We enumerate some results concerning the G/M/1 and M/G/1 queues and then look momentarily at the G/G/1 queue. Finally, we look at some transient behavior in M/G/1 systems, noting that the procedure is completely generalizable.

In a closed loop, \(S_{1}\) and \(S_{2}\) play exactly equivalent roles. But as we have mentioned numerous times before, if the number of customers in the system is so large that one or the other has no likelihood of ever being idle, that subsystem is equivalent to a source of customers to the other. Clearly, for subsystems where only one customer can be served at a time, the one with the smaller maximal throughput will be that subsystem, or server. By convention, we have assumed that \(S_{2}\) has the longer mean service time for M/G/1 and \(G_{2}/G_{1}/1\) queues. But for G/M/1 queues \(S_{1}\) has the longer service time. Let \(G_{i}\) describe the pdf type of server \(S_{i}\). Then we are looking at \(G_{2}/G_{1}/1//N\) loops, and their open extensions [i.e., \(G_{2}/G_{1}/1//(N\to\infty)\) is equivalent to \(G_{2}/G_{1}/1\)].

#### 9.4.1 G/M/1 Queue

We have already shown that the steady-state M/G/1 queue is invariant. The same matrix which governs that system [the matrix \(\mathbf{A}\) of (9.1.1)] also has relevance to the open G/M/1 queue, except that now, as in Chapter 5, \(\rho=1/\varrho=\lambda\bar{x}>1\). For instance, let \(s\) and \(\mathbf{\hat{u}}\) satisfy the eigenvector equation:

\[\mathbf{\hat{u}}\mathbf{A}=s\mathbf{\hat{u}},\] (9.4.1a) where \[s\] is the smallest positive eigenvalue of \[\mathbf{A}\], and \[\mathbf{\hat{u}}\,\boldsymbol{\epsilon}^{\prime}=1\]. We know that \[s<1\] iff \[varrho<1\] ( \[\varrho\] is the utilization factor now). In Theorem 5.1.2, we showed the following, \[r(n)=(1-s)\varrho s^{n-1},\hskip 14.226378ptn>0 \tag{9.4.1b}\]

<!-- Pages 536-536 -->

\[r(0)=1-\varrho. \tag{9.4.1c}\]

Note that the eigenvalues are an invariant property of any matrix. That is, if \(\mathbf{X}\) and \(\mathbf{\tilde{X}}\) are related by an _isometric transformation_, they have the same set of eigenvalues. Also, recall from (5.1.6b) that

\[\mathbf{\hat{u}}=\lambda\mathbf{p}\mathbf{V}[\mathbf{I}+\lambda(1-s)\mathbf{V} ]^{-1}. \tag{9.4.1d}\]

It follows from Corollary 5.1.2 that \(\Psi\left[(\mathbf{I}+\lambda(1-s)\mathbf{V})^{-1}\right]=B^{*}[\lambda(1-s)]=s\). So we even get the famous relation between the Laplace transform and \(s\) without ever knowing what a Riemann\(-\)Stieltjes integral is, and from a base-free matrix algebraic formulation.

Next recall two other distributions related to the G/M/1 queue. The first is the interdeparture time distribution we gave in Section 5.2.2, which is generated by \(\mathbf{(p_{2d}\,,\,B_{2d})}\) where

\[\mathbf{p_{2d}}:=[s\mathbf{\hat{u}},\,1-s]\quad\text{and}\quad\mathbf{B_{2d}}: =\left[\begin{array}{cc}\mathbf{B}&\mathbf{B}\,\boldsymbol{\ell^{\prime}} \\ \mathbf{o}&\lambda\end{array}\right]\bigg{\}}\,(m+1). \tag{9.4.2}\]

The second distribution describes the arrival time conditioned by departures, which is generated by \(\mathbf{(\,\hat{u}\,,\,B\mathbf{)}}\). This is rather interesting, for it tells us that the generator of the arrival process is in composite state \(\mathbf{\hat{u}}\) at the moment a customer leaves the G/M/1 queue, thus giving us a meaning of the eigenvector of \(\mathbf{B}\) belonging to the smallest eigenvalue, \(s\).

**System Time for the M/ME/1 Queue**

The last process we mention here is the system time for the M/G/1 queue. It is generated by the vector-matrix pair (Section 4.2.3) \(\mathbf{(\,p_{s}\,,\,B_{s}\mathbf{)}}\), where

\[\mathbf{B_{s}}:=\mathbf{B}-\lambda\mathbf{Q}\] (9.4.3a) and \[\mathbf{p_{s}}:=(1-\rho)\mathbf{p}(\mathbf{I}-\mathbf{U})^{-1}. \tag{9.4.3b}\]

It is clear that all three distributions

\[\mathbf{(\,\hat{u},\,B\mathbf{)}},\quad\mathbf{(\,p_{d},\,B_{d}\mathbf{)}}, \quad\text{and}\quad

<!-- Pages 540-540 -->

whether \(\rho\) is less than, equal to, or greater than 1, one can then calculate such things as:

1. The mean first-passage time of going from \(n\) to \(n+1\), given that the customer in service has just begun \([\mathbf{pr}\boldsymbol{\tau}_{\mathbf{u}}^{\boldsymbol{\prime}}(n)]\).

2. The mean first-passage time from \(n\) to \(n+1\), given that the queue was originally empty; see (9.4.9) \([t_{u}(n):=\mathbf{p}_{\mathbf{u}}(n)\boldsymbol{\tau}_{\mathbf{u}}^{ \boldsymbol{\prime}}(n)]\).

3. The mean first-passage time, given that a customer has just arrived and found \(n\) customers already there (see Theorem 4.5.2 and its corollaries) \([\boldsymbol{\pi}(n)\boldsymbol{\tau}_{\mathbf{u}}^{\boldsymbol{\prime}}(n)/r (n)]\).

One can even calculate in an efficient way the mean time for a queue to grow to \(n\) for the first time given that a customer has just arrived at an empty queue; namely,

\[t(1\to n):=\sum_{k=1}^{n-1}t_{u}(k). \tag{9.4.11}\]

Note that this is not the same as the first excursion to \(n\) during a busy period (although that too is calculable), because this process allows the queue to empty any number of times before finally reaching its goal.

In like manner one can derive analogous expressions for M/G/C, G/G/1, and even more general systems. The most significant point in this discussion is that all the formulas are expressible in a base-free formulation invariant to isometric transformations. Thus explicit appeal to a "component" interpretation is unnecessary.

### 9.5 Concluding Remarks

We hope we have shown that an approach which is linear algebraic from beginning to end has great potential for covering material that hitherto has been ignored because of the difficulties involved. The ubiquitousness of such an approach appears to depend on the invariance of formulas to isometric transformations. If this is so, one must be prepared to deal with representations that are distinctly not phase distributions. Only then can one study the purely algebraic properties of various systems using a paradigm that is different from what we have been locked into for 50 years or more. Two such research problems are described below.

1. Consider a G/G/1//N queue. In preparing such a system at say \(t=0\), one must initialize both \(S_{1}\) and \(S_{2}\). This would require specifying \(m_{1}+m_{2}\) quantities. That is, we have a sum-space description. But as the system evolves in time, the components from each subspace become correlated with those in the other, thus forcing a complete product-space description (\(m_{1}\cdot m_{2}\) components). However, as van de Liefvoort has shown [11, 12], the key matrix for the steady-state solution, \(\mathbf{U}\) from (9.4.4d), has \(m_{1}\cdot m_{2}-m_{1}-m_{2}+1\) eigenvectors with eigenvalue 1, all of which can be thrown away when calculating the s.s queuelength probabiities \([r(n,N)]\), if one can find an appropriate isometric transformation in the product space (such a transformation exists, finding a general form for it is the problem).

<!-- Pages 542-542 -->

## Symbols

\(\Box\) \(-\) End of definition. D1.1.2 \(\blacksquare\) \(-\) End of Theorem, Lemma, or Corollary. T1.3.2 \(\blacklozenge\)

\(\blacktriangle\) \(-\) End of Example. E2.1.1\(\Box\)

\(A:=B-\)\(A\) is defined by \(B\). S1.1.1 \(\blacklozenge\)

\(\mathbf{A}=\mathbf{I}+\lambda^{-1}\mathbf{B}-\mathbf{Q}\). (4.1.4a)\({}^{*}\)

\(\mathbf{a}(n;\,N)-\) S.s. Arrival prob. vector at \(S_{1}\). D4.1.4

\(a(n;\,N)=\mathbf{a}(n;\,N)\boldsymbol{\epsilon^{\prime}}-\) Scalar prob. associated with \(\mathbf{a}(n;\,N)\). D4.1.4

\(\mathbf{a_{2}}(k;\,N)-\) S.s. Arrival prob. vector at \(S_{2}\). D5.1.3

\(a_{2}(k;\,N)=\mathbf{a_{2}}(k;\,N)\boldsymbol{\epsilon^{\prime}}-\) Scalar prob. associated with \(\mathbf{a_{2}}(k;\,N)\). D5.1.3

\(a_{2}(k;\,N\,|\,C)-\) S.s. Arrival prob. vector at \(S_{2}\) (ME/M/\(C//N\)). D5.4.3

\(\mathbf{B}:=\mathbf{M}(\mathbf{I}-\mathbf{P})-\) Service rate matrix. (3.1.3)

\(\boldsymbol{\mathcal{B}}-\) Generator of interdeparture times for Markov renewal process. S8.2.1

\(B(t)=\)\(\mathbb{P}\mathbf{r}(T\leq t)-\) Probability Distribution Function (PDF). (1.2.2)

\(B^{*}(s)-\) Laplace transform of \(b(t)\). (3.1.10)

\(B_{d}(t;\,N)-\) PDF for interdeparture times (M/ME/1//\(N\)). D4.2.3

\(B_{s}(t)-\) PDF for system time (M/ME/1). D4.2.1

\(b(t)=(d/dt)[B(t)]-\)Probability density function (pdf). (1.2.2)

\(C-\) Number of servers at \(S_{1}\). S5.4, C6\({}^{\lx@sectionsign}\)

\(C_{v}^{2}=\sigma^{2}/\mathbb{E}[X]^{2}-\) Squared coefficient of variation. (1.2.4c)

\(\mathbf{d}(n;\,N)-\) S.s. Vector as seen by departing cust. in M/G/1//N queue. D4.1.5

\(d(n;\,N)=\mathbf{d}(n;\,N)\boldsymbol{\epsilon^{\prime}}-\) Scalar prob. associated with \(\mathbf{d}(n;\,N)\). D4.1.5

\(\mathbf{d_{2}}(k;\,N)-\) S.s. Prob. vector as seen by customer departing \(S_{2}\). D5.1.2

\(d_{2}(k;\,N)=\mathbf{d_{2}}(k;\,N)\boldsymbol{\epsilon^{\prime}}-\) Scalar prob. associated with \(\mathbf{d_{2}}(k;\,N)\). D5.1.2

\(\mathbf{d_{2}}(k;\,N\,|\,C)-\) S.s. Vector for departure from \(S_{2}\) (G/M/\(C//N\)). D5.4.3

\(\mathbb{E}[g(X)]=\int_{\mathrm{o}}^{\infty}\,g(x)\,f_{X}(x)\,dx-\) mean value of \(g(x)\). D1.2.3

\(\mathbf{H_{d}}(n;\,N)-\) Prob. mx. of f.p. from \(n\) to \(n-1\). D4.5.7

\(\mathbf{H_{2d}}(k;\,N)-\) Prob. mx. of f.p. at \(S_{2}\) from \(k\) to \(k-1\). D5.5.3

\(\mathbf{H_{dc}}(n;\,N)-\) Prob. mx. of f.p. from \(n\) to \(n-1\), where \(N\geq n>C\). D6.5.10

\(\mathbf{H_{dk}}(N\,|\,C)-\) Prob. mx. of f.p. from \(k\) to \(k-1\), where \(C\geq x>0\). D6.5.11

\(\mathbf{H_{u}}(n)-\) Prob. mx. of f.p. from \(n\) to \(n+1\). D4.5.1

\(\mathbf{H_{u}}(n\to n+\ell)-\) Prob. mx. of f.p. from \(n\) to \(n+\ell\). D4.5.2

\(\mathbf{H_{uc}}(n)-\) Prob. mx. of f.p. from \(n\) to \(n+1\), where \(n\geq C\). D6.5.7

\(\mathbf{H_{uk}}-\) Related to \(\mathbf{X_{k}}\) by \(\mathbf{X_{k}}=\mathbf{H_{uk}}\,\mathbf{R_{k+1}}\), \(k\ <\ C\). D6.5.6

<!-- Pages 543-543 -->

\(\{\,j;\ n;\ N\,\}-\) A state of an M/ME/1//\(N\) loop (also ME/M/1//\(N\)). D4.1.2 \({\bf K}(N)={\bf I}+{\bf UK}(N-1)\), where \({\bf K}(1)={\bf I}+\lambda{\bf V}\). (4.1.6d) \({\bf K}=({\bf I}-{\bf U})^{-1}\). (4.2.2) \({\bf\cal L}-\) Instantaneous departure rate matrix for semi-markov processes. D8.2.1 \({\bf M}-\) Completion rate matrix. D1.3.6 \({\bf M}_{\bf k}-\) Completion rate matrix for \(k\) active servers (M/ME/\(C\)). D6.3.2 \(N_{i}(t)-\) Number of departures from \(S_{i}\) in interval, \(t\). D4.4.1 \({\bf P}-\) (Substochastic) transition matrix. (3.1.1a) \({\bf P}-\) Transition matrix between subsystems (\({\bf P}{\mathbf{\epsilon}}^{\prime}={\mathbf{\epsilon}}^{ \prime}\)). D1.3.4, S8.3.2 \({\bf P}_{\bf k}-\) Transition mx. for \(k\leq C\) active cust. (M/ME/\(C\)). D6.3.6 \(P_{i}(N)-\) S.s. prob. that \(S_{i}\) is busy in a system with \(N\) cust. D2.1.2 \({\bf p}-\) Entrance vector. S3.1 \({\mathbf{\rho}}={\mathbf{\rho}}{\mathbf{\cal Y}}-\) Left eigenvector of \({\bf\cal Y}\). (8.2.7) \({\bf Pr}[X]-\) Probability that expression "\(X\)" is true. D1.1.2 \({\bf p}_{\bf u}(n)-\) Prob. vector for f.p. from 0 to \(n\) (M/ME/1). D4.5.4 \({\bf p}_{\bf u}(n)-\) Prob. vector for f.p. from 0 to \(n\), with \(k\) active (M/ME/\(C\)). D6.5.8 \(\{\,{\bf p}\,,\ {\bf B}\}-\) Matrix representation of subsystem, \(S\). T3.1.1 \({\mathbf{Q}}-\) Transition rate matrix (Chapter 1 only). (1.3.2c) \({\bf Q}={\mathbf{\epsilon}}^{\prime}{\bf p}\). \({\bf Q}={\mathbf{\cal E}}-\) Generator of underlying semi-Markov process (8.2.8a) \({\bf Q}_{\bf k}-\) Matrix generalization of \({\bf q}^{\prime}\) with \(k\) active cust. (M/ME/\(C\)). D6.3.5 \({\bf q}^{\prime}=({\bf I}-{\bf P}){\mathbf{\epsilon}}^{\prime}-\) Exit vector. (3.1.1a) \(\bar{q}-\) Mean queue length. (1.1.1c) \({\bf R}(t)=\exp(-t{\bf B})-\) Reliability matrix function. D3.1.1 \(R(N)-\)Mean response time in a TS system. T6.3.5 \(R(t)=\Psi[{\bf R}(t)]=1-B(t)-\) Reliability function. S1.2.1, (3.1.7d) \({\bf R}_{\bf k}-\) Matrix generalization of \({\bf p}\) for \(k\) active cust. (M/ME/\(C\)). D6.3.4 \(r(n):=\lim_{N\to\infty}r(n;\,N)-\) S.s. prob. for an open M/G/1 system. (4.2.4a) \(r(n,\,N)={\mathbf{\pi}}(n,\,N){\mathbf{\epsilon}}^{\prime}-\) S.s. prob. for \(n\) cust. at \(S_{1}(\)M/G/1//\(N\)). D4.1.1 \(r_{k}(n,\,N)={\mathbf{\pi}}_{\bf k}(n,\,N){\mathbf{\epsilon}}^{ \prime}_{\bf k}-\) If \(n\geq C\), \(k\!=\!C\), else \(k\!=\!n\) (M/G/\(C//N\)). D6.3.3 \(r_{2}(k,\,N)={\mathbf{\pi}}_{\bf 2}(k,\,N){\mathbf{\epsilon}}^{ \prime}=r(N-k,\,N)\). D5.1.4 \({\bf r}(t)={\bf p}{\bf R}(t)-\) Reliability vector function. D3.1.2 \(\hat{r}(k)-\) Autocorrelation Coefficient, \(lag-k\). (8.2.12c) \(s-\) Geom. parameter for G/M/1 queue; smallest eigenvalue of \({\bf A}\). T5.1.2 \(S_{i}-\) Subsystem labelled \(i\). \(t_{d}(n;\,N)-\) Mean f-p time to drop by 1. D4.5.9 \(t_{d}(k\to 0;\,N)-\) Mean time for \(k\)-busy period. D4.5.10 \(t_{u}(n)-\) Mean f-p time for queue to grow from \(n\) to \(n+1\). D4.5.5 \(t_{u}(0\to n)-\) Mean f-p time for queue to grow from 0 to \(n\). D4.5.6 \({\bf U}={\bf A}^{-1}\). (4.1.4b) \({\bf\hat{a}}-\) Unit eigenvector of \({\bf A}\) going with eigenvalue \(s\) (\({\bf\hat{a}}{\mathbf{\epsilon}}^{\prime}\ =\ 1\)). (5.1.4b) \({\bf V}={\bf B}^{-1}-\) Service-time matrix. (3.1.3) \({\mathbf{\cal V}}={\mathbf{\cal B}}^{-1}-\) Service-time matrix in semi-Markov processes. T8.1.1 \({\bf W}_{\bf d}(n,\,k)-\) Prob. mx. for queue to drop by 1 w.o. exceeding \(k\geq n\). D4.5.16 \(W_{d}(n,\,k;\,N)-\) Prob. for queue to drop 1 w.o. exceeding \(k\!\geq\!n\). D2.3.9

<!-- Pages 544-544 -->

\(\mathbf{W_{d}}(n\!\rightarrow\!n\!-\!\ell;\,k)-\,\) Prob. mx. queue will drop by \(\ell\) w.o. exceeding \(k\). D4.5.17 \(W_{d}(k\to 0;\,N)-\,\) Prob. for queue to drop to 0 w.o. exceeding \(k\). D4.5.17 \(W_{m}(k;\,N)-\,\) Prob. that queue will reach a max. of \(k\) during a b-p. D4.5.17 \(\mathbf{W_{u}}(n)=\mathbf{W_{u}}(n;\,0)-\,\) Prob. mx. for queue to grow by 1 during a b-p. D4.5.14 \(\mathbf{W_{u}}(n;\,k)-\,\) Prob. mx. for queue to grow by 1 w.o. dropping to \(k\). D4.5.11 \(W_{u}(n;\,k)=\Psi[\mathbf{W_{u}}(n;\,k)]\). D4.5.12 \(\mathbf{W_{u}}(n\to n\!+\!\ell;k)-\,\) Prob. mx. for growth by \(\ell\) w.o. dropping to \(k\). D4.5.13 \(W_{u}(n)-\,\) Prob. that queue will grow by 1 during a b-p. D2.3.7 \(\mathbf{W_{u}}(1\to k)-\,\) Prob. mx. for queue to grow to \(k\) during a b-p. D4.5.13 \(W_{u}(1\to k)=-\,\) Prob. that queue will grow to \(k\) during a b-p. D2.3.8 \(W_{u}(1\to k)=\Psi[\mathbf{W_{u}}(1\to k)]\). D4.5.13 \(\mathbf{w}(n;\,N)-\,\)S.s. prob. vector between events (M/G/1 queue). D4.1.3 \(\mathbf{w_{2}}(k;\,N)-\,\)S.s. prob. vector between events, where \(k\) is the no. at \(S_{2}\). D5.4.2 \(\mathbf{X_{k}}-\,\) Prob. mx. of f.p. from \(k\) to \(k+1\) active cust., where \(k<C\). D6.5.5 \(\mathbf{Y_{k}}-\,\) Prob. mx. for going from \(k\) to \(k-1\) active cust., w.o. arrivals. D6.5.2 \(\mathbf{Y_{k}}(\ell)-\,\)Prob. mx. for going from \(k\) to \(k-\ell\) active cust., w.o. arrivals. D6.5.3 \(\mathbf{Y}=\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{L}}-\,\) satisfies \(\boldsymbol{\mathcal{V}}\boldsymbol{\mathcal{E}}^{\prime}=\boldsymbol{ \mathcal{E}}^{\prime}\). (8.2.2) \(\Delta(t)-\,\)Unit step function. (5.1.12b) \(\delta_{ij}-\,\)Kronecker delta. D1.3.2 \(\delta(x)-\,\)Dirac delta function. (3.2.4), (5.1.12a) \(\kappa=\boldsymbol{\pi}\,\boldsymbol{\mathcal{E}}\boldsymbol{\mathcal{E}}^{ \prime}-\,\) Steady-state departure rate in semi-Markov processes. (8.2.8d) \(\Lambda(N)-\,\)System throughput. D2.1.2 \(\mu_{\nu}(\ell)-\,\)Load-dependent service rate. D6.3.8 \(\boldsymbol{\Pi}(n;\,N)-\,\)S.s. vector for \(n\) at \(S_{1}\), and \(N\!-\!n\) at \(S_{2}\) (ME/ME/\(1\!//N\)). D7.3.2 \(\boldsymbol{\pi}(n;\,N)-\,\)S.s. prob. vector of finding \(n\) cust. at \(S_{1}\) (M/ME/\(1\!//N\)). D4.1.1 \(\boldsymbol{\pi}_{\boldsymbol{2}}(k;\,N)-\,\)S.s. prob. vector of finding \(k\) cust. at \(S_{2}\) (ME/M/\(1\!//N\)). D5.1.4 \(\boldsymbol{\pi}_{\boldsymbol{2}}(k;\,N\,|\,C)-\,\)S.s. prob. vector for a generalized ME/M/\(C\!//N\) queue. D5.4.1 \(\boldsymbol{\pi}_{\boldsymbol{2}\boldsymbol{\mathcal{I}}}(k;\,N)-\,\)S.s. prob. vector for an ME/M/\(1/N\) queue. D5.3.1 \(\pi_{i}(t)-\,\)Prob. that system will be in state \(i\in\Xi\) at time \(t\) (Chapter 1). D1.3.2 \(\boldsymbol{\pi}_{\boldsymbol{\tau}}(n;\,N)-\,\)Residual prob. vector (M/ME/\(1\!//N\)). D4.3.1 \(\Psi[\mathbf{X}]:=\mathbf{p}\,\mathbf{X}\,\boldsymbol{\mathcal{E}}^{\prime}\) (for any square mx. \(\mathbf{X}\)). (3.1.5) \(\rho-\,\)Utilization factor \(=\lambda\bar{x}\). (1.1.3), S4.2 \(\varrho-\,\)Utilization factor for G/M/1 queues (\(\varrho=\bar{x}_{2}/\bar{x}_{1}=1\,/\,\rho\)) S5.1 \(\varrho(X,\,Y)-\,\)Correlation coefficient. (8.2.11b) \(\sigma^{2}-\,\)Variance. (1.2.4a) \(\Xi-\,\)Set of states of system. D1.3.1, D4.1.2, D7.3.1 \(\Xi_{k}-\,\)Set of states of subsystem, \(S_{k}\). D6.3.1 \(\boldsymbol{\tau}_{\boldsymbol{\mathrm{d}}}^{\prime}(n;\,N)-\,\)Mean f-p time vector for queue to drop by 1. D4.5.8 \(\boldsymbol{\tau}_{\boldsymbol{\mathrm{2d}}}^{\prime}(k;\,N)-\,\)Mean f-p time vector for queue at \(S_{2}\) to drop by 1. D5.5.4 \(\tau_{d}(n;\,N)-\,\)Mean f-p time for queue to drop by 1 (M/M/\(1\!//N\)). D2.3.4 \(\boldsymbol{\tau}_{\boldsymbol{\mathrm{dk}}}^{\prime}(n;\,N\,|\,C)-\,\)f-p vector for queue to drop by 1 (M/ME/\(C\!//N\)). D6.5.12 \(\boldsymbol{\tau}_{\boldsymbol{\mathrm{u}}}^{\prime}(n)-\,\)Mean f-p time vector for queue to grow by 1. D4.5.3 \(\tau_{u}(n)-\,\)Mean f-p time for queue to grow by 1 (M/M/1). D2.3.2 \(\boldsymbol{\tau}_{\boldsymbol{\mathrm{2u}}}^{\prime}(k)-\,\)Mean f-p time vector for queue at \(S_{2}\) to grow by 1. D5.5.2 \(\boldsymbol{\tau}_{\boldsymbol{\mathrm{uk}}}^{\prime}(n)-\,\)Mean f-p vector for queue to increase by 1 (M/ME/\(C\)). D6.5.9 \(\boldsymbol{\tau}_{\boldsymbol{\mathrm{k}}}^{\prime}-\,\)Departure-time vector with \(k\) active cust., w.o. arrivals (ME/\(C\)). D6.5.1

<!-- Pages 546-546 -->

## Bibliography

* [AbateChoudhuryWhitt96] Abate, J., Choudhury, G.L. and Whitt, W. (1996). On the Laguerre method for numerically inverting Laplace transforms. _INFORMS J. Computing_**8**, 413-427.
* [AbramowitzStegun64] Abramowitz, M. and Stegun, I.A. (1964). _Handbook of Mathematical Functions_. U.S. Government Printing Office, Washington D. C.
* [Allen90] Allen, A.O. (1990). _Probability, Statistics, and Queueing Theory, with Computer Science Applications_, 2nd ed. Academic Press, New York.
* [AntoniosSchwefelLip07] Antonios, I., Schwefel, H-P, and Lipsky, L. (2007). On the correlation and its relationship to performance for ON/OFF network traffic. Tech. Report, Center for Telecommunications, Aalborg University, Denmark.
* [Asmussen03] Asmussen, S. (2003). _Applied Probability and Queues_, 2nd. ed. Springer-Verlag, New York.
* [AsmussenKluppelberg97] Asmussen, S. and C Kluppelberg (1997). Stationary M/G/1 excursions in the presence of heavy tails, _J. Appl. Prob._**34**, 208-212.
* The Science of Self-Organized Criticality_. Springer-Verlag, New York.
* [Basketetal75] Baskett, F., Chandy, K.M., Muntz, R.R., and Palacios, F.G. (1975). Open, closed, and mixed networks of queues with different classes of customers. _Journal of the ACM_, **22**, 2, 248-260.
* [Beutler83] Beutler, F.J. (1983). Mean sojourn times in Markov queueing networks: Little's formula revisited _IEEE Transactions on Information Theory_**29**, 2, March.
* [Burke56] Burke, P.J. (1956). The output of a queueing system. _Operations Research_, **4**, 699-704.
* [Buzen73] Buzen, J.P. (1973). Computational algorithms for closed queueing networks with exponential servers. _Communications of the ACM_, September.
* [BuzenDenning] Buzen, J.P. and Denning, P.J. (1978). The operational analysis of queueing network models. _Computing Surveys_, **10**, 3, 225-261.

<!-- Pages 547-547 -->

* [Carroll79] Carroll, J.L. (1979). _A Study of Closed Queueing Networks with Population Size Constraints_. PhD Dissertation, University of Nebraska, Lincoln.
* [CarrollLipvdL82] Carroll, J.L., Lipsky, L., and van de Liefvoort, A. (1982). Solutions of M/G/1/N-type loops with extension to M/G/1 and GI/M/1 queues. _Operations Research_**30**, 490-514.
* [Chak-Alfa97] Chakravarthy, S.R. and Alfa, A.S., eds. (1997). _Matrix-Analytic Methods in Stochastic Models_ Marcel Dekker, New York.
* [Cohen82] Cohen, J.W. (1982). _The Single Server Queue_, 2nd ed. North Holland, New York.
* [Conte-Deboer80] Conte, S.D. and de Boer, C. (1980). _Elementary Numerical Analysis_, 3rd ed. McGraw-Hill, New York.
* [Cooper81] Cooper, R.B. (1981). _Introduction to Queueing Theory_. 2nd ed. Elsevier North Holland, New York.
* [Courtois77] Courtois, P.J. (1977). _Decomposability; Queueing and Computer System Applications_. Academic Press, New York.
* [Cox55] Cox, D.R. (1955). Use of complex probabilities in the theory of stochastic processes. _Proceedings of the Cambridge Philosophical Society_**51**, 313-319.
* [Cox62] Cox, D.R. (1962). _Renewal Theory_. Menthuen, London.
* [CrovellaBestavros96] Crovella, M. and Bestavros, A. (1996). Self-similarity in World-Wide-Web traffic: Evidence and possible causes. _Performance Evaluation Review_**24**_, 160-169_.
* [Denning78] Denning, P.J., Ed. (1978). Special issue on performance modelling. _Computing Surveys_**10**, 3.
* [Ding91] Ding, Y. (1991). _On Performance Control of Real-Time Systems_. PhD Dissertation, University of Connecticut, Storrs.
* [DisneyKiessler87] Disney, R.L., and Kiessler, P.C. (1987). _Traffic Processes in Queueing Networks: A Markov Renewal Approach_. Johns Hopkins University Press, Baltimore.
* [DuMouchel71] DuMouchel, W.H. (1971). _Stable Distributions in Statistical Inference_. PhD Thesis. University of Michigan, Ann Arbor.
* [Embr-Klup-Mik07] Embrechts, P., Kluppelberg, C. and Mikosch, T. (2007-8th printing). _Modelling Extremal Events for Insurance Claims_. Springer, Berlin.
* [Erlang17] Erlang, A.K. (1917). Solution of some problems in the theory of probabilities of significance in automatic telephone exchanges. _The Post Office Electrical Engineer's Journal_**10** 189-197.

<!-- Pages 548-548 -->

* [FangLipsky82] Fang, Z. and Lipsky, L. (1982). A note on the persistance of the time-dependent solution of an M/M/1/M queue. Tech. report, Department of Computer Science, University of Nebraska, Lincoln.
* [Feller71] Feller, W. (1971). _An Introduction to Probability Theory and Its Applications_, Vol. II., 2nd Ed. John Wiley, New York.
* [FioriniLipvdLHsin95] Fiorini, P. M., Lipsky, L., van de Liefvoort, A. and Hsin, W-J (1995). Auto-correlation lag-\(k\) for customers departing from semi-Markov processes. Tech. report, Technical University-Munchen, January.
* [FioriniLipHatem97] Fiorini, P. M., Lipsky, L. and Hatem, J.E! (1997). Comparison of buffer usage utilizing multiple servers in networks with power-tail distributions. _INFORMS97, Boston, MA_, 30 June-2 July.
* [Fiorini98] Fiorini, P.M. (1998). _Modeling Telecommunication Systems with Self-Similar Data Traffic_. PhD thesis, Department of Computer Science, University of Connecticut, May.
* [LipGargRobbert92] Lipsky, L., Garg, S and Robbert, M. (1992). The effect of power-tail distributions on response times of time-sharing computer systems. _SIGAPP92 Symposium on Applied Computing_ Kansas City, MO, March. Also in _Applied Computing: Technological Challenges of the 1990's_, Vol.II. 719-723. Berghel, H, et al.,Eds., ACM, New York.
* [Glynn-Whitt93] Glynn, P.W., and Whitt, W. (1989). Estensions of the queueing relations \(L=\lambda W\) and \(H=\lambda G\). _Operations Research_**37**, 634-644.
* [Gordon-Newell67] Gordon, W.J. and Newell, G.F. (1967). Closed queueing systems with exponential servers. _Operations Research_**15** 254-265.
* [Graham81] Graham, A. (1981). _Kronecker Products and Matrix Calculus_. Ellis Horwood, Chichester, England.
* [Grein-Job-Lip99] Greiner, M., Jobmann, M. and Lipsky, L. (1999). The importance of power-tail distributions for telecommunication traffic models. _Operations Research_**47**, No.2, 313-326, March.
* [Gross-Harris98] Gross, D. and Harris, C.M. (1998). _Fundamentals of Queueing Theory_, 3rd ed. Wiley-Interscience, New York.
* [Guptaat07] Gupta, V., Harshol-Balter, M., Sigman, K. and Whitt, W. (2007). Analysis of join-the-shortest-queue routing for web server farms. _Performance Evaluation_**64** 1062-1081.
* [Halmos55] Halmos, P.R. (1955). _Finite Dimensional Vector Spaces_ Princeton University Press, Princeton, NJ.

<!-- Pages 549-549 -->

* [Hatem97] Hatem, J.E! (1997). _Comparison Of Buffer Usage Utilizing Single And Multiple Servers In Network Systems With Power-tail Distributions_. PhD Thesis, Department of Computer Science, University of Connecticut, December.
* [Heyman-Sobel82] Heyman, D.P. and Sobel, M.J. (1982). _Stochastic Models in Operations Research_, Vol. 1, McGraw-Hill, New York.
* [Horn-Johnson85] Horn, R.A. and Johnson, C.R. (1985). _Matrix Analysis_. Cambridge University Press, Cambridge UK.
* [Jackson63] Jackson, J.R. (1963). Jobshop-like queueing systems. _Management Science_**10**, 131-142.
* [Jensen67] Jensen, N.E. (1967). An introduction to Bernoullian utility theory, I: utility functions, _Swedish Journal of Economics_**69**, p.163-83.
* [Kant92] Kant, K. (1992). _Introduction to Computer System Performance Evaluation_. McGraw-Hill, New York.
* [Keilson-Nunn79] Keilson, J. and Nunn, W. (1979). Laguerre transformation as a tool for the numerical solution of integral equations of convolution type. _Applied Mathematics and Computation_**5**, 313-359.
* [Kendall52] Kendall, D.G. (1952). Les processus stochastiques de croissance en biologie. _Annales de l'Institut Henri Poincare_, **13**, 43-108.
* [Kendall53] Kendall, D.G. (1953). Stochastic processes occurring in the theory of queues and their analysis by the method of imbedded Markov chains. _Ann. Math. Statist._**24**, 338-354.
* [Kendall64] Kendall, D.G. (1964). Some recent work and further problems in the theory of queues. _Theory of Probability and Its Applications_**9**, 1-15.
* [Khinchine32] Khinchine, A.Y. (1932). Mathematical theory of stationary queues. _Mat. Sbornik_**39**, 73-84.
* [Khinchine60] Khinchine, A.Y. (1960). _Mathematical Methods in the Theory of Queueing_ Griffin, London.
* [Kingman72] Kingman, J. F.C. (1972). _Regenerative Phenomena_. John Wiley, New York.
* [Kleinrock75] Kleinrock, L. (1975). _Queueing Systems, Volume I: Theory_. John Wiley, New York.
* [Klinger97] Klinger, W. (1997). _On the Convergence of Sums of Power-Tail Samples to their \(\alpha\)-Stable Distributions_. MS Thesis, Department of Computer Science, University of Connecticut, August.

<!-- Pages 550-550 -->

* [Klingeretal97] Klinger, W., Greiner, M., Crovella, M., Lipsky, L., Jobmann, M., Fiorini, P. and Schwefel, H-P. (1997). How to model telecommunications (and other) systems where power-Tail behavior is observed: (Background Review and Research Proposal). Technical Report, CSE/BRC, University of Connecticut, May, 1997.
* [KonwarLipSleiman06] Konwar, K. M., Lipsky, L. and Sleiman, M. (2006). Moments of memory access time for systems with hierarchical memories. _21st International Conference on Computers and their Applications_ (CATA-2006), Seattle WA, March.
* [LatoucheTaylor00] Latouche, G. and Taylor, P., eds. (2000). _Advances in Algorithmic Methods for Stochastic Models_. Notable Publications, New Jersey, 2000.
* [Latouche-Ram99] Latouche, G. and Ramaswami, V. (1999). _Introduction to Matrix Analytic Methods in Stochastic Modeling_. SIAM/ASA, Philadelphia Pa.
* Computer System Analysis Using Queueing Network Models_. Prentice Hall, Englewood Cliffs, NJ.
* [Lee-Lief-Wallace00] Lee, Y. D., van de Liefvoort, A. and Wallace, V.L. (2000). Modelling correlated traffic with a generalized ipp _Performance Evaluation_**40**, 99-114.
* [Leland-Ott86] Leland, W. E. and T. Ott (1986). UNIX processor behavior and load balancing among loosely coupled computers. In _Teletraffic Analysis and Computer Performance Evaluation_, O.J. Boxma, J.W. Cohen, and H.C. Tijms, Eds, 191-208, Elsevier, NY.
* [Lelandetal94] Leland, W.E., Taqqu, M., Willinger, W., and Wilson, D.V. (1994). On the self-similar nature of ethernet traffic (extended version). _Proc. of IEEE/ACM Trans. on Networking_, **2**, 1-15, February.
* [Liefvoort82] van de Liefvoort, A. (1982). _An Algebraic Approach to the Steady-state Solution of G/G/1//N-Type Loops_, PhD Thesis, University of Nebraska, Lincoln.
* [Lief-Lip86] van de Liefvoort, A., and Lipsky, L. (1986). A matrix-algebraic solution to two \(K_{m}\) servers in a loop, _Journal of the ACM_**33**, 1, 207-223.
* [Liefvoort87] van de Liefvoort, A. (1987). A sum-space characterization of G/G/1/N-type queues. Technical Report TR-87-5, Computer Science Department, University of Kansas, Lawrence.
* [Liefvoort90] van de Liefvoort, A. (1990). The waiting-time distribution and its moments of the Ph/Ph/1 queue. _Operations Research Letters_, **9**, 261-269.

<!-- Pages 551-551 -->

* [Lipsky-Church77] Lipsky, L. and Church, J.D. (1977). Applications of a queueing network model for a computer system. _Computing Surveys_, **9**, 205-221, September.
* [Lipsky80] Lipsky, L. (1980). A study of time-sharing systems considered as queueing networks of exponential servers. _Computer Journal_**23**, 290-297.
* [LipTehrvdLlieu82] Lipsky, L., Tehranipour, A., van de Liefvoort, A. and Lieu, H. (1982). On the asymptotic behavior of time-sharing systems. _Communications of the ACM_**25**, 707-714, October.
* [Lipsky-Ram85] Lipsky, L. and Ramaswami, V. (1985). A unique minimal representation of Coxian service centers. Technical report, Department of Computer Science, University of Nebraska, Lincoln.
* [Lipsky86] Lipsky, L. (1986). A heuristic fit of an unusual set of data BELCOR Research Report, January.
* [Lipsky-Fang86] Lipsky, L. and Fang, Z. (1986). Classification of functions with rational Laplace transforms _Summer Simulation Conference_, Las Vegas, NV, July.
* [Little61] Little, J.D.C. (1961). A proof of the queueing formula \(L=\lambda W\). _Operations Research_**9**, 383-387.
* [Lowrie-Lip93] Lowry, W. and Lipsky, L. (1993). A model for the probability distribution of medical expenses _Conference of Actuaries in Public Practice_.
* [Markov07] Markov, A.A. (1907). Extension of the limit theorems of probabiliy theory to a sum of variables connected in a chain. _The Notes of the Imperial Academy of Science of St. Petersburg_**XXII**, 9, Physio-Mathematical College.
* [Meier-Fischer92] Meier-Hellstern, K. and Fischer, W. (1992). MMPP cookbook. _Performance Evaluation_**18**, 149-171.
* [MelamedWhitt90] Melamed, B. and Whitt, W. (1990). On arrivals that see time averages. _Operations Research_, **38**, 156-172.
* [Mohamed04] Mohamed, A.M.A-R. (2004). _Performance Based Cluster Architecture: Analytic Modelling and Analysis_. PhD Thesis, Department of Computer Science, University of Connecticut.
* [Molloy89] Molloy, M.K. (1989). _Fundamentals of Performance Modeling_. Macmillan, New York.
* [Morse58] Morse, P.M. (1958). _Queues, Inventories and Maintenance_. John Wiley, New York.

<!-- Pages 552-552 -->

* [Neuts75] Neuts, M.F. (1975). Probability distributions of phase type. _Liber Amicorum Prof. Emeritus H. Florin_, Department of Mathematics, University of Louvain, Belgium, 173-206.
* [Neuts77] Neuts, M.F. (1977). The mythology of the steady state. In _Joint National ORSA-TIMS Meeting_, Atlanta.
* An Algorithmic Approach_. Johns Hopkins University Press, Baltimore.
* [Neuts82] Neuts, M.F. (1982). Explicit steady-state solutions to some elementary queueing models. _Operations Research_**30** 480-489.
* [Neuts89] Neuts, M.F. (1989). _Structured Stochastic Matrices of M/G/1 Type and Their Applications_. Marcel Dekker, New York.
* [O'Cinneide91] O'Cinneide, C.A. (1991). Personal communication. See also Asmussen, S. and O'Cinneide, C.A. (1999). Matrix exponential distributions, _Encyclopedia of Statistical Sciences, Update Volume_, **3**, 435-440, Wiley.
* [Palm43] Palm, C. (1943). Intensitatsschwankungen im fernsprechverkehr. _Ericsson Technics_**44**(3), 189.
* [Park-Will00] Park, K. and Willinger, W., Eds. (2000). _Self-Similar Network Traffic and Performance Evaluation_. Wiley-Interscience, New York.
* [Perros94] Perros, H. (1994). _Queueing Networks with Blocking: Exact and Approximate Solutions_. Oxford University Press.
* [Phillips02] Phillips, K. (2002). _Wealth and Democracy_. Broadway Books, New York.
* [Pollaczek30] Pollaczek, F. (1930). Uber eine Aufgabe der Wahrscheinlichkeitstheorie, I und II. _Mathematische Zeitschrift_**32**, 64-100, 729-750.
* [Ramaswami80] Ramaswami, V. (1980). The N/G/1 queue and its detailed analysis. _Adv. in Appl. Prob._, **12**, 222-261.
* [Ross92] Ross, S. M. (1992). _Applied Probabiity Models with Optimization Applications_. Dover, New York.
* [Ross96] Ross, S. M. (1996). _Stochastic Processes_, 2nd Ed. Wiley, New York.
* [Saito90] Saito, Hiroshi (1990). The departure process of an N/G/1 queue. _Performance Evaluation_**11**, 241-251.
* [Sam-Taqu94] Samorodnitsky, G. and Taqqu, M.S. (1994). _Stable Non-Gaussian Random Processes_. Chapman and Hall, New York.

<!-- Pages 553-553 -->

* [Schwegel00] Schwefel, H-P. (2000). _Performance Analysis of Intermediate Systems Serving Aggregated ON/OFF Traffic with Long-Range Dependent Properties_. PhD Thesis, School of Informatics, Technical University, Munich, Germany, September.
* [Schwegel-Lip01] Schwefel, H-P, and Lipsky, L. (2001). Impact of aggregated, self-similar ON/OFF traffic on delay in stationary queueing models (extended version). _Performance Evaluaton_**43**, 203-221.
* [Stewart95] Stewart, W. J., Ed. (1995). _Computations with Markov Chains_. Klewer Academic Publishers, Boston.
* [Stidham74] Stidham, S.,Jr. (1974). A last word on \(L=\lambda W\). _Operations Research_**22**, 417-421.
* [Takacs62] Takacs, L. (1962). _Introduction to the Theory of Queues_. Oxford University Press, New York.
* [Tehranipour83] Tehranipour, A. (1983). _Explicit Solutions of Generalized M/G/C//N Systems Including an Analysis of Their Transient Behavior_. Ph.D. Thesis, University of Nebraska, Lincoln, December.
* [TehranipourvdLLip89] Tehranipour, A., van de Liefvoort, A., and Lipsky, L. (1989). Residual lifetimes as a function of queue length for M/G/1//N loops. _Joint ACM-IEEE Workshop on Applied Computing '89_, Stillwater, OK.
* [Trivedi82] Trivedi, K.S. (1982). _Probability and Statistics with Reliability, Queueing, and Computer Science Applications_. Prentice Hall, Englewood Cliffs, New Jersey.
* [Trivedi02] Trivedi, K.S. (2002). _Probability and Statistics with Reliability, Queueing, and Computer Science Applications_, 2nd Ed. Wiley-Interscience, New York.
* [Wallace69] Wallace, V.L. (1969). _The Solution of Quasi-Birth and Death Processes Arising from Multiple Access Computer Systems_. PhD Dissertation, University of Michigan, Ann Arbor.
* [Wallace72] Wallace, V.L. (1972). Toward an algebraic theory of Markovian networks. _Proceedings of the Symposium on Computer Communications Networks and Teletraffic_, 397-408.
* [ShermanMorrison50] Sherman, J., and Morrison, W.J. (1950) Adjustment of an inverse marix corresponding to a change in one element of a given matrix. _Annals of Mathematical Statistics_, **21**, 1, 124-127.
* [Wolff82] Wolff, R.W. (1982). Poisson arrivals see time averages. _Operations Research_, **30**, 223-231.

<!-- Pages 554-554 -->

* [Zhang07] Zhang, F. (2007). _Modelling Restricted Processor Sharing in a Computer System with Non-Exponential Service Times_. PhD Thesis, Department of Computer Science, University of Connecticut, December.
* [Zolotarev86] Zolotarev, V.M. (1986). _One-Dimensional Stable Distributions_, V. 65. Translations of Mathematical Monographs, AMS.

<!-- Pages 555-555 -->

## Index

### 1.1 A

absorbing state, 79, 455

accumulation point, 218

adjoint space, 508

aggregation, 387

alpha (\(\alpha\))-stable distribution, 124

alternative MAOOMMP, 484

arrival probability (M/ME/1), 195

arrival rate, 2

arrival time, 159

arriving customer, 45

augmented MMPP, 473

autocorrelation coefficient, 460

autocorrelation lag-k, 461

autocorariance, 460

autocorariance lag-k, 460

average value, 6

### 1.2 B

background Poisson traffic, 481

backup buffer, 44, 216

balance equations, 38, 333, 365

balance equations (M/ME/1), 187

basis set, 26

basis states, 361

basis vector, 26, 361, 505

basis-free formulation, 421

batch arrival process, 301, 477

Bernoulli process, 470

beta function, 162

birth-death process, 36

block vector, 442

blocking, 385

bottleneck, 43

buffer overflow, 44, 207, 311, 502

bulk arrival process, 301, 477

burst of packets, 475

burst parameter, 476

bursty traffic, 474-486

busy period, 66, 262, 263, 353, 355, 417

**C**

canonical representation, 88, 143, 150

cell, 45, 47, 216, 473

cell loss probability, 45, 47, 219

central limit theorem, 121-123

chain, 12, 19

Chapman-Kolmogorov equation, 18-32, 187

characteristic equation, 25

characteristic value, 25

closed system, 13, 33

closure, 77

coefficient of variation (\(C_{v}\)), 16

cold backup, 282, 398, 417

complementary distribution function [\(\bar{F}(t)\)], 15

completeness of ME distributions, 156-157

completion rate matrix, 21, 78

composite space, 464, 513

composite state, 11, 19

conditional mean exceedance, 118

continuous Markov chain, 19

convolution, 57, 89

correlation coefficient, 460

correlation of departures, 458-462

counting process, 160, 464

Coxian server, 88

customer loss, 45, 207, 216, 328

**D**

decomposition, 387

defective distribution, 72, 99, 284

defective function, 299

defective matrix, 25, 94, 99, 103

<!-- Pages 556-556 -->

defective probability measure, 99 defective representation, 150 deflation of a matrix, 427 degeneracy, 25 degenerate hyperexponential, 98, 301 delay stage, 53, 386 delay time, 53 delayed interval, 170 delayed renewal process, 160, 464 density function, 15 departure probability (M/ME/1), 195 departure process (M/M/1), 56-58 departure time, 159 deterministic distribution, 93 Dirac \(\delta\) function, 93, 99, 284, 299 direct product, 486 direct product space, 358, 425 direct sum, 102 direct sum space, 464 discouraged arrivals, 53, 333, 358 discrete Markov chain, 12, 19 distribution function, 14 dot product, 26 down operator, 279 draining a queue, 398 dynamic updating, 418

**E** eigenvalue, 25 embedded Markov chain, 182, 195 embedded matrix, 466 embedding point, 195 ensemble, 29 entrance vector, 79, 509 epoch, 61, 159, 395, 455 equilibrium vector, 27 equivalence of representations, 143 equivalent representations, 104 Erlangian distribution, 81, 88-94 exit vector, 78 expected value, 6, 15 exponential distribution, 14-17 exponential moments, 238, 478, exponential tail, 111, 114, 119 external state, 11, 188, 288 **F** faithful representation, 104 feedback loop, 166 feedforward network, 92 final vector, 263 finite buffer, 34, 45, 219 finite waiting room, 34 first passage, 250 first-passage matrix, 254 first-passage time, 62, 254 first-passage time (ME/M/1), 346-351 first-passage time vector, 255 fixed point iteration, 501 fundamental formula for TS systems, 386 **G** gamma density function, 90 gamma distribution, 90 gamma function, 90 general distribution, 8 generalized Erlangian, 152 generalized exponential, 98, 301 generalized M/G/C//N queue, 54, 357 generalized renewal process, 160, 464 generalized width, 124 generating function, 209 generator of a process, 84 geometric distribution, 17-18 geometric parameter, 293 **H** harmonic series, 396 heavy-tailed distribution, 110-142 holding rate matrix, 21 homogeneous, 254 Horner's rule, 86 hot backup, 398 hyper-Erlangian distribution, 105-107

<!-- Pages 557-557 -->

hyperexponential distribution, 81, 94-99 hypoexponential distribution, 152

**I**

idempotent, 29, 161 ill-behaved function, 113 incomplete gamma function, 241 independence principle, 422 independent variables, 459, 463 infinite variance, 123-128 infinitesimal rate matrix, 21 initial impulse, 98, 299 initial state of the system, 19 initial vector, 85, 263, 509 inner product, 26 interarrival time, 159 interdeparture time, 56, 159, 395 interdeparture time distribution, 455-458 interdeparture time distribution (M/ME/1), 221 internal state, 11, 186, 250, 288 interrupted Poisson process, 475 interserver operator, 465, 512 intraserver operator, 513 invariance of equations, 144, 506 irreducible, 28 isometric matrix, 20, 144, 170, 506 isometric transformation, 144, 155, 484, 506-507, 511, 520

**J**

Jackson network, 9, 357, 358, 384, 488

Jackson network approximation to M/ME/1 loop, 245

**K**

k-busy period, 68 k-busy period (M/M/1), 66-69 k-busy period (M/ME/1), 267 Kendall distribution, 88 Kendall notation, 5 Kronecker delta, 19 Kronecker product, 358, 424-427, 486

**L**

Levy distribution, 115 Levy-Pareto distribution, 115 ladder point, 62 Laguerre polynomial, 240 Laplace transform, 84, 212 Laplace transform (correlated variables), 462 LAQT, 78, 300, 505-512 left eigenvector, 25 length (of a vector), 145 light-tailed, 119 linear functional, 508 linear operator, 81 Little's formula, 1, 3-4, 43, 205, 295 load dependence, 246 load-dependence factor, 50 load-dependent server, 50-56 long-range autocorrelation, 475 long-range dependence, 461 long-tailed distribution, 113

**M**

M/M/1 queue, 33-44 M/ME/1 queue, 200-207 M/ME/1//N loop, 185-200 M/ME/2//N queue, 359 M/ME/C//N queue, 371-384 M/PT/1 queues, 207-208 machine minding model, 34, 386 machine repairman model, 34 Markov arrival process, 453 Markov chain, 12 Markov matrix, 20 Markov modulated Poisson process, 470-473 Markov process, 19 Markov property, 10-12 Markov regulated departure process, 467 Markov renewal process, 399, 453 matrix exponential distribution, 87-110, 152, 510 matrix geometric solution, 192 matrix quadratic equation, 499,

<!-- Pages 558-558 -->

matrix representation, 88 maximum cell loss, 49 ME/M/1 queue, 288-297 ME/M/1/N queue, 324-327 ME/M/C queue, 337 ME/M/X//N loops, 333 ME/ME/1//N loop, 430 mean cell delay, 502 mean CPU time, 133 mean first-passage time, 62, 67, 258, 265, 352 mean lifetime, 15 mean number of customers, 5 mean packet delay, 502 mean residual time, 172 mean residual vector, 169, 401 mean time to failure (MTTF), 282 medium-tailed, 119 memoryless, 17 merging renewal processes, 486 modified augmented OOMMPP, 482 moments of a distribution, 15 MRP/M/1 queues, 498-504 multiple root, 25 multiple server, 50, 333

natural approximation, 387 network of nonexponential servers, 512-519 non-phase distribution, 107-110 normal distribution, 123 normalization matrix, 191 normalized relaxation time, 59 normally distributed, 122

OFF time, 475 ON time, 474 ON-OFF MMPP, 475 ON-OFF process, 473, 476, 478 one-burst process, 475 open system, 33 operational analysis, 247 order statistics, 394 orthogonal functions, 506 orthogonality condition, 25 outer product, 26 outside observer, 13, 81 overflow probability, 46, 216

packet, 45, 47, 216, 473 packet loss probability, 45, 47, 219 Pareto distribution, 115 partition, 70 PASTA, 204 peak rate, 474 periodic, 30 permutation matrix, 145 phase, 77, 509 PHase distribution, 87, 149, 152 PHase representation, 152 physical flow rate, 350 Poisson distribution, 164 Poisson process, 175-176 Pollaczek-Khinchine formula, 204-206, 210 population-size constraints, 358, 384, 387 power-tailed distribution, 114-117 primary buffer, 44 probability amplitude, 506 probability density function, 15 probability distribution function, 14, 83 probability flow rate, 350 probability vector, 19 process rate matrix, 80 process time matrix, 80 processor sharing, 332, 333, 383 product space representation, 222 product-form solution, 9, 357, 384 projection, 427 propagation matrices, 263 proper value, 25 proper vector, 25 PT/M/1 queues, 308-311 pure state, 11, 19, 509

<!-- Pages 559-559 -->

## Appendix Q

quasi birth-death process, 36, 186, 389, 447, 498

queue length, 4, 43

queueing time, 43

random observer, 13

random times, 3

random variable, 15

random walk, 65

range of a distribution, 130, 138

rate matrix, 21, 85, 458

rational Laplace transform, 77, 95

reduced-product space, 358, 488, 521

reducible, 24

regenerative process, 62

regularly varying, 115

relaxation time, 28

relaxation time (M/M/1//N), 58-

reliability function, 14, 82

reliability matrix function, 81, 82

reliability theory, 417

reliability vector function, 82

renewal density, 165

renewal epoch, 159

renewal equation, 165

renewal function, 165

renewal process, 65, 160

renewal theorem, 169

representation of a process, 84

representation theorem, 143

resequencing problem, 357

residual times, 170, 229-232, 348

residual vector, 171, 229, 463

resolvent matrix, 84

response time, 43, 386

restricted processor sharing, 358, 384

right eigenvector, 25

round-robin, 332

rush-hour traffic, 419

\begin{tabular}{l l}
**S** & same shape, 104, 306

same type, 104

scalar product, 26

self-similar, 116, 127, 461

semi-Markov process, 359, 453

semigroup property, 17, 23, 85

service center, 1

service rate, 16

service rate matrix, 80

service time matrix, 80

Sherman-Morrison formula, 201

similar distributions, 104

similarity transformation, 144

simple root, 25

sink state, 79

slowly varying function, 115

sojourn time, 62

spectral decomposition theorem, 26

St. Petersberg paradox, 133

stable distribution, 115, 121, 124

stage, 77

standard deviation, 16

state of a system, 10, 360

state probability vector, 19

state space, 361

state transition rate diagram, 38

state vector, 11

stationary operator, 508

stationary process, 20

steady state, 130

steady-state balance equation, 28

steady-state vector, 27, 28

stochastic matrix, 20

subexponential, 113

substochastic matrix, 20, 78, 454

subsystem, 1, 13

sum space representation, 222

sums of Erlangians, 99-104

superexponential, 114

system, 13

system entrance vector, 512

system exit vector, 513

system throughput, 40, 194

system time, 43

system time distribution, 211

<!-- Pages 560-560 -->

**T**taboo (tabu) process, 70, 269 tail of a function, 111 think stage, 53, 386 think time, 53, 386 thrashing, 387 throughput, 209, 386 time slicing, 332 time to drain, 398 time-sharing computer system, 386 time-sharing stage, 53, 386 time-sharing system, 34, 386 token, 464 total time, 43 tranpsose of a vector, 13 transaction, 386 transient region, 28, 58, 130 transient renewal process, 166 transient state, 24 transition diagram, 38 transition matrix, 20 transition rate matrix, 21 transpose of a vector, 20 truncated power-tailed distribution (TPT), 129-142 unboundedness, 129 uniform distribution, 93 unit step function, 299 unit vector, 361 up and down operators, 276, 279, 403 utilization factor, 5, 200 utilization parameter, 5, 283, 288 **V**variance, 16 vector balance equation, 28 vector space, 505 **W** waiting room, 44 waiting time, 43 Weibull distribution, 113 weighted averages of matrix operators, 232 well-behaved function, 113, 120 **Z** Z-transform, 209