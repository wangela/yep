# yep

Yep is an iOS app for searching nearby restaurants based on the Yelp API.

Time spent: 27 hours spent in total

## User Stories

The following **required** functionality is completed:
- [x] Table rows should be dynamic height according to the content height.
- [x] Custom cells should have the proper Auto Layout constraints.
- [x] Search bar should be in the navigation bar.
- [x] User can filter by: cuisine, sort (best match, distance, highest rated), distance, and deals (on/off).
- [x] The filters table should be organized into sections as in the mock.
- [x] You can use the default UISwitch for on/off states.
- [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.

The following **optional** features are implemented:

- [x] Infinite scroll for restaurant results
- [ ] Implement map view of restaurant results
- [x] Distance filter should expand as in the real Yelp app.
- [ ] Categories should show a subset of the full list with a "See All" row to expand.
- [ ] Implement the restaurant detail page.
- [x] Implement a custom switch

The following **additional** features are implemented:

- [x] Customize the navigation bar
- [ ] Use Yelp Fusion (v3) API instead of v2 to access additional features and extend longevity past 2018
- [ ] Also sort by number of reviews, filter for Open Now, filter for Hot and New, and choose price categories

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='anim_yep_v1.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes
The collapsible filter took the longest to implement; I wish I had knocked out more of the other optionals before tackling this one.

Using a struct for the data structure helped greatly in keeping things straight. Choosing a good data structure was key for the filters implementation.

I tried to get the v3 API working with my own API keys but it would be more efficient to do this after next week's lesson on OAuth. I also found that the new API doesn't supply rating_image_url so it'd be a little bit of a pain to have to convert the rating decimal to its corresponding image url and it would break down if they move the images (image locations aren't documented in the new API).  I tried two ways, one using the YelpAPI cocoapod (recommended by Yelp) and one using the BDBOAuth1Manager pod. You can see the progress in my "APIv3" branch.

## License

  MIT License

  Copyright (c) 2017 Angela Yu

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
