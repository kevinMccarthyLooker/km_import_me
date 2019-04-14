# Modularization & Baby Blocks™

In Looker modelling, a core principle is: Don't Repeat Yourself

Using views that are not tied to a specific source, along with the extends feature, we can use D.R.Y. to great effect.

# Applicability
We can get *some* reuse of things that we might otherwise repeat in the lookml model, like sql patterns, liquid logic, html, labelling, etc. Potentially much more, like data actions, links, drill_fields, etc, can be more easily applied on a broad scale(in some scenarios)

Separate Pieces of code, and different development efforts, can be kept more indpendent from one another, and from specific data structures.  This should reduce syncronization efforts.

In cases where medium-to-large blocks of repeated code are required, this technique an help reduce the codebase.

*******Make easier subsequent use of things that are already available, like user_attributes, liquids current date, etc.

# Blocks Potential
We can use these technique to create some small analytic and/or customv viz-ish blocks. The may not be incredibly robust, but they'd require very little effort to set up (presuming an otherwise functioning model).
- A few minutes, and a few steps follow, and they should be able to just plug in their data fields.  We could provide a library of tricks and then could toggle(in some cases literally) amongst them.
- Where used, these would build relationship and foothold, since the client would be benefitting from semi-complex functionality/logic on their data, without necessarily having ability to replicate

# We can compound the benefits by with Project Import
- We (or whoever's writing the logic) can maintain these directly, while some other party moves independently. For example, we may like having the option to apply important new looker features to a block and then give the block user the option to upgrade (rather than hoping clients see the update on Discourse).
- Ability for one party to obfuscate(or withhold) a 'feature', while allowing independent development on core model.
- Decouple version control of different pieces of logic
- Establish 'libraries' of shared custom functions, to further empower and engage developer community
- To the degree logic can be modularized, as I understand it we can point to specific past commits such that we can re-test with different combinations of code versions for different features.


# Features POC'd

## Standardized View Basics
Using extends, apply basic things that should be standard across all views

- This example facilitates count(primary key not null) instead of count(*), which is an issue in some outer join scenarios

## Handy liquid date variables
Extend a view, in which we've already made constants such as month(now) available

- Type 'date' IDE and see all sorts of now based timeframes.

## Functions
Put in one or more fields, get a field back that has some 'complex' calculation applied.

- min_maxify(input_field,min,max) => input_field, bounded by min and max, which can be dimensions
- safe_divide(input, divide_by)   => division that handles nulls and avoids trunctation integers
- acronymize(input)               => get the first character of each word

## Custom Tiers
Dev points to a compare_field, and gets any of these he chooses

- paramater where user can enter arbitrary tier breapoints, which we parse and apply to an output field
- parameters for user to enter a number of buckets and get equal sized tiers
- parameters for user to get tiers based on a selected bucket size

## Conditional/Special Formatting
Write/maintain your special html in one place, apply it to many fields.

- 'Tooltipify' - Specify a field whose value will be the tooltip for the input field.
- - Ability to toggle the tooltip visibility with a parameter.
- Apply a custom html format defined in one place to many fields (essentially a copies of those fields).
- - Conditionally format a measure based on a threshold
- - Add a smiley to html if a dimension is over a static threshold.
- More emoji implementations
- - Percents represented as a grid of emojis (100 emojis: smileys to the %, frownies thereafter)
- - Number as emojis, with control over the size of the grid and emoji used.
- - 'Pile' of emojis
- - NPS score represented in emojis (clarify overall number by breaking out and visually comparing promoters, detractors, and neutral responders)

## Key example: Profiling/Consolidated Superset of Measure Values
Create a single field that you'll use on all(?) dimensions to be able to see, in one place, min, max, count null, count distinct, etc.

- Demo-ed another version you would use for numeric fields (as opposed to say dates), which shows Sum and avg.

## Create a lookml dashboard, and let the developer swap in his/her fields
- example still in progress.

## Backlog:
I think these are easy:

- Common links/parts of links.
- Pre-build some arrays of values in liquid... I'm not quite sure all what can be done with that but I feel it could be quite handy
- custom groups /manipulations based on combinations of user attributes. Not necessarily new but easier to leverage broadly.
- Basic Localization.  Like-control logic that toggles $US vs $AU in my 50 financial measures, based on user attribute.  Or worse, a logo needs to appear in many places,but different logos per user.
- user controls their own font size with a user attribute selection
- While not pretty, it could be a simple way for someone to load/update a handful of manual or goal #s, without having dev access or using api.  Upload csv to git (?on top of an existing commit?), and it will be live imported, and you can have a code file that scrapesthat information somehow.

Also probably quite doable:
- Build a great lookml dashboard based on, e.g. two measures, a time_raw, and a few dimensions that the developer assigns as 'input'
- Help set up some data actions

## Notes, Challenges, & Limitations
- Presumably, trying to support support multiple sql dialects, etc, will pose challenges.
- Developer can only really pass sql and text.. or I don't know how we can get more metadata about what reference the developer puts in the extending dummy view
- Join order of the cross joins matters. can't refer to something that's joined later, appparently. I imagine there could be circlular dependency chalenges.
- Note that when using ._sql of another field that might not otherwise be in the query, you may need to use required_fields.  And as ever, be careful referencing dimensions that potentiall can have multuple rows for what would otherwise be a single row.

## Open (or still confirming) questions
- is it better to put the dummy view next to the explore definition? in it's own file? In the file of the view it is most closely related to?
- If we create 50 such fields off of users view, when and how do we want to combine those 50 into one entity so that those could all be used in one explore?
- Consider the tooptip toggle.  How would we get many such fields to share one toggle?
- under what circumstance can you pass liquid variable values between fields (e.g. when you assign then reference?)
- when exactly is required fields necessary?  Note that extra columns in generated sql generally degrades performance.
- When is it better to define defaults vs leaving things blank
- working with dimensions and measures together seems a major challenge
- - resorted to specifying explicitly, and not intermingling them.
- - measures are easier to work with because they don't impact group by...
- - i thought i had a workaround where an input dimension can be wrapped in comments, but the parsed version was also showing in the select clause... maybe if we do that extraction in the final field itself instead of using a helper field we could avoid that..
- - similarly, it's possible to have a single 'input' field, and parse out different delimited entries... but it's awkward and naming fields directly seems much nicer, if more verbose.
