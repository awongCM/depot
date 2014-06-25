#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
# encoding: utf-8
Product.delete_all
Product.create!(title: 'CoffeeScript',
  description:
    %{<p>
        CoffeeScript is JavaScript done right. It provides all of JavaScript's
  functionality wrapped in a cleaner, more succinct syntax. In the first
  book on this exciting new language, CoffeeScript guru Trevor Burnham
  shows you how to hold onto all the power and flexibility of JavaScript
  while writing clearer, cleaner, and safer code.
      </p>},
  image_url:   'cs.jpg',
  price: 36.00)
# . . .
Product.create!(title: 'Programming Ruby 1.9 & 2.0',
  description:
    %{<p>
        Ruby is the fastest growing and most exciting dynamic language
        out there. If you need to get working programs delivered fast,
        you should add Ruby to your toolbox.
      </p>},
  image_url: 'ruby.jpg',
  price: 49.95)
# . . .

Product.create!(title: 'Rails Test Prescriptions',
  description:
    %{<p>
        <em>Rails Test Prescriptions</em> is a comprehensive guide to testing
        Rails applications, covering Test-Driven Development from both a
        theoretical perspective (why to test) and from a practical perspective
        (how to test effectively). It covers the core Rails testing tools and
        procedures for Rails 2 and Rails 3, and introduces popular add-ons,
        including Cucumber, Shoulda, Machinist, Mocha, and Rcov.
      </p>},
  image_url: 'rtp.jpg',
  price: 34.95)

Product.create!(title: 'Pragmatic Bookshelf',
  description:
    %{<p>
        <em>The Pragmatic Bookshelf</em> publishing imprint is wholly owned by The Pragmatic Programmers, LLC.  Andy Hunt and Dave Thomas founded the company with a simple goal: to improve the lives of developers. We create timely, practical books, audio books and videos on classic and cutting-edge topics to help you learn and practice your craft.  We are not a giant, faceless, greed-soaked corporation. We’re a small group of experienced professionals committed to helping make software development easier.  Our titles do not contain any Digital Restrictions Management, and have always been DRM-free; we pioneered the “beta book” concept; we’ll email your ebook to your Kindle and synch your ebooks amongst your devices via Dropbox, and you can re-download your purchases at any time. We’re here to make your life easier.
      </p>},
  image_url: 'logo.png',
  price: 35.95)

Product.create!(title: 'Ruby on Rails',
  description:
    %{<p>
        <em>Ruby on Rails</em> is an open-source web framework that's optimized for programmer happiness and sustainable productivity. It lets you write beaufitful code by favouring convention over configuration.
      </p>},
  image_url: 'rails.png',
  price: 40.95)

