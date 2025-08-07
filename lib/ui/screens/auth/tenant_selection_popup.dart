import 'package:flutter/material.dart';
import '../../../models/pre_login_response.dart';
import '../../../themes/styles/theme_colors.dart';

class TenantSelectionPopup extends StatefulWidget {
  final List<UserData> tenants;
  final Function(UserData) onTenantSelected;

  const TenantSelectionPopup({
    super.key,
    required this.tenants,
    required this.onTenantSelected,
  });

  @override
  State<TenantSelectionPopup> createState() => _TenantSelectionPopupState();
}

class _TenantSelectionPopupState extends State<TenantSelectionPopup> {
  UserData? selectedTenant;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Tenant',
              style: TextStyle(
                fontSize: 16,
                //color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Multiple accounts found. Please select one:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            ...widget.tenants
                .map((tenant) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: RadioListTile<UserData>(
                        value: tenant,
                        groupValue: selectedTenant,
                        onChanged: (UserData? value) {
                          setState(() {
                            selectedTenant = value;
                          });
                        },
                        title: Text(
                          tenant.tenantName ?? 'Unknown Tenant',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${tenant.firstName ?? ''} ${tenant.lastName ?? ''}'
                              .trim(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        activeColor: ThemeColors.primaryColor,
                        dense: true,
                      ),
                    )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: selectedTenant == null
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            widget.onTenantSelected(selectedTenant!);
                          },
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
