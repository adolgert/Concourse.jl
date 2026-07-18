# Reading Design Questions

Drew's notes:

2.4 Auxiliary draws

The draws for marks and random routing need to be included in the likelihood. They would also be part of how we calculate derivatives. Any randomness in the simulation needs to be included. It is actually possible to include categorical draws in continuous-time simulation by making multiple clocks that all have the same hazard divided by the number of categories. I haven't seen it done because it's usually awkward to define a distribution as having (1/c) times a hazard rate. But that's doable with some kinds of sampling (rejection sampling). Just a thought.

3. Question 1: cloning worlds

Yes, key by something stable such as arrival's position in that source's own sequence. And we can start with marks that don't depend on parameters and treat parameter-dependent marks later.

The auxiliary streams have to be in the world object. They aren't in the sampler of clocks.

4. Question 2: SPA's correction

It sounds like this does need to be derived.
When I work on something like this, I start by writing a LaTeX document about SPA. Walk carefully through the original derivation of SPA because it defines notation for the reader and because it lets you be clearer about WHY certain steps are taken. Books and articles are too terse, and a report on SPA can be very helpful. Then, once that is written, try to figure out how to deal with multi-segment distributions. Use that to finish the document. That document is the definition of done for one step.

And then code can test the theory. For instance, you can make a multi-segment distribution where the segments are actually all the same distribution, treat it as a multi-segment distribution, and compare it with a simulation that has only one distribution of that same type.

Yes, refuse the whole record right now if we can't support any part. That's the right way to communicate with a user.

5. Question 3: IPA over processor-sharing

Yes, sounds like a good test.

6. Question 4: store segment boundaries

I like saving the record as a minimal record of the simulation. In statistics this is called the filtration. If we want to store more information later, we can consider it as an optimization. While developing, stick to the record as is and use reconstruction. That's my instinct.
