import 'package:chalet/config/index.dart';
import 'package:chalet/config/routes/routes_definitions.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/index.dart';
import 'package:chalet/widgets/custom_appBars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChaletList extends StatefulWidget {
  const ChaletList({Key? key}) : super(key: key);

  @override
  _ChaletListState createState() => _ChaletListState();
}

class _ChaletListState extends State<ChaletList> with AutomaticKeepAliveClientMixin<ChaletList> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<ChaletModel> chaletList = [];

  void refetchData() {
    getInitData(false);
    _refreshController.refreshCompleted();
  }

  void getInitData(bool listen) async {
    List<ChaletModel> chalets = Provider.of<List<ChaletModel>>(context, listen: listen);
    setState(() {
      chaletList = chalets;
    });
  }

  @override
  void didChangeDependencies() {
    getInitData(true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RoutesDefinitions.ADD_CHALET),
        child: Icon(Icons.add, color: Palette.backgroundWhite),
        backgroundColor: Palette.chaletBlue,
        elevation: 2.0,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: refetchData,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                Dimentions.verticalPadding,
                Dimentions.large + 45,
                Dimentions.verticalPadding,
                Dimentions.verticalPadding,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Najwyżej oceniane',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Palette.ivoryBlack),
                ),
              ),
            ),
            SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: Dimentions.horizontalPadding),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) => GestureDetector(
                    onTap: () => Navigator.pushNamed(context, RoutesDefinitions.CHALET_DETAILS,
                        arguments: ChaletDetailsArgs(chalet: chaletList[index])),
                    child: ChaletPreviewContainer(
                      chalet: chaletList[index],
                    ),
                  ),
                  childCount: chaletList.length,
                ))),
          ],
        ),
      ),
    );
  }
}
