import 'package:hidden_gems_sg/helper/reviews_controller.dart';
import 'package:hidden_gems_sg/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hidden_gems_sg/models/place.dart';
import 'package:flutter_svg/svg.dart';

import '../models/review.dart';

class ReviewsScreen extends StatefulWidget {
  static const routeName = '/exploreReviews';
  final Place place;

  const ReviewsScreen(this.place, {super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool _isLoaded = false;
  final ReviewsController _reviewsController = ReviewsController();

  List<Review> reviews = [];
  List<String> displayNames = [];
  List<String> PFPs = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Widget _topVector() {
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: true,
      child: FittedBox(
        fit: BoxFit.fill,
        child: SvgPicture.asset(
          'assets/img/place-top.svg',
          width: _width,
          height: _width * 116 / 375,
        ),
      ),
    );
  }

  Widget _back() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff22254C),
            ),
            textMinor(
              'back',
              const Color(0xff22254C),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewContainer(
      String userName, String pfp_url, double rating, String review) {
    final _w = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      width: _w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(pfp_url),
                backgroundColor: const Color(0xff6488E5),
                child: Text(userName[0]),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textMinorBold(userName, const Color(0xff22254C), 14),
                  RatingBarIndicator(
                    rating: rating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          textMinor(review, const Color(0xff22254C)),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _review(List<Review> reviews) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              _reviewContainer(
                  displayNames[index],
                  PFPs[index],
                  reviews[index].getUserRating(),
                  reviews[index].getUserReview()),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void _init() async {
    // Get list of reviews (List of Review class)
    reviews = await _reviewsController.returnAllReviews(widget.place.id);

    String tempName = '';
    for (int i = 0; i < reviews.length; i++) {
      tempName = await _reviewsController.getUserName(reviews[i].getUserID());
      displayNames.add(tempName);
    }

    String tempPFP = '';
    for (int i = 0; i < reviews.length; i++) {
      tempPFP = await _reviewsController.getPFP(reviews[i].getUserID());
      PFPs.add(tempPFP);
    }
    print('pfp urls ' + PFPs.toString());

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Scaffold(
            backgroundColor: const Color(0xfffffcec),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _topVector(),
                  _back(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 7,
                        ),
                        textMajor(widget.place.getPlaceName(),
                            const Color(0xff22254C), 36),
                        textMajor(
                            'explorer reviews', const Color(0xff22254C), 36),
                        const SizedBox(
                          height: 10,
                        ),
                        reviews.isEmpty
                            ? textMinor(
                                'no reviews to show',
                                const Color(0xffd1d1d6),
                              )
                            //Actual review list comes from here
                            : _review(reviews),
                        reviews.isEmpty
                            ? Container()
                            : textMinor(
                                'no more to show...',
                                const Color(0xffd1d1d6),
                              ),
                        const SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            color: const Color(0XffFFF9ED),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
