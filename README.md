# Approach
For most problems like this, the first step I take is to write down the requirements and then start to brainstorm some ideas. I find this helps me visualize the data model and potentially start to see the various parts required.

I tried to lean into an API first approach and thinking. I thought about clients calling to various endpoints and wanting to get the data back they desired. I wanted this to also go beyond a POC so I tried to accomodate some of the edge cases I could foresee a user running into.

I left some descriptive commit messages. There's no time like the present to write down why a decision is being made. So if there's a line of code in question I suggest reading the commit message to see if it clears up any confusion.

Thank you for creating some seed data as well! I continued the pattern and added it directly to the file. 🌱

# Decisions
I created an `app/operations` directory as I've found this to be a nice place to hold a lot of the business logic layer. A good example of this is when I realized I was missing some business logic regarding when to show the first question in a survey, so I just added `show_first_question` to `Questions::Sorter` class. It was really easy to add that functionality!

I decided to treat questions with a role_id of `nil` as questions meant for everyone. It felt more natural to do that than have a default `role` assigned to them.

One thing that I wanted to guard against is a user creating a survey with role based questions and the user deleting the question. That's why I created`Questions::RoleQuestionCreator`to help create the default question and `Questions::DefaultRoleQuestionDetector` to tell me if a question needed to be created or not. I currently have this sitting in the controller, but a future refactor could be done to move this within the operation itself.

I debated if I wanted to add another column, possibly called `auto_generated` or the like, to the `questions` table. It would give us an attribute to assign when creating a question automatically for the user, but I decided against it as I didn't need it. This came up if a survey had role based questions and somehow the user created the exact same question as the auto generated one.

Another decision I made was whether or not a question could have many roles. I could see a world where this is a desired feature and it'd save the survey creator from having to create the same question again and assigning it a different role. But for the sake of simplicity I didn't implement this. If I did, a join table is probably most appropriate.

I added a few dependencies to the project [shoulda](https://matchers.shoulda.io) (also known as `shoulda-matchers`) as it is great to validate Active Record validations and associations with their spec matchers. I also introduced [memo_wise](https://github.com/panorama-ed/memo_wise) to help with Ruby memoization. I find it a bit more natural to reach for and it also reliably handles nil and false returns and more. I also use it as a communication tool for other developers that the value isn't going to change so we can memoize it. I don't always do it, but it's a pattern I like.

# Learnings
I learned that not all parts of the application were working. I decided one of the first things I wanted to do was get `rails test` to be green. I like the ability to refactor later and just lean into the test suite.

I haven't worked with minitest much, so it was a bit of a learning curve. My first inclination was to reach for RSpec, as it's what I'm most familiar with. But I saw a handful of tests already written so I figured I'd just keep the pattern of the project. There may be some anti-patterns in there, so forgive me. 😅

If I had more time I'd probably refactor `Questions::Sorter` as it seems like there's opportunity to refine it and possibly split out another class to handle the logic around when to display and omit the first question.

I also discovered at some point that my editor wasn't auto fixing linting issues and that I was using both single quotes and double at times. So I decided to run the `standard` command against the project to unify the styles to not detract from viewing the code.

# Limitations
Time and my lack of knowledge of the frontend. I was able to make some small changes around `TakeSurvey` but unfortunately nothing like I had set out. I tried quite a few times to try to use `useState` to store the initial value of response and then use that to fetch the data from `take_v2` and then refresh the UI with the targeted questions. But I hit my timebox in trying to get it to work.

Another thing I would have liked to implement, is how questions are currently displayed. A number of survey tools only display one question at a time. I've seen some of these survey tools dynamically change the number of questions after a particular response, which makes me believe they have logic under the hood. Personally, I find it a better user experience.
