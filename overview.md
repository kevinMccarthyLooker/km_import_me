- changing back and forth between dimensions and measures
-  - resorted to specifying explicitly
- join order of these cross joins matters. can't refer to something that's joined latter appparently
- not sure about the standardized input approach

- - NPS

- custom tiers
- - one string param approach.
- - min, max, # tiers (or Tier Size).  Might still be buggy... And how to best make it clear the different options
- - Would like to add a version that handles arbitrary bucket list

- common functions
- - Acronym-ize
- - Safe divide
- - min & maxify field

- Conditional/special Formatting
- - set a cutoff and emoji
- - pile of or boxes of emojis
- - percent as a 10 x 10 box of emojis

- 'Standard' view fields
- - Note: this is different in that the 'real' view directly extends the base
- - Primary_Key field is primary key, and is hidden
- - Count on the primary key

- considering
- - tooltips: tooltipify(measure my_measure,measure tooltip_for_mymeasure)
- - 2 groups, into a only, b only, a & b, and neither
- - Dimension profiling (min, max, avg, total, count nulls, etc)


- limitations
- - Can only really pass sql and text, not, for example type

- questions
- - under what circumstance can you pass liquid variable values between fields (e.g. when you assign then reference?)
- - when exactly is required fields necessary?
- - better to always define defaults?

- need to define:
- - Rules for referencing other fields
- - like: measures can reference measures.
- - and: dimensions can reference measures
- - and: dimensions can only be included if they are one to one with the corresponding field.
