# ImportApp

With humility, the import app is done in such a way to demonstrate unique range of capabilities
posessed. The import app implements:

- Upload CSV with detailed, live status reporting
- RSpec testing for various critical parts of the app
- Vanilla jQuery demonstration: operation importer
- React capability demonstration: company data with API backend
- Background job capability demonstration using Sucker Punch (for its simplicity use in this case, I chose Sucker Punch)
- Many to Many relationship for categories and operations
- Download CSV with/without filtered data capabilities

## Some design notes

- I usually use Service object pattern (in app/services) to represent class/module such as the
  operation importer. However, I chose not to here because this ImportApp is an example project.
  The app won't grow and feel okay to "litter" the model's class-level namespace.
- I more familiar with React and Vue than Angular. Therefore some example is done in React
  using the react-rails gem.  However, I think I am a fast learner. (I learned Python and Scala very fast
  even without prior experiences, doing something for the data team/data-related projects).
  I really want to learn the Polish language too if accepted :) that'd be fun.
- I personally prefer JS than CoffeeScript. But I can do CoffeeScript too had it's given preference.
  For me CoffeeScript indeed looks elegant, but ES2015 native script is also sweet to use too.
- I prefer SCSS than SASS, never write in SASS and find it unpleasant/unnatural by way of syntax.
- I prefer slim to haml, or erb
- I normally prefer Sidekiq, never use Resque, sometimes DelayedJob (in the past). Sucker punch only for
  demo/quick one-shot app
- I introduce ImportHistory class-model to take note of the import progress so I can report it online.
  This could be done using ActiveCable, but the Rails app is in Rails 4 and I think it's more than enough
  for this demonstration to use live polling.

Thanks.
