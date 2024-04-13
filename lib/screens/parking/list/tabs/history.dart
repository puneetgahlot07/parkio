import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:parkio/service/parking_service.dart';
import 'package:parkio/widgets/loading.dart';
import 'package:parkio/widgets/parking/history_parking.dart';

import '../../../../model/parking_session/history.dart';
import '../../../../widgets/text.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final _pagingController = PagingController<int, Session>(
    firstPageKey: 1,
  );

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await ParkingService().getParkingHistoryPage(pageKey);

      final previouslyFetchedItemsCount =
          _pagingController.itemList?.length ?? 0;

      final isLastPage =
          previouslyFetchedItemsCount + (newPage.pageSize ?? 0) >=
              (newPage.totalEntries ?? 0);
      final newItems = newPage.sessions;

      if (isLastPage) {
        if (newItems != null) _pagingController.appendLastPage(newItems);
      } else {
        if (newItems != null) {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView.separated(
        pagingController: _pagingController,
        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
        builderDelegate: PagedChildBuilderDelegate<Session>(
          itemBuilder: (_, item, index) => _buildHistoryListItem(item),
          firstPageErrorIndicatorBuilder: (_) => _buildErrorMessage(true),
          newPageErrorIndicatorBuilder: (_) => _buildErrorMessage(false),
          firstPageProgressIndicatorBuilder: (context) => Center(
            child: buildLoadingPlaceholder(context, textColor: Colors.white),
          ),
          newPageProgressIndicatorBuilder: (context) => Center(
            child: buildLoadingPlaceholder(
              context,
              textColor: Colors.white,
              isVertical: false,
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => _buildNoParkingMessage(),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(bool isFirstPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.errorMessage),
            const SizedBox(height: 6.0),
            TextWithLink(
              text: '{${AppLocalizations.of(context)!.retry}}',
              onTap: (_) => isFirstPage
                  ? _pagingController.refresh()
                  : _pagingController.retryLastFailedRequest(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryListItem(Session parking) => ParkingHistoryCard(
        id: parking.id!,
        areaCode: parking.area?.code ?? 0,
        address: parking.area?.address ?? '',
        name: '${parking.area?.name ?? ''} – ${parking.sourceSystem ?? ''}',
        startDate: parking.startTime ?? '',
        endDate: parking.endTime ?? '',
        carName: parking.vehicle?.name,
        numberPlate: parking.vehicle?.licencePlate ?? '',
        totalCost: parking.cost ?? 0,
        onClick: (id) async {}, // TODO: Add onClick behavior
      );

  Widget _buildNoParkingMessage() {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.noHistoryParkingMessage,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
