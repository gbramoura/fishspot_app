import 'package:fishspot_app/widgets/button.dart';
import 'package:fishspot_app/widgets/profile_circle_avatar.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:fishspot_app/models/spot_location.dart';
import 'package:fishspot_app/models/user_profile.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/pages/profile/profile_user_spot_view_page.dart';
import 'package:fishspot_app/providers/settings_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/services/image_service.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:fishspot_app/widgets/profile_image_card.dart';
import 'package:fishspot_app/widgets/profile_info_count.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();
  final ImageService _imageService = ImageService();
  final NavigationService _navigationService = NavigationService();
  final AuthService _authService = AuthService();

  final List<SpotLocation> _userLocations = [];
  final ScrollController _scrollController = ScrollController();

  UserProfile _userProfile = UserProfile(username: '', name: '', email: '');
  bool _loading = false;
  bool _loadingMoreData = false;
  num _pageNumber = 1;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    setState(() {
      _loading = true;
    });

    var settings = Provider.of<SettingProvider>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    try {
      await _authService.refreshCredentials(context);

      HttpResponse userResponse = await _apiService.getUser(token);
      HttpResponse locationsResponse = await _apiService.getUserLocations({
        'PageSize': '12',
        'PageNumber': _pageNumber.toString(),
      }, token);

      _userProfile = UserProfile.fromJson(userResponse.response);

      _pageNumber = 1;
      _userLocations.clear();
      _userLocations.addAll(_parseFishingSpots(locationsResponse.response));
      _scrollController.addListener(_scrollListener);
    } catch (e) {
      if (mounted) {
        _authService.clearCredentials(context);
        _authService.showInternalErrorDialog(context);
      }
    }

    setState(() {
      _loading = false;
    });
  }

  _loadMoreData() async {
    if (_loadingMoreData) {
      return;
    }

    setState(() {
      _loadingMoreData = true;
    });

    var settings = Provider.of<SettingProvider>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    try {
      await _authService.refreshCredentials(context);

      HttpResponse locationsResponse = await _apiService.getUserLocations({
        'PageSize': '12',
        'PageNumber': (_pageNumber + 1).toString(),
      }, token);

      var fishes = _parseFishingSpots(locationsResponse.response);
      if (fishes.isNotEmpty) {
        _pageNumber += 1;
        _userLocations.addAll(fishes);
      }
    } catch (e) {
      if (mounted) {
        _authService.clearCredentials(context);
        _authService.showInternalErrorDialog(context);
      }
    }

    setState(() {
      _loadingMoreData = false;
    });
  }

  _scrollListener() {
    var position = _scrollController.position;
    if (position.pixels == position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  _handleNavigate(String id) {
    var route = MaterialPageRoute(
      builder: (context) => ProfileUserSpotViewPage(spotId: id),
    );

    _navigationService.push(context, route).then((value) {
      if (value == true) {
        _loadUserData();
      }
    });
  }

  _handleEditUser() {
    _navigationService.pushNamed(context, RouteConstants.editUser).then(
      (value) {
        if (value == true) {
          _loadUserData();
        }
      },
    );
  }

  _parseFishingSpots(List<dynamic> jsonList) {
    return jsonList.map((json) => SpotLocation.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _description(),
            _diveder(),
            _spotImages(),
          ],
        ),
      ),
    );
  }

  _description() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: ProfileCircleAvatar(
                  imageUrl: _imageService.getImagePath(
                    context,
                    _userProfile.image ?? "",
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _userProfile.name,
                      softWrap: true,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _userProfile.description ?? "",
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileInfoCount(
                  title: 'Registros',
                  value: _userProfile.spotDetails?.registries ?? 0,
                ),
              ),
              Expanded(
                child: ProfileInfoCount(
                  title: 'Peixes',
                  value: _userProfile.spotDetails?.fishes ?? 0,
                ),
              ),
              Expanded(
                child: ProfileInfoCount(
                  title: 'Iscas',
                  value: _userProfile.spotDetails?.lures ?? 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
            child: Button(
              label: 'Editar Perfil',
              fixedSize: Size(double.maxFinite, 38),
              onPressed: _handleEditUser,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  _spotImages() => _userLocations.isEmpty ? _emptySpots() : _spots();

  _spots() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pescas Registradas',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            primary: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: _userLocations.length,
            itemBuilder: (BuildContext context, int index) {
              var entry = _userLocations[index];
              return ProfileImageCard(
                image: entry.image ?? '',
                title: entry.title,
                onTap: () => _handleNavigate(entry.id),
              );
            },
          ),
        ],
      ),
    );
  }

  _emptySpots() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: double.infinity),
          Text(
            'Pescas Registradas',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 90),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity),
              Icon(
                Icons.no_photography,
                color: Theme.of(context).textTheme.headlineLarge?.color,
                size: 112,
              ),
              Text(
                'Nenhuma pesca \n registrada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headlineLarge?.color,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _diveder() => Divider(
        color: Theme.of(context).iconTheme.color,
        thickness: 0.3,
      );

  _appBar(dynamic context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shadowColor: ColorsConstants.gray350,
      title: Row(
        children: [
          Text(
            'FishSpot',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 22,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            _navigationService.pushNamed(context, RouteConstants.configuration);
          },
          icon: Icon(Icons.menu),
          color: Theme.of(context).textTheme.headlineLarge?.color,
          iconSize: 32,
        ),
        SizedBox(width: 10)
      ],
    );
  }
}
